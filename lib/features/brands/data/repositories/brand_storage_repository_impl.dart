import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/brand_storage_repository.dart';

class BrandStorageRepositoryImpl implements BrandStorageRepository {
  final SupabaseClient client;

  static const String _bucketName = 'brand_logos';

  BrandStorageRepositoryImpl(this.client);

  @override
  Future<Either<Failure, String>> uploadLogo({
    required String filePath,
    required String userId,
    String? brandId,
  }) async {
    try {
      final file = File(filePath);
      final fileName = brandId != null
          ? '${userId}_${brandId}_${DateTime.now().millisecondsSinceEpoch}.jpg'
          : '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await client.storage.from(_bucketName).uploadBinary(
            fileName,
            await file.readAsBytes(),
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              cacheControl: '3600',
            ),
          );

      final logoUrl = client.storage.from(_bucketName).getPublicUrl(fileName);
      return Right(logoUrl);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLogo(String logoUrl) async {
    try {
      final uri = Uri.parse(logoUrl);
      final fileName = uri.pathSegments.last;
      await client.storage.from(_bucketName).remove([fileName]);
      return const Right(null);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }
}
