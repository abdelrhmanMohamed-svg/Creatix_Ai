import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/brand_entity.dart';

abstract class BrandRepository {
  Future<Either<Failure, List<BrandEntity>>> getBrands(String userId);
  Future<Either<Failure, BrandEntity>> getBrandById(String id);
  Future<Either<Failure, BrandEntity>> createBrand({
    required String userId,
    required String name,
    String? logoUrl,
  });
  Future<Either<Failure, BrandEntity>> updateBrand({
    required String id,
    required String name,
    String? logoUrl,
  });
  Future<Either<Failure, void>> deleteBrand(String id);
}
