import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/provider_key.dart';

/**
 * Data source interface for provider key remote operations.
 * 
 * All operations are performed via Supabase Edge Functions to ensure
 * API keys are never exposed in client code.
 */
abstract class ProviderKeyRemoteDatasource {
  Future<List<ProviderKey>> getProviderKeys(String userId);
  Future<ProviderKey> addProviderKey({
    required String userId,
    required AiProvider provider,
    required String apiKey,
  });
  Future<void> deleteProviderKey(String id);
  Future<ProviderKey> activateProviderKey(String id);
}

class ProviderKeyRemoteDatasourceImpl implements ProviderKeyRemoteDatasource {
  final SupabaseClient _client;

  ProviderKeyRemoteDatasourceImpl(this._client);

  @override
  Future<List<ProviderKey>> getProviderKeys(String userId) async {
    final response = await _client.functions.invoke(
      'list-keys',
      body: {'userId': userId},
    );

    if (response.data == null) {
      return [];
    }

    final keysData = response.data as Map<String, dynamic>;
    final keys = keysData['keys'] as List<dynamic>? ?? [];
    return keys
        .map((json) => _mapToEntity(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProviderKey> addProviderKey({
    required String userId,
    required AiProvider provider,
    required String apiKey,
  }) async {
    final response = await _client.functions.invoke(
      'add-key',
      body: {
        'userId': userId,
        'provider': provider.name,
        'apiKey': apiKey,
      },
    );

    if (response.data == null) {
      throw Exception('Failed to add provider key');
    }

    final responseData = response.data as Map<String, dynamic>;

    if (responseData.containsKey('error')) {
      throw Exception(responseData['error'] as String);
    }

    return _mapFromResponse(responseData);
  }

  @override
  Future<void> deleteProviderKey(String id) async {
    await _client.functions.invoke('delete-key', body: {'id': id});
  }

  @override
  Future<ProviderKey> activateProviderKey(String id) async {
    final response = await _client.functions.invoke(
      'activate-key',
      body: {'id': id},
    );

    if (response.data == null) {
      throw Exception('Failed to activate provider key');
    }

    return _mapFromResponse(response.data as Map<String, dynamic>);
  }

  ProviderKey _mapFromResponse(Map<String, dynamic> json) {
    return ProviderKey(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      keyName: json['key_name'] as String?,
      provider: AiProvider.values.firstWhere(
        (p) => p.name == json['provider'],
        orElse: () => AiProvider.openai,
      ),
      isActive: json['is_active'] as bool? ?? false,
      isValid: json['is_valid'] as bool? ?? true,
      lastValidatedAt: json['last_validated_at'] != null
          ? DateTime.parse(json['last_validated_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  ProviderKey _mapToEntity(Map<String, dynamic> json) {
    return ProviderKey(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      keyName: json['key_name'] as String?,
      provider: AiProvider.values.firstWhere(
        (p) => p.name == json['provider'],
        orElse: () => AiProvider.openai,
      ),
      isActive: json['is_active'] as bool? ?? false,
      isValid: json['is_valid'] as bool? ?? true,
      lastValidatedAt: json['last_validated_at'] != null
          ? DateTime.parse(json['last_validated_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
