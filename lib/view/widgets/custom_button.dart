import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    this.title,
    this.onPressed,
    this.widget,
    this.size,
    this.fontSize,
    this.backgroundColor,
    this.isDisabled,
  });
  final bool? isDisabled;
  final String? title;
  final VoidCallback? onPressed;
  final Size? size;
  final Widget? widget;
  final double? fontSize;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: context.elevatedButtonTheme.style?.copyWith(
          fixedSize: WidgetStatePropertyAll(
            size ?? Size(context.width, 40.h),
          ),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          overlayColor: WidgetStatePropertyAll(backgroundColor),
        ),
        onPressed: isDisabled == true ? null : onPressed,
        child: widget ??
            Text(
              title ?? "",
              style: context.textTheme.displaySmall,
            ));
  }
}
