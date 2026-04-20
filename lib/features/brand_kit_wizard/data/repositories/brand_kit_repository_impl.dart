import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/brand_kit.dart';
import '../../domain/repositories/brand_kit_repository.dart';
import '../datasources/brand_kit_remote_data_source.dart';
import '../models/brand_kit_creation_dto.dart';

class BrandKitRepositoryImpl implements BrandKitRepository {
  final BrandKitRemoteDataSource _remoteDataSource;

  BrandKitRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, BrandKit>> createBrandKit({
    required String brandId,
    required String businessType,
    required String toneOfVoice,
    required List<String> colors,
    required String targetAudience,
    String? brandSummary,
  }) async {
    try {
      final dto = BrandKitCreationDto(
        brandId: brandId,
        businessType: businessType,
        toneOfVoice: toneOfVoice,
        colors: colors,
        targetAudience: targetAudience,
        brandSummary: brandSummary,
      );

      final result = await _remoteDataSource.createBrandKit(dto);

      return Right(BrandKit(
        id: result.id,
        brandId: result.brandId,
        businessType: result.businessType,
        toneOfVoice: result.toneOfVoice,
        colors: result.colors,
        targetAudience: result.targetAudience,
        brandSummary: result.brandSummary,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BrandKit?>> getBrandKitByBrandId(
      String brandId) async {
    try {
      final result = await _remoteDataSource.getBrandKitByBrandId(brandId);

      if (result == null) {
        return const Right(null);
      }

      return Right(BrandKit(
        id: result.id,
        brandId: result.brandId,
        businessType: result.businessType,
        toneOfVoice: result.toneOfVoice,
        colors: result.colors,
        targetAudience: result.targetAudience,
        brandSummary: result.brandSummary,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BrandKit>> updateBrandKit({
    required String brandId,
    String? businessType,
    String? toneOfVoice,
    List<String>? colors,
    String? targetAudience,
    String? brandSummary,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (businessType != null) data['business_type'] = businessType;
      if (toneOfVoice != null) data['tone_of_voice'] = toneOfVoice;
      if (colors != null) data['colors'] = colors;
      if (targetAudience != null) data['target_audience'] = targetAudience;
      if (brandSummary != null) data['brand_summary'] = brandSummary;

      final result = await _remoteDataSource.updateBrandKit(brandId, data);

      return Right(BrandKit(
        id: result.id,
        brandId: result.brandId,
        businessType: result.businessType,
        toneOfVoice: result.toneOfVoice,
        colors: result.colors,
        targetAudience: result.targetAudience,
        brandSummary: result.brandSummary,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBrandKit(String brandId) async {
    try {
      await _remoteDataSource.deleteBrandKit(brandId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
