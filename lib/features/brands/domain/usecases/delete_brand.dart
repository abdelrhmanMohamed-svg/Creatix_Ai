import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/brand_repository.dart';

class DeleteBrand {
  final BrandRepository repository;

  DeleteBrand(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteBrand(id);
  }
}
