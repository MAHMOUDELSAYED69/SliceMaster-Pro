import 'package:flutter/material.dart';

import '../widgets/auth_background.dart';

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
        children: [],
      ),
    );
  }
}
