import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

class CreateBrand {
  final BrandRepository repository;

  CreateBrand(this.repository);

  Future<Either<Failure, BrandEntity>> call({
    required String userId,
    required String name,
    String? logoUrl,
  }) {
    return repository.createBrand(
      userId: userId,
      name: name,
      logoUrl: logoUrl,
    );
  }
}
