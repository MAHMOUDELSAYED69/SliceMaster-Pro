import 'package:flutter/material.dart';
import 'package:slice_master_pro/view/screens/home.dart';

import '../utils/constants/routes.dart';
import '../view/screens/login.dart';
import '../view/screens/register.dart';
import '../view/screens/splash.dart';
import 'page_transition.dart';

abstract class AppRouter {
  const AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteManager.initialRoute:
        return PageTransitionManager.fadeTransition(
          const SplashScreen(),
        );

      case RouteManager.login:
        return PageTransitionManager.fadeTransition(
          const LoginScreen(),
        );
      case RouteManager.register:
        return PageTransitionManager.fadeTransition(
          const RegisterScreen(),
        );

      case RouteManager.home:
        return PageTransitionManager.fadeTransition(
          const HomeScreen(),
        );

      default:
        return null;
    }
  }
}
