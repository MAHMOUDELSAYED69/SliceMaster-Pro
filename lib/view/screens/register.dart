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
    _passwordController = TextEditingController();
    super.initState();
  }

  late GlobalKey<FormState> _formKey;
  late TextEditingController _passwordController;

  String? _validatePassword(value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

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
              SizedBox(height: 54.h),
              const AuthHeadline(
                firstText: 'Create an ',
                secondText: 'Account',
                smallText: true,
              ),
              SizedBox(height: 12.h),
              Text('Please set a strong username and password.',
                  style: context.textTheme.displaySmall),
              SizedBox(height: 30.h),
              MyTextFormField(
                onSaved: (data) => _username = data,
                title: 'Username',
                hintText: 'Enter your Username',
              ),
              SizedBox(height: 10.h),
              MyTextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter your Password',
                title: 'Password',
              ),
              SizedBox(height: 10.h),
              MyTextFormField(
                onSaved: (data) => _password = data,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Confirm your Password',
                title: 'Confirm Password',
                obscureText: true,
                validator: _validatePassword,
              ),
              SizedBox(height: 40.h),
              MyElevatedButton(
                title: 'Register',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    debugPrint('Username: $_username, Password: $_password');
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(height: 30.h),
              TextAndButton(
                buttonText: 'Sign In',
                text: 'Already have an account? ',
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
