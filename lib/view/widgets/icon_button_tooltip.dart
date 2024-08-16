import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class IconButtonWithTooltip extends StatelessWidget {
  const IconButtonWithTooltip({
    super.key,
    required this.message,
    required this.iconData,
    this.onPressed,
  });

  final String message;
  final IconData iconData;

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      margin: const EdgeInsets.only(top: 5),
      height: 34,
      waitDuration: const Duration(milliseconds: 350),
      exitDuration:const Duration(milliseconds: 150),
      showDuration: const Duration(milliseconds: 350),
      enableTapToDismiss: true,
      message: message,
      decoration: BoxDecoration(
          color: ColorManager.orange, borderRadius: BorderRadius.circular(4)),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(iconData),
      ),
    );
  }
}
