import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

class UpdateBrand {
  final BrandRepository repository;

  UpdateBrand(this.repository);

  Future<Either<Failure, BrandEntity>> call({
    required String id,
    required String name,
    String? logoUrl,
  }) {
    return repository.updateBrand(
      id: id,
      name: name,
      logoUrl: logoUrl,
    );
  }
}
