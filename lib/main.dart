import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/supabase/supabase_client.dart';
import 'core/di/injection.dart';
import 'core/router.dart';
import 'core/constants/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await SupabaseClientWrapper.initialize();

  await setupDependencies();

  runApp(const CreatixApp());
}

class CreatixApp extends StatelessWidget {
  const CreatixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creatix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}