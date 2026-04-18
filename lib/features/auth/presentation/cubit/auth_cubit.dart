import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/get_current_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Register _register;
  final Login _login;
  final Logout _logout;
  final GetCurrentUser _getCurrentUser;

  AuthCubit({
    required Register register,
    required Login login,
    required Logout logout,
    required GetCurrentUser getCurrentUser,
  })  : _register = register,
        _login = login,
        _logout = logout,
        _getCurrentUser = getCurrentUser,
        super(const AuthInitial());

  Future<void> checkAuth() async {
    emit(const AuthLoading());
    final result = await _getCurrentUser.call();
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _register.call(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _login.call(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await _logout.call();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
