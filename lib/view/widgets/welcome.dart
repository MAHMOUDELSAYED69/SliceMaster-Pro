import 'package:flutter/material.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';

class WelcomeBackWidget extends StatelessWidget {
  const WelcomeBackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome',
          style: context.textTheme.displayLarge,
        ),
        Text(
          ' back',
          style: context.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
