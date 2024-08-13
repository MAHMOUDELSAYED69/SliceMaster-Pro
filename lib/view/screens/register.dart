import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';
import 'package:slice_master_pro/view/widgets/custom_button.dart';
import 'package:slice_master_pro/view/widgets/custom_text_field.dart';

import '../widgets/auth_background.dart';
import '../widgets/text_and_btn.dart';
import '../widgets/auth_headline.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  late GlobalKey<FormState> _formKey;
  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 50.h),
            const AuthHeadline(
              firstText: 'Create an ',
              secondText: 'Account',
              smallText: true,
            ),
            SizedBox(height: 10.h),
            Text('Please set a strong username and password.',
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
            SizedBox(height: 10.h),
            const MyTextFormField(
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Confirm your Password',
              title: 'Confirm Password',
              obscureText: true,
            ),
            SizedBox(height: 40.h),
            MyElevatedButton(
              title: 'Register',
              onPressed: () {},
            ),
            SizedBox(height: 30.h),
            TextAndButton(
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
