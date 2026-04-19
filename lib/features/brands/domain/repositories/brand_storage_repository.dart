import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class BrandStorageRepository {
  Future<Either<Failure, String>> uploadLogo({
    required String filePath,
    required String userId,
    String? brandId,
  });
  Future<Either<Failure, void>> deleteLogo(String logoUrl);
}
