import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

const _networkErrorMessage = 'Network error. Please check your connection.';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource _remoteDatasource;

  ProfileRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, Profile>> getProfile(String userId) async {
    try {
      final profile = await _remoteDatasource.getProfile(userId);
      return Right(profile);
    } catch (e) {
      return Left(CacheFailure(message: _networkErrorMessage));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final profile = await _remoteDatasource.updateProfile(
        userId: userId,
        fullName: fullName,
        avatarUrl: avatarUrl,
      );
      return Right(profile);
    } catch (e) {
      return Left(CacheFailure(message: _networkErrorMessage));
    }
  }
}
