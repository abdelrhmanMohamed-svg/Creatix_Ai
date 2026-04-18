import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/example_entity.dart';

abstract class ExampleEvent extends Equatable {
  const ExampleEvent();

  @override
  List<Object?> get props => [];
}

class LoadExamples extends ExampleEvent {}

class CreateExample extends ExampleEvent {
  final String name;

  const CreateExample(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteExample extends ExampleEvent {
  final String id;

  const DeleteExample(this.id);

  @override
  List<Object?> get props => [id];
}
