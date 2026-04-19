import 'package:equatable/equatable.dart';

class BrandEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? logoUrl;
  final DateTime createdAt;

  const BrandEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.logoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, name, logoUrl, createdAt];
}
