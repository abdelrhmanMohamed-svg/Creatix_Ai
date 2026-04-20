class AppRoutes {
  static const String brands = '/brands';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String example = '/example';
  static const String notFound = '/404';
  static const String createBrand = '/create-brand';
  static const String updateBrand = '/update-brand';
  static const String brandKitWizard = '/brand-kit-wizard';

  static const List<String> _routes = [
    brands,
    login,
    register,
    profile,
    editProfile,
    example,
    notFound,
    createBrand,
    updateBrand,
    brandKitWizard,
  ];

  static bool isValidRoute(String route) => _routes.contains(route);
}
