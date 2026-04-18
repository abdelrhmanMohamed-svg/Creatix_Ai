import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String userId);
  Future<Either<Failure, Profile>> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  });
}
