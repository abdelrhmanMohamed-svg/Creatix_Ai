import 'package:creatix/features/brands/presentation/pages/brands_page.dart';
import 'package:creatix/features/brands/presentation/pages/create_brand_page.dart';
import 'package:creatix/features/brands/presentation/pages/update_brand_page.dart';
import 'package:creatix/features/brand_kit_wizard/presentation/pages/brand_kit_wizard_page.dart';
import 'package:flutter/material.dart';
import 'constants/app_routes.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/profile/domain/entities/profile.dart';
import '../features/profile/presentation/cubit/profile_cubit.dart';
import 'presentation/pages/not_found_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.brands:
        return MaterialPageRoute(builder: (_) => const BrandsPage());
      case AppRoutes.createBrand:
        return MaterialPageRoute(builder: (_) => const CreateBrandPage());
      case AppRoutes.updateBrand:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => UpdateBrandPage(
            brandId: args?['brandId'] ?? '',
            initialName: args?['initialName'] ?? '',
            initialLogoUrl: args?['initialLogoUrl'],
          ),
        );
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.profile:
        final userId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ProfilePage(userId: userId));
      case AppRoutes.editProfile:
        final args = settings.arguments as Map<String, dynamic>;
        final profile = args['profile'] as Profile;
        final cubit = args['cubit'] as ProfileCubit;
        return MaterialPageRoute(
          builder: (_) => EditProfilePage(profile: profile, cubit: cubit),
        );
      case AppRoutes.brandKitWizard:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BrandKitWizardPage(
            brandId: args?['brandId'] ?? '',
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
