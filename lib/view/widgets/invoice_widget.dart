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

class InvoiceWidget extends StatefulWidget {
  const InvoiceWidget({super.key});

  @override
  State<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
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
      margin: EdgeInsets.only(right: context.width / 30),
      width: context.width / 4.5,
      height: context.height / 1.2,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, -1),
            color: ColorManager.orange.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              SvgPicture.asset(
                ImageManager.logo,
                height: 150,
              ),
              SizedBox(height: 10.h),
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
                            height: context.height / 3,
                            child: Padding(
                              padding: EdgeInsets.only(top: 3.h),
                              child: const Placeholder(
                                strokeWidth: 1,
                                color: ColorManager.orange,
                              ),
                            ),
                          ),
                        MyTextFormField(
                          hintText: 'Customer Name',
                          onSaved: (data) => _customerName = data,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: MyElevatedButton(
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
                            ),
                            IconButton(
                              onPressed: () {
                                calculator.reset();
                                _formkey.currentState?.reset();
                              },
                              hoverColor: ColorManager.grey.withOpacity(0.2),
                              icon: const Icon(Icons.refresh),
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
        style: context.textTheme.displayMedium?.copyWith(fontSize: 3.sp),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
