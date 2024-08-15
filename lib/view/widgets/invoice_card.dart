import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slice_master_pro/model/pizza.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';
import 'package:slice_master_pro/view/widgets/custom_button.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/images.dart';
import '../../viewmodel/calc/calccubit_cubit.dart';
import '../../viewmodel/invoice/invoice_cubit.dart';
import 'custom_text_field.dart';

class InvoiceCard extends StatefulWidget {
  const InvoiceCard({super.key});

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  late GlobalKey<FormState> _formkey;
  String? _customerName;

  @override
  void initState() {
    _formkey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const border = BorderSide(width: 1, color: ColorManager.orange);

    final calculator = context.cubit<CalculatorCubit>();
    final invoice = context.cubit<InvoiceCubit>();

    return Container(
      margin: EdgeInsets.only(right: context.width * 0.04),
      width: context.width / 3.5,
      height: context.height / 1.2,
      decoration: BoxDecoration(
        boxShadow: ShadowManager.shadow,
        color: ColorManager.offWhite2.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              SizedBox(
                width: context.width / 5,
                child: SvgPicture.asset(
                  ImageManager.logo,
                ),
              ),
              SizedBox(height: 25.h),
              BlocBuilder<CalculatorCubit,
                  Map<PizzaModel, Map<PizzaSize, int>>>(
                builder: (context, pizzaCounts) {
                  final filteredPizzaCounts = pizzaCounts.entries
                      .where((entry) =>
                          entry.value.values.any((count) => count > 0))
                      .toList();

                  return Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                _invoiceText('Item'),
                                _invoiceText('Quantity'),
                                _invoiceText('Price'),
                                _invoiceText('Total'),
                              ],
                            ),
                            // Table rows
                            ...filteredPizzaCounts.expand((entry) {
                              final pizza = entry.key;
                              final sizeCounts = entry.value;

                              return sizeCounts.entries
                                  .where((sizeEntry) => sizeEntry.value > 0)
                                  .map((sizeEntry) {
                                final size = sizeEntry.key;
                                final count = sizeEntry.value;
                                final price =
                                    calculator.getPizzaPrice(pizza, size);
                                final totalPrice = price * count;
                                return TableRow(
                                  children: [
                                    _invoiceText(
                                        '${pizza.name} (${size.toString().split('.').last})'),
                                    _invoiceText(count.toString()),
                                    _invoiceText(price.toStringAsFixed(2)),
                                    _invoiceText(totalPrice.toStringAsFixed(2)),
                                  ],
                                );
                              }).toList();
                            }),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _invoiceText(
                            'Total Amount: ${calculator.getTotalPrice().toStringAsFixed(2)} EGP',
                          ),
                        ),
                        if (calculator.getTotalPrice() == 0.0)
                          SizedBox(
                            height: context.height / 2.45,
                            child: Padding(
                              padding: EdgeInsets.only(top: 3.h),
                              child: const Placeholder(
                                strokeWidth: 1.1,
                                color: ColorManager.black,
                              ),
                            ),
                          ),
                        MyTextFormField(
                          hintText: 'Customer Name',
                          onSaved: (data) => _customerName = data,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyElevatedButton(
                              title: 'Get Invoice',
                              onPressed: () {
                                if (_formkey.currentState?.validate() ??
                                    false) {
                                  _formkey.currentState?.save();
                                  invoice.generateInvoice(
                                    pizzaCounts: pizzaCounts,
                                    customerName: _customerName!,
                                  );
                                  calculator.reset();
                                  _formkey.currentState?.reset();
                                }
                              },
                            ),
                            SizedBox(width: 5.w),
                            IconButton(
                              onPressed: () {
                                calculator.reset();
                                _formkey.currentState?.reset();
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: ColorManager.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoiceText(String data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        data,
        style: context.textTheme.displayMedium?.copyWith(
          fontSize: 3.sp,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
