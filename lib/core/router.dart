import 'package:flutter/material.dart';
import 'constants/app_routes.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/example/presentation/pages/example_page.dart';
import 'presentation/pages/not_found_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case AppRoutes.example:
        return MaterialPageRoute(
          builder: (_) => const ExamplePage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        );
    }
  }
}
