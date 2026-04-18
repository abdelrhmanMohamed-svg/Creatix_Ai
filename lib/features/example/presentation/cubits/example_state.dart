import 'package:equatable/equatable.dart';
import '../../domain/entities/example_entity.dart';

class ExampleState extends Equatable {
  final List<ExampleEntity> examples;
  final bool isLoading;
  final String? error;

  const ExampleState({
    this.examples = const [],
    this.isLoading = false,
    this.error,
  });

  ExampleState copyWith({
    List<ExampleEntity>? examples,
    bool? isLoading,
    String? error,
  }) {
    return ExampleState(
      examples: examples ?? this.examples,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [examples, isLoading, error];
}
