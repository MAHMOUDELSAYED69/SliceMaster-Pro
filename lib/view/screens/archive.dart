import 'package:flutter_svg/flutter_svg.dart';
import 'package:slice_master_pro/utils/constants/colors.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/images.dart';
import '../../viewmodel/archive/archive_cubit.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const border = BorderSide(width: 2, color: ColorManager.orange);
    Widget invoiceText(String text) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            style: context.textTheme.displayMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
      );
    }

    Widget headerText(String text) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: context.textTheme.displayMedium),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          SizedBox(width: 5.w),
        ],
        title: SvgPicture.asset(
          ImageManager.logoSVG,
          width: context.width * 0.15,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 5,
            top: 5,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          SizedBox(
            height: context.height * 0.9,
            child: Column(
              children: [
                Container(
                  color: ColorManager.orange,
                  child: Table(
                    border:
                        TableBorder.all(width: 2, color: ColorManager.black),
                    columnWidths: {
                      0: FixedColumnWidth(15.w),
                      4: FixedColumnWidth(30.w),
                      1: FixedColumnWidth(60.w),
                      2: const FlexColumnWidth(),
                      3: FixedColumnWidth(55.w),
                    },
                    children: [
                      TableRow(
                        children: [
                          headerText('.NO'),
                          headerText('Customer Name'),
                          headerText('Items'),
                          headerText('Date & Time'),
                          headerText('Total (EGP)'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ArchiveCubit, ArchiveState>(
                    builder: (context, state) {
                      if (state is ArchiveLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ArchiveLoaded) {
                        return ListView.builder(
                          itemCount: state.list.length,
                          itemBuilder: (context, index) {
                            final invoice = state.list[index];
                            return Column(
                              children: [
                                Table(
                                  border: const TableBorder(
                                    bottom: border,
                                    right: border,
                                    left: border,
                                    verticalInside: border,
                                  ),
                                  columnWidths: {
                                    0: FixedColumnWidth(15.w),
                                    4: FixedColumnWidth(30.w),
                                    1: FixedColumnWidth(60.w),
                                    2: const FlexColumnWidth(),
                                    3: FixedColumnWidth(55.w),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        invoiceText(
                                            invoice.invoiceNumber.toString()),
                                        invoiceText(invoice.customerName),
                                        invoiceText(invoice.items),
                                        invoiceText(
                                            '${invoice.date} - ${invoice.time}'),
                                        invoiceText(
                                            '${invoice.totalAmount} EGP'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No invoices found.'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
