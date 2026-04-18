import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/supabase/supabase_client.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await SupabaseClientWrapper.initialize();

  await setupDependencies();

  runApp(const CreatixApp());
}

class CreatixApp extends StatelessWidget {
  const CreatixApp();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>()..checkAuth(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isAuthenticated = state is AuthAuthenticated;
          final isLoading = state is AuthLoading;

          return MaterialApp(
            title: 'Creatix',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute:
                isLoading ? null : (isAuthenticated ? '/home' : '/login'),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/login':
                  return MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  );
                case '/register':
                  return MaterialPageRoute(
                    builder: (_) => const RegisterPage(),
                  );
                case '/home':
                  return MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  );
              }
            },
            home: isLoading
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  )
                : isAuthenticated
                    ? const HomePage()
                    : const LoginPage(),
          );
        },
      ),
    );
  }
}
