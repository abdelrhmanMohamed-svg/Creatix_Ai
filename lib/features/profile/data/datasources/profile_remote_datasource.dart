import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/profile.dart';
import '../../../../core/constants/database_constants.dart';
import '../../../../core/error/failures.dart';

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
    try {
      final response = await _client
          .from(DatabaseConstants.profilesTable)
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
        id: response['id']?.toString() ?? '',
        userId: response['user_id']?.toString() ?? userId,
        fullName: response['full_name'] as String?,
        avatarUrl: response['avatar_url'] as String?,
        createdAt: response['created_at'] != null
            ? DateTime.tryParse(response['created_at'].toString())
            : null,
        updatedAt: response['updated_at'] != null
            ? DateTime.tryParse(response['updated_at'].toString())
            : null,
      );
    } catch (e) {
      throw AuthFailure(message: 'Failed to load profile');
    }
  }

  @override
  Future<Profile> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from(DatabaseConstants.profilesTable)
          .upsert({
            'user_id': userId,
            ...updates,
          }, onConflict: 'user_id')
          .select()
          .maybeSingle();

      return Profile(
        id: response?['id']?.toString() ?? '',
        userId: userId,
        fullName: fullName,
        avatarUrl: avatarUrl,
      );
    } catch (e) {
      throw AuthFailure(message: 'Failed to update profile');
    }
  }
}
