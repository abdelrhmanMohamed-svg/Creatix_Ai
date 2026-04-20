import 'package:equatable/equatable.dart';

class BrandKitResponseDto extends Equatable {
  final String id;
  final String brandId;
  final String businessType;
  final String toneOfVoice;
  final List<String> colors;
  final String targetAudience;
  final String? brandSummary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BrandKitResponseDto({
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

  factory BrandKitResponseDto.fromJson(Map<String, dynamic> json) {
    return BrandKitResponseDto(
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
