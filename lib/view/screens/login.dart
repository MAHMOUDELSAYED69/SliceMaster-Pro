import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';
import 'package:slice_master_pro/view/widgets/custom_button.dart';
import 'package:slice_master_pro/view/widgets/custom_text_field.dart';

import '../widgets/auth_background.dart';
import '../widgets/text_and_btn.dart';
import '../widgets/welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Column(
        children: [
          SizedBox(height: 50.h),
          const WelcomeBackWidget(),
          SizedBox(height: 10.h),
          Text('Please enter your credentials',
              style: context.textTheme.displaySmall),
          SizedBox(height: 30.h),
          const MyTextFormField(
            title: 'E-Mail',
            hintText: 'Enter your E-Mail',
          ),
          SizedBox(height: 10.h),
          const MyTextFormField(
            keyboardType: TextInputType.visiblePassword,
            hintText: 'Enter your Password',
            title: 'Password',
            obscureText: true,
          ),
          SizedBox(height: 40.h),
          MyElevatedButton(
            title: 'Login',
            onPressed: () {},
          ),
          SizedBox(height: 30.h),
          TextAndButton(
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
