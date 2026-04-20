import 'package:equatable/equatable.dart';

class BrandKitModel extends Equatable {
  final String id;
  final String brandId;
  final String businessType;
  final String toneOfVoice;
  final List<String> colors;
  final String targetAudience;
  final String? brandSummary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BrandKitModel({
    required this.id,
    required this.brandId,
    required this.businessType,
    required this.toneOfVoice,
    required this.colors,
    required this.targetAudience,
    this.brandSummary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BrandKitModel.fromJson(Map<String, dynamic> json) {
    return BrandKitModel(
      id: json['id'] as String,
      brandId: json['brand_id'] as String,
      businessType: json['business_type'] as String,
      toneOfVoice: json['tone_of_voice'] as String,
      colors: List<String>.from(json['colors'] ?? []),
      targetAudience: json['target_audience'] as String,
      brandSummary: json['brand_summary'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_id': brandId,
      'business_type': businessType,
      'tone_of_voice': toneOfVoice,
      'colors': colors,
      'target_audience': targetAudience,
      'brand_summary': brandSummary,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        brandId,
        businessType,
        toneOfVoice,
        colors,
        targetAudience,
        brandSummary,
        createdAt,
        updatedAt,
      ];
}
