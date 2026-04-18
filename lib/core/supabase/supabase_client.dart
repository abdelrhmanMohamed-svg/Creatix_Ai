import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseClientWrapper {
  static SupabaseClientWrapper? _instance;
  static SupabaseClient? _client;

  SupabaseClientWrapper._();

  static Future<void> initialize() async {
    await dotenv.load();
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );

    _client = Supabase.instance.client;
    _instance = SupabaseClientWrapper._();
  }

  static SupabaseClient get instance {
    if (_client == null) {
      throw Exception(
          'SupabaseClient not initialized. Call SupabaseClientWrapper.initialize() first.');
    }
    return _client!;
  }

  static bool get isInitialized => _client != null;
}
