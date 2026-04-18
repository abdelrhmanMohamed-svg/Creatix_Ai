import '../../domain/entities/example_entity.dart';

class ExampleModel extends ExampleEntity {
  const ExampleModel({
    required super.id,
    required super.name,
    required super.createdAt,
  });

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'created_at': createdAt.toIso8601String()};
  }
}
