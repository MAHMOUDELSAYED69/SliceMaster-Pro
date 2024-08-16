import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';

import '../../model/pizza.dart';
import '../../utils/constants/colors.dart';
import '../../viewmodel/calc/calccubit_cubit.dart';

class ActionCard extends StatefulWidget {
  const ActionCard({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    required this.pizza,
  });

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final PizzaModel pizza;

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  PizzaSize _selectedSize = PizzaSize.s;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 15,
      left: 15,
      child: Container(
        height: 15.sp,
        decoration: BoxDecoration(
          color: ColorManager.darkGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Size selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: PizzaSize.values.map((size) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(size.name.toUpperCase(),
                        style: context.textTheme.displaySmall
                            ?.copyWith(color: ColorManager.white)),
                    Radio<PizzaSize>(
                      activeColor: ColorManager.white,
                      value: size,
                      groupValue: _selectedSize,
                      onChanged: (PizzaSize? value) {
                        context.cubit<CalculatorCubit>().setSize(value!);
                        _selectedSize = value;
                        setState(() {});
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            IconButton(
              onPressed: widget.onIncrement,
              icon: Icon(Icons.add, size: 7.sp),
            ),
            IconButton(
              onPressed: widget.onDecrement,
              icon: Icon(Icons.remove, size: 7.sp),
            ),
          ],
        ),
      ),
    );
  }
}
