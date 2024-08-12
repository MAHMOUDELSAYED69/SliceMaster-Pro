import 'package:flutter/material.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/images.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            ImageManager.authBackground,
            width: context.width,
            height: context.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 50,
            top: 50,
            right: context.width * 0.06,
            child: Container(
              width: context.width / 3,
              decoration: BoxDecoration(
                boxShadow: ShadowManager.shadow,
                color: ColorManager.offWhite2.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: child,
            ),
          )
        ],
      ),
    );
  }
}
