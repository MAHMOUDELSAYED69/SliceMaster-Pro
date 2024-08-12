import 'package:flutter/material.dart';

import '../utils/constants/routes.dart';
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

      default:
        return null;
    }
  }
}
