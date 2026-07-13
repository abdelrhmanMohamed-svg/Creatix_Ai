import 'package:equatable/equatable.dart';
import '../../domain/entities/provider_key.dart';

abstract class ProviderKeyState extends Equatable {
  const ProviderKeyState();

  @override
  List<Object?> get props => [];
}

class ProviderKeyInitial extends ProviderKeyState {
  const ProviderKeyInitial();
}

class ProviderKeyLoading extends ProviderKeyState {
  const ProviderKeyLoading();
}

class ProviderKeysLoaded extends ProviderKeyState {
  final List<ProviderKey> providerKeys;

  const ProviderKeysLoaded(this.providerKeys);

  @override
  List<Object?> get props => [providerKeys];
}

class ProviderKeyOperationSuccess extends ProviderKeyState {
  final String message;
  final ProviderKey? providerKey;

  const ProviderKeyOperationSuccess(this.message, [this.providerKey]);

  @override
  List<Object?> get props => [message, providerKey];
}

class ProviderKeyError extends ProviderKeyState {
  final String message;

  const ProviderKeyError(this.message);

  @override
  List<Object?> get props => [message];
}
