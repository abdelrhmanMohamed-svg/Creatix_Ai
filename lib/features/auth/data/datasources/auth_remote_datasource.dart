import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/user.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRemoteDatasource {
  Future<AppUser> register({required String email, required String password});

  Future<AppUser> login({required String email, required String password});

  Future<void> logout();

  Future<AppUser?> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final sb.SupabaseClient _client;

  AuthRemoteDatasourceImpl(this._client);

  @override
  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthFailure(message: 'Registration failed. Please try again.');
      }

      return AppUser(
        id: response.user!.id,
        email: response.user!.email ?? email,
        createdAt: response.user!.createdAt,
        updatedAt: response.user!.updatedAt,
        emailConfirmedAt: response.user!.emailConfirmedAt,
      );
    } on sb.AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthFailure(message: 'Invalid email or password.');
      }

      return AppUser(
        id: response.user!.id,
        email: response.user!.email ?? email,
        createdAt: response.user!.createdAt,
        updatedAt: response.user!.updatedAt,
        emailConfirmedAt: response.user!.emailConfirmedAt,
      );
    } on sb.AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: 'An unexpected error occurred');
    }
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
}
