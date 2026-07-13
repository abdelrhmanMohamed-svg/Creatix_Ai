import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/provider_key.dart';

abstract class ProviderResolutionService {
  Future<String?> getActiveSecret(AiProvider provider);
  Future<ProviderKey?> getActiveProviderKey(AiProvider provider);
  Future<List<ProviderKey>> getAllActiveKeys();
}

class ProviderResolutionServiceImpl implements ProviderResolutionService {
  final SupabaseClient _client;

  ProviderResolutionServiceImpl(this._client);

  @override
  Future<String?> getActiveSecret(AiProvider provider) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client.functions.invoke(
      'get-active-key',
      body: {
        'userId': userId,
        'provider': provider.name,
      },
    );

    if (response.data == null) return null;

    final data = response.data as Map<String, dynamic>;
    return data['secret'] as String?;
  }

  @override
  Future<ProviderKey?> getActiveProviderKey(AiProvider provider) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client.functions.invoke(
      'list-keys',
      body: {'userId': userId},
    );

    if (response.data == null) return null;

    final keysData = response.data as Map<String, dynamic>;
    final keys = keysData['keys'] as List<dynamic>? ?? [];

    for (final key in keys) {
      final providerKey = _mapToEntity(key as Map<String, dynamic>);
      if (providerKey.provider == provider &&
          providerKey.isActive &&
          providerKey.isValid) {
        return providerKey;
      }
    }

    return null;
  }

  @override
  Future<List<ProviderKey>> getAllActiveKeys() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client.functions.invoke(
      'list-keys',
      body: {'userId': userId},
    );

    if (response.data == null) return [];

    final keysData = response.data as Map<String, dynamic>;
    final keys = keysData['keys'] as List<dynamic>? ?? [];

    return keys
        .map((json) => _mapToEntity(json as Map<String, dynamic>))
        .where((key) => key.isActive && key.isValid)
        .toList();
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
