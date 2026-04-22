import 'package:creatix/features/brands/presentation/pages/brands_page.dart';
import 'package:creatix/features/brands/presentation/pages/create_brand_page.dart';
import 'package:creatix/features/brands/presentation/pages/update_brand_page.dart';
import 'package:creatix/features/brand_kit_wizard/presentation/pages/brand_kit_wizard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/app_routes.dart';
import 'di/injection.dart';
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
        if (args == null || args['brandId'] == null) {
          return MaterialPageRoute(builder: (_) => const NotFoundPage());
        }
        return MaterialPageRoute(
          builder: (_) => UpdateBrandPage(
            brandId: args['brandId'] as String? ?? '',
            initialName: args['initialName'] as String? ?? '',
            initialLogoUrl: args['initialLogoUrl'] as String?,
          ),
        );
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.profile:
        final userId = settings.arguments as String?;
        if (userId == null || userId.isEmpty) {
          return MaterialPageRoute(builder: (_) => const NotFoundPage());
        }
        return MaterialPageRoute(builder: (_) => ProfilePage(userId: userId));
      case AppRoutes.editProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['profile'] == null) {
          return MaterialPageRoute(builder: (_) => const NotFoundPage());
        }
        final profile = args['profile'] as Profile;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileCubit>(),
            child: EditProfilePage(profile: profile),
          ),
        );
      case AppRoutes.brandKitWizard:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['brandId'] == null) {
          return MaterialPageRoute(builder: (_) => const NotFoundPage());
        }
        return MaterialPageRoute(
          builder: (_) => BrandKitWizardPage(
            brandId: args['brandId'] as String? ?? '',
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
