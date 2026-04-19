import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/brand_model.dart';

abstract class BrandRemoteDataSource {
  Future<List<BrandModel>> getBrands(String userId);
  Future<BrandModel> getBrandById(String id);
  Future<BrandModel> createBrand({
    required String userId,
    required String name,
    String? logoUrl,
  });
  Future<BrandModel> updateBrand({
    required String id,
    required String name,
    String? logoUrl,
  });
  Future<void> deleteBrand(String id);
}

class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final SupabaseClient client;

  BrandRemoteDataSourceImpl(this.client);

  @override
  Future<List<BrandModel>> getBrands(String userId) async {
    final response = await client
        .from('brands')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return response.map((json) => BrandModel.fromJson(json)).toList();
  }

  @override
  Future<BrandModel> getBrandById(String id) async {
    final response = await client.from('brands').select().eq('id', id).single();
    return BrandModel.fromJson(response);
  }

  @override
  Future<BrandModel> createBrand({
    required String userId,
    required String name,
    String? logoUrl,
  }) async {
    final response = await client
        .from('brands')
        .insert({
          'user_id': userId,
          'name': name,
          'logo_url': logoUrl,
        })
        .select()
        .single();
    return BrandModel.fromJson(response);
  }

  @override
  Future<BrandModel> updateBrand({
    required String id,
    required String name,
    String? logoUrl,
  }) async {
    final response = await client
        .from('brands')
        .update({
          'name': name,
          'logo_url': logoUrl,
        })
        .eq('id', id)
        .select()
        .single();
    return BrandModel.fromJson(response);
  }

  @override
  Future<void> deleteBrand(String id) async {
    await client.from('brands').delete().eq('id', id);
  }
}
