import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository _repository;

  UpdateProfile(this._repository);

  Future<Either<Failure, Profile>> call({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) {
    return _repository.updateProfile(
      userId: userId,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
  }
}
