import 'package:equatable/equatable.dart';

enum BrandKitWizardStatus {
  initial,
  loading,
  loaded,
  generatingSummary,
  saving,
  success,
  error,
}

class BrandKitWizardState extends Equatable {
  final int currentStep;
  final String? businessType;
  final String? toneOfVoice;
  final List<String> colors;
  final String? targetAudience;
  final String? brandSummary;
  final BrandKitWizardStatus status;
  final String? errorMessage;
  final String? existingBrandKitId;

  const BrandKitWizardState({
    this.currentStep = 0,
    this.businessType,
    this.toneOfVoice,
    this.colors = const [],
    this.targetAudience,
    this.brandSummary,
    this.status = BrandKitWizardStatus.initial,
    this.errorMessage,
    this.existingBrandKitId,
  });

  bool get canProceedFromCurrentStep {
    switch (currentStep) {
      case 0:
        return businessType != null && businessType!.isNotEmpty;
      case 1:
        return toneOfVoice != null && toneOfVoice!.isNotEmpty;
      case 2:
        return colors.isNotEmpty;
      case 3:
        return targetAudience != null && targetAudience!.isNotEmpty;
      case 4:
        return true;
      default:
        return false;
    }
  }

  BrandKitWizardState copyWith({
    int? currentStep,
    String? businessType,
    String? toneOfVoice,
    List<String>? colors,
    String? targetAudience,
    String? brandSummary,
    BrandKitWizardStatus? status,
    String? errorMessage,
    String? existingBrandKitId,
  }) {
    return BrandKitWizardState(
      currentStep: currentStep ?? this.currentStep,
      businessType: businessType ?? this.businessType,
      toneOfVoice: toneOfVoice ?? this.toneOfVoice,
      colors: colors ?? this.colors,
      targetAudience: targetAudience ?? this.targetAudience,
      brandSummary: brandSummary ?? this.brandSummary,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      existingBrandKitId: existingBrandKitId ?? this.existingBrandKitId,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        businessType,
        toneOfVoice,
        colors,
        targetAudience,
        brandSummary,
        status,
        errorMessage,
        existingBrandKitId,
      ];
}
