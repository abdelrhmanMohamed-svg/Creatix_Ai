import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/brand_kit_model.dart';
import '../models/brand_kit_creation_dto.dart';

abstract class BrandKitRemoteDataSource {
  Future<BrandKitModel> createBrandKit(BrandKitCreationDto dto);
  Future<BrandKitModel?> getBrandKitByBrandId(String brandId);
  Future<BrandKitModel> updateBrandKit(
      String brandId, Map<String, dynamic> data);
  Future<void> deleteBrandKit(String brandId);
}

class BrandKitRemoteDataSourceImpl implements BrandKitRemoteDataSource {
  final SupabaseClient _client;

  BrandKitRemoteDataSourceImpl(this._client);

  @override
  Future<BrandKitModel> createBrandKit(BrandKitCreationDto dto) async {
    final response = await _client
        .from('brand_kits')
        .insert(dto.toJson())
        .select()
        .single();
    return BrandKitModel.fromJson(response);
  }

  @override
  Future<BrandKitModel?> getBrandKitByBrandId(String brandId) async {
    final response = await _client
        .from('brand_kits')
        .select()
        .eq('brand_id', brandId)
        .maybeSingle();
    if (response == null) return null;
    return BrandKitModel.fromJson(response);
  }

  @override
  Future<BrandKitModel> updateBrandKit(
      String brandId, Map<String, dynamic> data) async {
    final response = await _client
        .from('brand_kits')
        .update(data)
        .eq('brand_id', brandId)
        .select()
        .single();
    return BrandKitModel.fromJson(response);
  }

  @override
  Future<void> deleteBrandKit(String brandId) async {
    await _client.from('brand_kits').delete().eq('brand_id', brandId);
  }
}
