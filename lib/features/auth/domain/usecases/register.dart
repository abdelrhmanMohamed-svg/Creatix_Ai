import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository _repository;

  Register(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) {
    return _repository.register(email: email, password: password);
  }
}
