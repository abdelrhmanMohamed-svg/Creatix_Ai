import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/brand_kit.dart';

abstract class BrandKitRepository {
  Future<Either<Failure, BrandKit>> createBrandKit({
    required String brandId,
    required String businessType,
    required String toneOfVoice,
    required List<String> colors,
    required String targetAudience,
    String? brandSummary,
  });

  Future<Either<Failure, BrandKit?>> getBrandKitByBrandId(String brandId);

  Future<Either<Failure, BrandKit>> updateBrandKit({
    required String brandId,
    String? businessType,
    String? toneOfVoice,
    List<String>? colors,
    String? targetAudience,
    String? brandSummary,
  });

  Future<Either<Failure, void>> deleteBrandKit(String brandId);
}
