import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/user.dart';

abstract class AuthRemoteDatasource {
  Future<AppUser> register({required String email, required String password});

  Future<AppUser> login({required String email, required String password});

  Future<void> logout();

  Future<AppUser?> getCurrentUser();

  Stream<AppUser?> get authStateChanges;
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final sb.SupabaseClient _client;

  AuthRemoteDatasourceImpl(this._client);

  @override
  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Registration failed');
    }

    return AppUser(
      id: response.user!.id,
      email: response.user!.email ?? email,
      createdAt: response.user!.createdAt,
      updatedAt: response.user!.updatedAt,
      emailConfirmedAt: response.user!.emailConfirmedAt,
    );
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed');
    }

    return AppUser(
      id: response.user!.id,
      email: response.user!.email ?? email,
      createdAt: response.user!.createdAt,
      updatedAt: response.user!.updatedAt,
      emailConfirmedAt: response.user!.emailConfirmedAt,
    );
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final session = _client.auth.currentSession;
    if (session == null) return null;

    final user = session.user;
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      emailConfirmedAt: user.emailConfirmedAt,
    );
  }

  Stream<AppUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.asyncMap((data) async {
      if (data.event == sb.AuthChangeEvent.signedIn && data.session != null) {
        final user = data.session!.user;
        return AppUser(
          id: user.id,
          email: user.email ?? '',
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
          emailConfirmedAt: user.emailConfirmedAt,
        );
      }
      return null;
    });
  }
}
