import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

class GetBrands {
  final BrandRepository repository;

  GetBrands(this.repository);

  Future<Either<Failure, List<BrandEntity>>> call(String userId) {
    return repository.getBrands(userId);
  }
}
