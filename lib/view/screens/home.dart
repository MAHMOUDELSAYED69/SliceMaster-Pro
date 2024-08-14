import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slice_master_pro/utils/constants/images.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          ImageManager.logo,
          width: context.width * 0.15,
        ),
        actions: [
          SizedBox(width: 5.w),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.local_pizza),
          ),
          SizedBox(width: 5.w),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.inventory),
          ),
          SizedBox(width: 5.w),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          ),
          SizedBox(width: 5.w),
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
