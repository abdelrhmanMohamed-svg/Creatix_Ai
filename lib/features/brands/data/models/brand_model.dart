import '../../domain/entities/brand_entity.dart';

class BrandModel extends BrandEntity {
  const BrandModel({
    required String id,
    required String userId,
    required String name,
    String? logoUrl,
    required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          name: name,
          logoUrl: logoUrl,
          createdAt: createdAt,
        );

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'logo_url': logoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
