import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slice_master_pro/persentation/screens/home.dart';
import 'package:slice_master_pro/persentation/screens/pizza_management.dart';
import 'package:slice_master_pro/persentation/viewmodel/excel/excel_cubit.dart';
import 'package:slice_master_pro/persentation/viewmodel/repository/pizza_cubit.dart';

import '../../utils/constants/routes.dart';
import '../../persentation/screens/archive.dart';
import '../../persentation/screens/login.dart';
import '../../persentation/screens/register.dart';
import '../../persentation/screens/splash.dart';
import '../../persentation/viewmodel/archive/archive_cubit.dart';
import '../../persentation/viewmodel/calc/calccubit_cubit.dart';
import '../../persentation/viewmodel/image/image_cubit.dart';
import '../../persentation/viewmodel/invoice/invoice_cubit.dart';
import '../../persentation/viewmodel/login/login_cubit.dart';
import '../../persentation/viewmodel/logout/logout_cubit.dart';
import '../../persentation/viewmodel/register/register_cubit.dart';
import 'page_transition.dart';

abstract class AppRouter {
  const AppRouter._();
  static final _pizzasRepositoryCubit = PizzasRepositoryCubit();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteManager.initialRoute:
        return PageTransitionManager.fadeTransition(
          BlocProvider(
            create: (context) => AuthStatusCubit(),
            child: const SplashScreen(),
          ),
        );

      case RouteManager.login:
        return PageTransitionManager.fadeTransition(BlocProvider(
          create: (context) => LoginCubit(),
          child: const LoginScreen(),
        ));

      case RouteManager.register:
        return PageTransitionManager.fadeTransition(BlocProvider(
          create: (context) => RegisterCubit(),
          child: const RegisterScreen(),
        ));

      case RouteManager.home:
        return PageTransitionManager.fadeTransition(MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => InvoiceCubit(),
            ),
            BlocProvider.value(value: _pizzasRepositoryCubit..loadUserPizzas()),
            BlocProvider(
              create: (context) => AuthStatusCubit(),
            ),
            BlocProvider(
              create: (context) => CalculatorCubit(),
            ),
          ],
          child: const HomeScreen(),
        ));
      case RouteManager.pizzaManagement:
        return PageTransitionManager.fadeTransition(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _pizzasRepositoryCubit),
              BlocProvider(
                create: (context) => PickImageCubit(),
              ),
            ],
            child: const PizzaManagementScreen(),
          ),
        );
      case RouteManager.archive:
        return PageTransitionManager.fadeTransition(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => ArchiveCubit()..fetchInvoices()),
              BlocProvider(create: (context) => ExcelCubit()),
            ],
            child: const ArchiveScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
