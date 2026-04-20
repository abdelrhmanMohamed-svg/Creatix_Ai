import 'package:equatable/equatable.dart';

class BrandKitCreationDto extends Equatable {
  final String brandId;
  final String businessType;
  final String toneOfVoice;
  final List<String> colors;
  final String targetAudience;
  final String? brandSummary;

  const BrandKitCreationDto({
    required this.brandId,
    required this.businessType,
    required this.toneOfVoice,
    required this.colors,
    required this.targetAudience,
    this.brandSummary,
  });

  Map<String, dynamic> toJson() {
    return {
      'brand_id': brandId,
      'business_type': businessType,
      'tone_of_voice': toneOfVoice,
      'colors': colors,
      'target_audience': targetAudience,
      'brand_summary': brandSummary,
    };
  }

  @override
  List<Object?> get props => [
        brandId,
        businessType,
        toneOfVoice,
        colors,
        targetAudience,
        brandSummary,
      ];
}
