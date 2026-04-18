import 'package:flutter/material.dart';
import 'constants/app_routes.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/profile/domain/entities/profile.dart';
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
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        );
      case AppRoutes.profile:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProfilePage(userId: userId),
        );
      case AppRoutes.editProfile:
        final profile = settings.arguments as Profile;
        return MaterialPageRoute(
          builder: (_) => EditProfilePage(profile: profile),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        );
    }
  }
}
