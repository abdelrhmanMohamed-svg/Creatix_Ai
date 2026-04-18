import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/profile.dart';

abstract class ProfileRemoteDatasource {
  Future<Profile> getProfile(String userId);
  Future<Profile> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  });
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final sb.SupabaseClient _client;

  ProfileRemoteDatasourceImpl(this._client);

  @override
  Future<Profile> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return Profile(
        id: '',
        userId: userId,
        fullName: null,
        avatarUrl: null,
      );
    }

    return Profile(
      id: response['id'] ?? '',
      userId: response['user_id'] ?? userId,
      fullName: response['full_name'],
      avatarUrl: response['avatar_url'],
      createdAt: response['created_at'] != null
          ? DateTime.tryParse(response['created_at'])
          : null,
      updatedAt: response['updated_at'] != null
          ? DateTime.tryParse(response['updated_at'])
          : null,
    );
  }

  @override
  Future<Profile> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    updates['updated_at'] = DateTime.now().toIso8601String();

    final response = await _client
        .from('profiles')
        .upsert({
          'user_id': userId,
          ...updates,
        }, onConflict: 'user_id')
        .select()
        .maybeSingle();

    return Profile(
      id: response?['id'] ?? '',
      userId: userId,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
  }
}
