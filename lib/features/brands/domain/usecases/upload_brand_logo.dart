import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/brand_storage_repository.dart';

class UploadBrandLogo {
  final BrandStorageRepository repository;

  UploadBrandLogo(this.repository);

  Future<Either<Failure, String>> call({
    required String filePath,
    required String userId,
    String? brandId,
  }) {
    return repository.uploadLogo(
      filePath: filePath,
      userId: userId,
      brandId: brandId,
    );
  }
}
