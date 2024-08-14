import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';
import 'package:slice_master_pro/view/widgets/custom_button.dart';
import 'package:slice_master_pro/view/widgets/custom_text_field.dart';

import '../../utils/constants/routes.dart';
import '../widgets/auth_background.dart';
import '../widgets/text_and_btn.dart';
import '../widgets/auth_headline.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  late GlobalKey<FormState> _formKey;

  String? _username;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              const AuthHeadline(),
              SizedBox(height: 10.h),
              Text('Please enter your credentials.',
                  style: context.textTheme.displaySmall),
              SizedBox(height: 30.h),
              MyTextFormField(
                onSaved: (data) => _username = data,
                title: 'Username',
                hintText: 'Enter your Username',
              ),
              SizedBox(height: 10.h),
              MyTextFormField(
                onSaved: (data) => _password = data,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter your Password',
                title: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 40.h),
              MyElevatedButton(
                title: 'Login',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    debugPrint('Username: $_username, Password: $_password');
                    Navigator.pushReplacementNamed(context, RouteManager.home);
                  }
                },
              ),
              SizedBox(height: 30.h),
              TextAndButton(
                onTap: () =>
                    Navigator.pushNamed(context, RouteManager.register),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
