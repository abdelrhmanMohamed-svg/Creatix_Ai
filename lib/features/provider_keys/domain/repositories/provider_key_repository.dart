import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/provider_key.dart';

/**
 * Repository interface for provider key operations.
 * 
 * This interface defines the contract for managing AI provider API keys.
 * Implementations must ensure keys are never exposed in client code.
 */
abstract class ProviderKeyRepository {
  Future<Either<Failure, List<ProviderKey>>> getProviderKeys(String userId);
  Future<Either<Failure, ProviderKey>> addProviderKey({
    required String userId,
    required AiProvider provider,
    required String apiKey,
  });
  Future<Either<Failure, void>> deleteProviderKey(String id);
  Future<Either<Failure, ProviderKey>> activateProviderKey(String id);
}
