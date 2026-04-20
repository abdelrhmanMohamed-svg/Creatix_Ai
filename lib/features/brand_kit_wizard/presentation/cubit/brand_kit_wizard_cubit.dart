import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/brand_kit_repository.dart';
import 'brand_kit_wizard_state.dart';

class BrandKitWizardCubit extends Cubit<BrandKitWizardState> {
  final BrandKitRepository _repository;
  final String brandId;

  BrandKitWizardCubit({
    required BrandKitRepository repository,
    required this.brandId,
  })  : _repository = repository,
        super(const BrandKitWizardState());

  void selectBusinessType(String type) {
    emit(state.copyWith(businessType: type));
  }

  void selectToneOfVoice(String tone) {
    emit(state.copyWith(toneOfVoice: tone));
  }

  void addColor(String color) {
    if (!state.colors.contains(color)) {
      final newColors = [...state.colors, color];
      emit(state.copyWith(colors: newColors));
    }
  }

  void removeColor(String color) {
    final newColors = state.colors.where((c) => c != color).toList();
    emit(state.copyWith(colors: newColors));
  }

  void setColors(List<String> colors) {
    emit(state.copyWith(colors: colors));
  }

  void setTargetAudience(String audience) {
    emit(state.copyWith(targetAudience: audience));
  }

  void setBrandSummary(String summary) {
    emit(state.copyWith(brandSummary: summary));
  }

  void nextStep() {
    if (state.currentStep < 4) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 4) {
      emit(state.copyWith(currentStep: step));
    }
  }

  Future<void> saveBrandKit() async {
    if (state.businessType == null ||
        state.toneOfVoice == null ||
        state.colors.isEmpty ||
        state.targetAudience == null) {
      emit(state.copyWith(
        status: BrandKitWizardStatus.error,
        errorMessage: 'Please complete all steps before saving',
      ));
      return;
    }

    emit(state.copyWith(status: BrandKitWizardStatus.saving));

    final isEditing = state.existingBrandKitId != null;

    if (isEditing) {
      final result = await _repository.updateBrandKit(
        brandId: brandId,
        businessType: state.businessType!,
        toneOfVoice: state.toneOfVoice!,
        colors: state.colors,
        targetAudience: state.targetAudience!,
        brandSummary: state.brandSummary,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: BrandKitWizardStatus.error,
          errorMessage: failure.message,
        )),
        (_) => emit(state.copyWith(status: BrandKitWizardStatus.success)),
      );
    } else {
      final result = await _repository.createBrandKit(
        brandId: brandId,
        businessType: state.businessType!,
        toneOfVoice: state.toneOfVoice!,
        colors: state.colors,
        targetAudience: state.targetAudience!,
        brandSummary: state.brandSummary,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: BrandKitWizardStatus.error,
          errorMessage: failure.message,
        )),
        (_) => emit(state.copyWith(status: BrandKitWizardStatus.success)),
      );
    }
  }

  Future<void> loadExistingBrandKit() async {
    emit(state.copyWith(status: BrandKitWizardStatus.loading));

    final result = await _repository.getBrandKitByBrandId(brandId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: BrandKitWizardStatus.error,
        errorMessage: failure.message,
      )),
      (brandKit) {
        if (brandKit != null) {
          emit(state.copyWith(
            status: BrandKitWizardStatus.loaded,
            businessType: brandKit.businessType,
            toneOfVoice: brandKit.toneOfVoice,
            colors: brandKit.colors,
            targetAudience: brandKit.targetAudience,
            brandSummary: brandKit.brandSummary,
            existingBrandKitId: brandKit.id,
          ));
        } else {
          emit(state.copyWith(status: BrandKitWizardStatus.loaded));
        }
      },
    );
  }
}
