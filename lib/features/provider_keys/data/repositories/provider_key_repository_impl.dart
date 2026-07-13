import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/provider_key.dart';
import '../../domain/repositories/provider_key_repository.dart';
import '../datasources/provider_key_remote_data_source.dart';

class ProviderKeyRepositoryImpl implements ProviderKeyRepository {
  final ProviderKeyRemoteDatasource _datasource;

  ProviderKeyRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<ProviderKey>>> getProviderKeys(
      String userId) async {
    try {
      final keys = await _datasource.getProviderKeys(userId);
      return Right(keys);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, ProviderKey>> addProviderKey({
    required String userId,
    required AiProvider provider,
    required String apiKey,
  }) async {
    try {
      final key = await _datasource.addProviderKey(
        userId: userId,
        provider: provider,
        apiKey: apiKey,
      );
      return Right(key);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProviderKey(String id) async {
    try {
      await _datasource.deleteProviderKey(id);
      return const Right(null);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, ProviderKey>> activateProviderKey(String id) async {
    try {
      final key = await _datasource.activateProviderKey(id);
      return Right(key);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }
}
