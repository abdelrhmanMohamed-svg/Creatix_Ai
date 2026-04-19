import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_remote_data_source.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource datasource;

  BrandRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands(String userId) async {
    try {
      final models = await datasource.getBrands(userId);
      return Right(models);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, BrandEntity>> getBrandById(String id) async {
    try {
      final model = await datasource.getBrandById(id);
      return Right(model);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, BrandEntity>> createBrand({
    required String userId,
    required String name,
    String? logoUrl,
  }) async {
    try {
      final model = await datasource.createBrand(
        userId: userId,
        name: name,
        logoUrl: logoUrl,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, BrandEntity>> updateBrand({
    required String id,
    required String name,
    String? logoUrl,
  }) async {
    try {
      final model = await datasource.updateBrand(
        id: id,
        name: name,
        logoUrl: logoUrl,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBrand(String id) async {
    try {
      await datasource.deleteBrand(id);
      return const Right(null);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }
}
