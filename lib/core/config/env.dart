import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;
  EnvConfig._internal();

  late String supabaseUrl;
  late String supabaseAnonKey;

  bool get isInitialized =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  void loadSync() {
    dotenv.load();
    supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }
}
