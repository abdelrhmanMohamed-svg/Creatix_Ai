import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/provider_key.dart';
import '../../domain/repositories/provider_key_repository.dart';
import 'provider_key_state.dart';

class ProviderKeyCubit extends Cubit<ProviderKeyState> {
  final ProviderKeyRepository _repository;
  final SupabaseClient _supabaseClient;

  ProviderKeyCubit({
    required ProviderKeyRepository repository,
    required SupabaseClient supabaseClient,
  })  : _repository = repository,
        _supabaseClient = supabaseClient,
        super(const ProviderKeyInitial());

  Future<void> loadProviderKeys() async {
    emit(const ProviderKeyLoading());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        AppLogger.error(
            'ProviderKeyCubit: User not authenticated during loadProviderKeys');
        emit(const ProviderKeyError('User not authenticated'));
        return;
      }
      AppLogger.info(
          'ProviderKeyCubit: Loading provider keys for user: $userId');
      final result = await _repository.getProviderKeys(userId);
      result.fold(
        (failure) {
          AppLogger.error(
              'ProviderKeyCubit: Failed to load provider keys - ${failure.message}');
          emit(ProviderKeyError(failure.message));
        },
        (keys) {
          AppLogger.info(
              'ProviderKeyCubit: Loaded ${keys.length} provider keys');
          emit(ProviderKeysLoaded(keys));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
          'ProviderKeyCubit: Unexpected error loading provider keys',
          e,
          stackTrace);
      emit(ProviderKeyError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> addProviderKey({
    required AiProvider provider,
    required String apiKey,
  }) async {
    emit(const ProviderKeyLoading());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        AppLogger.error(
            'ProviderKeyCubit: User not authenticated during addProviderKey');
        emit(const ProviderKeyError('User not authenticated'));
        return;
      }
      AppLogger.info('ProviderKeyCubit: Adding ${provider.name} provider key');
      final result = await _repository.addProviderKey(
        userId: userId,
        provider: provider,
        apiKey: apiKey,
      );
      result.fold(
        (failure) {
          AppLogger.error(
              'ProviderKeyCubit: Failed to add provider key - ${failure.message}');
          emit(ProviderKeyError(failure.message));
        },
        (key) {
          AppLogger.info(
              'ProviderKeyCubit: Provider key added successfully - ${key.id}');
          emit(ProviderKeyOperationSuccess('API key added successfully', key));
          loadProviderKeys();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('ProviderKeyCubit: Unexpected error adding provider key',
          e, stackTrace);
      emit(ProviderKeyError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> deleteProviderKey(String id) async {
    emit(const ProviderKeyLoading());
    try {
      AppLogger.info('ProviderKeyCubit: Deleting provider key: $id');
      final result = await _repository.deleteProviderKey(id);
      result.fold(
        (failure) {
          AppLogger.error(
              'ProviderKeyCubit: Failed to delete provider key - ${failure.message}');
          emit(ProviderKeyError(failure.message));
        },
        (_) {
          AppLogger.info('ProviderKeyCubit: Provider key deleted successfully');
          emit(const ProviderKeyOperationSuccess(
              'API key deleted successfully'));
          loadProviderKeys();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
          'ProviderKeyCubit: Unexpected error deleting provider key',
          e,
          stackTrace);
      emit(ProviderKeyError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> activateProviderKey(String id) async {
    emit(const ProviderKeyLoading());
    try {
      AppLogger.info('ProviderKeyCubit: Activating provider key: $id');
      final result = await _repository.activateProviderKey(id);
      result.fold(
        (failure) {
          AppLogger.error(
              'ProviderKeyCubit: Failed to activate provider key - ${failure.message}');
          emit(ProviderKeyError(failure.message));
        },
        (key) {
          AppLogger.info(
              'ProviderKeyCubit: Provider key activated successfully - ${key.id}');
          emit(ProviderKeyOperationSuccess(
              'API key activated successfully', key));
          loadProviderKeys();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
          'ProviderKeyCubit: Unexpected error activating provider key',
          e,
          stackTrace);
      emit(ProviderKeyError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
