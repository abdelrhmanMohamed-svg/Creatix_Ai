import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/example_entity.dart';

abstract class ExampleState extends Equatable {
  final List<ExampleEntity> examples;
  final bool isLoading;
  final String? error;

  const ExampleState({
    this.examples = const [],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [examples, isLoading, error];
}

class ExampleInitial extends ExampleState {
  const ExampleInitial() : super();
}

class ExampleLoading extends ExampleState {
  const ExampleLoading() : super(isLoading: true);
}

class ExampleLoaded extends ExampleState {
  const ExampleLoaded(List<ExampleEntity> examples) : super(examples: examples);
}

class ExampleError extends ExampleState {
  const ExampleError(String error) : super(error: error);
}
