class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String example = '/example';
  static const String notFound = '/404';

  static const List<String> _routes = [
    home,
    login,
    register,
    profile,
    editProfile,
    example,
    notFound,
  ];

  static bool isValidRoute(String route) => _routes.contains(route);
}
