import 'package:equatable/equatable.dart';

class BrandKit extends Equatable {
  final String id;
  final String brandId;
  final String businessType;
  final String toneOfVoice;
  final List<String> colors;
  final String targetAudience;
  final String? brandSummary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BrandKit({
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

  BrandKit copyWith({
    String? id,
    String? brandId,
    String? businessType,
    String? toneOfVoice,
    List<String>? colors,
    String? targetAudience,
    String? brandSummary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BrandKit(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      businessType: businessType ?? this.businessType,
      toneOfVoice: toneOfVoice ?? this.toneOfVoice,
      colors: colors ?? this.colors,
      targetAudience: targetAudience ?? this.targetAudience,
      brandSummary: brandSummary ?? this.brandSummary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
