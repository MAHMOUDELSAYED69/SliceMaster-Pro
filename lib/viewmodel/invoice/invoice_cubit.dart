import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' show PdfColor;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:slice_master_pro/model/pizza.dart';
import 'package:slice_master_pro/repositories/pizzas.dart';
import 'package:slice_master_pro/viewmodel/calc/calccubit_cubit.dart';
import 'dart:typed_data';

import '../../database/sql.dart';
import '../../utils/constants/images.dart';
import '../../utils/helpers/shared_pref.dart';

part 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceInitial());
  final SqlDb _sqlDb = SqlDb();

  Future<void> generateInvoice({
    required Map<PizzaModel, Map<PizzaSize, int>> pizzaCounts,
    required String customerName,
    num? discount,
  }) async {
    if (pizzaCounts.isEmpty) {
      emit(InvoiceError(errMessage: 'No pizza counts provided.'));
      return;
    }
    final pdf = pw.Document();
    final textColor = PdfColor.fromHex('#000000');

    final Uint8List logoBytes = await rootBundle
        .load(ImageManager.logoPNG)
        .then((value) => value.buffer.asUint8List());

    final List<List<String>> data = [];
    num totalAmount = 0;
    pizzaCounts.forEach((pizza, sizeCounts) {
      sizeCounts.forEach((size, count) {
        if (count > 0) {
          String pizzaSize = '';
          num price;
          switch (size) {
            case PizzaSize.s:
              price = pizza.smallPrice;
              pizzaSize = 'S';
              break;
            case PizzaSize.m:
              price = pizza.mediumPrice;
              pizzaSize = 'M';
              break;
            case PizzaSize.l:
              price = pizza.largePrice;
              pizzaSize = 'L';
              break;
            default:
              price = pizza.mediumPrice;
              break;
          }

          final total = price * count;
          totalAmount += total;

          data.add([
            '${pizza.name} ($pizzaSize)',
            price.toStringAsFixed(2),
            '0.00',
            '0.00',
            total.toStringAsFixed(2),
            count.toString(),
          ]);
        }
      });
    });

    const tax = 0.00;
    final grandTotal = totalAmount + tax;

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedTime = DateFormat('HH:mm:ss').format(now);

    int? invoiceNumber = await _sqlDb
        .getNextInvoiceNumber(CacheData.getData(key: 'currentUser'));

    if (invoiceNumber == null) {
      emit(InvoiceError(errMessage: 'Failed to retrieve invoice number.'));
      return;
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
              pw.SizedBox(height: 20),
              pw.Text('City Road - empty',
                  style: pw.TextStyle(fontSize: 14, color: textColor)),
              pw.Text('Phone: 01061172139',
                  style: pw.TextStyle(fontSize: 14, color: textColor)),
              pw.Text('Tax Number: 000002',
                  style: pw.TextStyle(fontSize: 14, color: textColor)),
              pw.SizedBox(height: 5),
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
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('Date: $formattedDate',
                      style: pw.TextStyle(fontSize: 14, color: textColor)),
                  pw.SizedBox(width: 5),
                  pw.Text('Time: $formattedTime',
                      style: pw.TextStyle(fontSize: 14, color: textColor)),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Text('Customer Name: $customerName',
                  style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: textColor)),
              pw.SizedBox(height: 5),
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
                cellStyle: pw.TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
                headerStyle: pw.TextStyle(
                  color: textColor,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
                data: data,
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          'Total Amount: ${totalAmount.toStringAsFixed(2)} EGP',
                          style: pw.TextStyle(fontSize: 14, color: textColor)),
                      pw.Text('Tax: ${tax.toStringAsFixed(2)} EGP',
                          style: pw.TextStyle(fontSize: 14, color: textColor)),
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
      discount: discount ?? 10,
      invoiceNumber: invoiceNumber,
      customerName: customerName,
      formattedDate: formattedDate,
      formattedTime: formattedTime,
      items: pizzaCounts.entries
          .expand((entry) => entry.value.entries
                  .where((sizeEntry) => sizeEntry.value > 0)
                  .map((sizeEntry) {
                return '${entry.key.name} (${sizeEntry.key == PizzaSize.s ? 'Small' : sizeEntry.key == PizzaSize.m ? 'Medium' : sizeEntry.key == PizzaSize.m ? 'Large' : ''}) x${sizeEntry.value}';
              }))
          .join(', '),
      totalAmount: totalAmount.toDouble(),
      userName: CacheData.getData(key: 'currentUser'),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
    debugPrint('Invoice generated.');
    emit(InvoiceGenerated());
  }
}

    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => pdf.save(),
    // );