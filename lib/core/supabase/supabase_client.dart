import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseClientWrapper {
  static final SupabaseClientWrapper _instance =
      SupabaseClientWrapper._internal();
  factory SupabaseClientWrapper() => _instance;

  SupabaseClientWrapper._internal();

  sb.SupabaseClient? _client;

  Future<void> initialize() async {
    if (_client != null) return;

    await dotenv.load();
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (url.isEmpty || anonKey.isEmpty) {
      throw Exception(
          'Supabase URL or ANON_KEY is missing. Check your .env file.');
    }

    await sb.Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );

    _client = sb.Supabase.instance.client;
  }

  sb.SupabaseClient get client {
    if (_client == null) {
      throw Exception(
          'SupabaseClient not initialized. Call SupabaseClientWrapper.initialize() first.');
    }
    return _client!;
  }

  bool get isInitialized => _client != null;
}
