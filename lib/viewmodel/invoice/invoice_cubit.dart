import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart' show PdfColor;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:slice_master_pro/model/pizza.dart';
import 'package:slice_master_pro/repositories/pizzas.dart';
import 'dart:typed_data';

import '../../database/sql.dart';
import '../../utils/constants/images.dart';
import '../../utils/helpers/shared_pref.dart';

part 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceInitial());
  final SqlDb _sqlDb = SqlDb();

  Future<void> generateInvoice(
      {required Map<PizzaModel, int>? pizzaCounts,
      required String customerName}) async {
    if (pizzaCounts != null && pizzaCounts.isNotEmpty && pizzaCounts != {}) {
      final pdf = pw.Document();
      final textColor = PdfColor.fromHex('#352300');

      final Uint8List logoBytes = await rootBundle
          .load(ImageManager.splashImage)
          .then((value) => value.buffer.asUint8List());

      final List<List<String>> data =
          pizzaCounts.entries.where((entry) => entry.value != 0).map((entry) {
        final juice = entry.key;
        final price = juice.mediumPrice;
        final quantity = entry.value;
        final total = price * quantity;
        return [
          juice.name,
          price.toStringAsFixed(2),
          '0.00',
          '0.00',
          total.toStringAsFixed(2),
          quantity.toString()
        ];
      }).toList();

      final totalAmount =
          data.fold<double>(0, (sum, item) => sum + double.parse(item[4]));
      const tax = 0.00;
      final grandTotal = totalAmount + tax;

      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final formattedTime = DateFormat('HH:mm:ss').format(now);

      // Get the next invoice number for the user
      int? invoiceNumber = await _sqlDb
          .getNextInvoiceNumber(CacheData.getData(key: 'currentUser'));

      if (invoiceNumber == null) {
        invoiceNumber = 1;
        debugPrint('Error: Invoice number is null');
        // return pdf;
      }

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(
                  pw.MemoryImage(logoBytes),
                  width: 200,
                  height: 200,
                ),
                pw.SizedBox(height: 5.h),
                pw.Text('City Road - empty',
                    style: pw.TextStyle(fontSize: 14, color: textColor)),
                pw.Text('Phone: 01061172139',
                    style: pw.TextStyle(fontSize: 14, color: textColor)),
                pw.Text('Tax Number: 000002',
                    style: pw.TextStyle(fontSize: 14, color: textColor)),
                pw.SizedBox(height: 5.h),
                pw.BarcodeWidget(
                  color: textColor,
                  barcode: pw.Barcode.code128(),
                  data: '000000000000002',
                  width: 300,
                  height: 60,
                ),
                pw.Text('Invoice Number: $invoiceNumber',
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: textColor)),
                pw.SizedBox(height: 5.h),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('Date: $formattedDate',
                          style: pw.TextStyle(fontSize: 14, color: textColor)),
                      pw.SizedBox(width: 5.h),
                      pw.Text('Time: $formattedTime',
                          style: pw.TextStyle(fontSize: 14, color: textColor)),
                    ]),
                pw.SizedBox(height: 5.h),
                pw.Text('Customer Name: $customerName',
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: textColor)),
                pw.SizedBox(height: 5.h),
                pw.Table.fromTextArray(
                  context: context,
                  border: pw.TableBorder.all(color: textColor),
                  headers: <String>[
                    'Item',
                    'Price (EGP)',
                    'Tax (EGP)',
                    'Discount (EGP)',
                    'Total (EGP)',
                    'Quantity'
                  ],
                  cellStyle: pw.TextStyle(color: textColor),
                  headerStyle: pw.TextStyle(color: textColor),
                  data: data,
                ),
                pw.SizedBox(height: 5.h),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            'Total Amount: ${totalAmount.toStringAsFixed(2)} EGP',
                            style:
                                pw.TextStyle(fontSize: 14, color: textColor)),
                        pw.Text('Tax: ${tax.toStringAsFixed(2)} EGP',
                            style:
                                pw.TextStyle(fontSize: 14, color: textColor)),
                        pw.Text(
                            'Grand Total: ${grandTotal.toStringAsFixed(2)} EGP',
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: textColor)),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
      await PizzasRepository.instance.saveInvoice(
        invoiceNumber: invoiceNumber,
        customerName: customerName,
        formattedDate: formattedDate,
        formattedTime: formattedTime,
        items: pizzaCounts.entries
            .where((entry) => entry.value != 0)
            .map((e) => '${e.key.name} x${e.value}')
            .join(', '),
        totalAmount: totalAmount,
        userName: CacheData.getData(key: 'currentUser'),
      );
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
      // return pdf;
    }
    return;
  }
}
    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => pdf.save(),
    // );