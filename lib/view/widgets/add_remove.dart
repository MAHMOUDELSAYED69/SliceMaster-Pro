import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';

import '../../utils/constants/colors.dart';

class AddAndRemoveCard extends StatefulWidget {
  const AddAndRemoveCard({
    super.key,
    this.onIncrement,
    this.onDecrement,
  });
  final void Function()? onIncrement;
  final void Function()? onDecrement;

  @override
  State<AddAndRemoveCard> createState() => _AddAndRemoveCardState();
}

class _AddAndRemoveCardState extends State<AddAndRemoveCard> {
  PizzaSize? _selectedSize = PizzaSize.S;
  @override
  Widget build(BuildContext context) {
    const white = ColorManager.white;
    const black = ColorManager.black;
    return Positioned(
      bottom: 10,
      child: Container(
        height: 15.sp,
        decoration: BoxDecoration(
          color: ColorManager.darkGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: PizzaSize.values.map((PizzaSize size) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(size.name,
                        style: context.textTheme.displaySmall
                            ?.copyWith(color: ColorManager.white)),
                    Radio<PizzaSize>(
                      activeColor: white,
                      hoverColor: ColorManager.white.withOpacity(0.05),
                      value: size,
                      groupValue: _selectedSize,
                      onChanged: (PizzaSize? value) {
                        setState(() {
                          _selectedSize = value;
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(width: 10),
            IconButton(
              hoverColor: white,
              splashColor: white,
              onPressed: widget.onIncrement,
              icon: Icon(Icons.add, color: black, size: 7.sp),
            ),
            const SizedBox(width: 10),
            IconButton(
              hoverColor: white,
              splashColor: white,
              onPressed: widget.onDecrement,
              icon: Icon(Icons.remove, color: black, size: 7.sp),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

enum PizzaSize { S, M, L }

extension PizzaSizeExtension on PizzaSize {
  String get name {
    switch (this) {
      case PizzaSize.S:
        return 'S';
      case PizzaSize.M:
        return 'M';
      case PizzaSize.L:
        return 'L';
    }
  }
}
