import 'package:equatable/equatable.dart';

/**
 * Represents an AI provider API key owned by a user.
 * 
 * This entity follows Clean Architecture principles and is part of the domain layer.
 * API keys are stored securely and their secrets are never exposed to the client.
 * 
 * Security Notes:
 * - The actual API key secret is stored server-side only
 * - Client applications only work with the key's metadata (id, status, etc.)
 * - Never log or expose key secrets in client code
 * 
 * Example:
 * ```dart
 * final key = ProviderKey.create(
 *   provider: AiProvider.openai,
 *   isActive: true,
 * );
 * ```
 */

enum AiProvider { openai, gemini }

class ProviderKey extends Equatable {
  final String? id;
  final String? userId;
  final String? keyName;
  final AiProvider provider;
  final bool isActive;
  final bool isValid;
  final DateTime? lastValidatedAt;
  final DateTime? createdAt;

  const ProviderKey({
    this.id,
    this.userId,
    this.keyName,
    required this.provider,
    this.isActive = false,
    this.isValid = true,
    this.lastValidatedAt,
    this.createdAt,
  });

  factory ProviderKey.create({
    required AiProvider provider,
    bool isActive = false,
    bool isValid = true,
  }) {
    return ProviderKey(
      provider: provider,
      isActive: isActive,
      isValid: isValid,
      createdAt: DateTime.now(),
    );
  }

  ProviderKey copyWith({
    String? id,
    String? userId,
    String? keyName,
    AiProvider? provider,
    bool? isActive,
    bool? isValid,
    DateTime? lastValidatedAt,
    DateTime? createdAt,
  }) {
    return ProviderKey(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      keyName: keyName ?? this.keyName,
      provider: provider ?? this.provider,
      isActive: isActive ?? this.isActive,
      isValid: isValid ?? this.isValid,
      lastValidatedAt: lastValidatedAt ?? this.lastValidatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get providerDisplayName {
    switch (provider) {
      case AiProvider.openai:
        return 'OpenAI';
      case AiProvider.gemini:
        return 'Google Gemini';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        keyName,
        provider,
        isActive,
        isValid,
        lastValidatedAt,
        createdAt,
      ];
}
