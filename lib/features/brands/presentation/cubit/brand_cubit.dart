import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:creatix/core/constants/storage_constants.dart';
import 'package:creatix/core/utils/validators.dart';
import 'package:creatix/core/utils/error_handler.dart';
import '../../domain/usecases/get_brands.dart';
import '../../domain/usecases/create_brand.dart';
import '../../domain/usecases/update_brand.dart';
import '../../domain/usecases/delete_brand.dart';
import '../../domain/usecases/upload_brand_logo.dart';
import 'brand_state.dart';

class BrandCubit extends Cubit<BrandState> {
  final GetBrands getBrandsUseCase;
  final CreateBrand createBrandUseCase;
  final UpdateBrand updateBrandUseCase;
  final DeleteBrand deleteBrandUseCase;
  final UploadBrandLogo uploadBrandLogoUseCase;
  final ImagePicker _imagePicker = ImagePicker();

  BrandCubit({
    required this.getBrandsUseCase,
    required this.createBrandUseCase,
    required this.updateBrandUseCase,
    required this.deleteBrandUseCase,
    required this.uploadBrandLogoUseCase,
  }) : super(const BrandInitial());

  SupabaseClient get _supabase => Supabase.instance.client;

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  void initCreateBrandForm() {
    emit(const CreateBrandFormState());
  }

  void initUpdateBrandForm({
    required String brandId,
    required String name,
    String? logoUrl,
  }) {
    emit(UpdateBrandFormState(
      brandId: brandId,
      name: name,
      logoUrl: logoUrl,
    ));
  }

  void onCreateBrandNameChanged(String name) {
    final currentState = state;
    if (currentState is CreateBrandFormState) {
      final error = Validators.brandName(name);
      emit(currentState.copyWith(name: name, nameError: error));
    }
  }

  void onUpdateBrandNameChanged(String name) {
    final currentState = state;
    if (currentState is UpdateBrandFormState) {
      final error = Validators.brandName(name);
      emit(currentState.copyWith(name: name, nameError: error));
    }
  }

  Future<void> pickLogoForCreate() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: StorageConstants.maxImageWidth,
      maxHeight: StorageConstants.maxImageHeight,
      imageQuality: StorageConstants.imageQuality,
    );

    if (pickedFile != null) {
      final currentState = state;
      if (currentState is CreateBrandFormState) {
        emit(currentState.copyWith(logoUrl: pickedFile.path));
      }
    }
  }

  Future<void> pickLogoForUpdate() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: StorageConstants.maxImageWidth,
      maxHeight: StorageConstants.maxImageHeight,
      imageQuality: StorageConstants.imageQuality,
    );

    if (pickedFile != null) {
      final currentState = state;
      if (currentState is UpdateBrandFormState) {
        emit(currentState.copyWith(
            logoUrl: pickedFile.path, logoRemoved: false));
      }
    }
  }

  void removeLogoForCreate() {
    final currentState = state;
    if (currentState is CreateBrandFormState) {
      emit(CreateBrandFormState(
        name: currentState.name,
        nameError: currentState.nameError,
        logoUrl: null,
        isSubmitting: currentState.isSubmitting,
      ));
    }
  }

  void removeLogoForUpdate() {
    final currentState = state;
    if (currentState is UpdateBrandFormState) {
      emit(currentState.copyWith(logoUrl: null, logoRemoved: true));
    }
  }

  Future<void> submitCreateBrand() async {
    final currentState = state;
    if (currentState is! CreateBrandFormState) return;

    final nameError = Validators.brandName(currentState.name);
    if (nameError != null) {
      emit(currentState.copyWith(nameError: nameError));
      return;
    }

    emit(currentState.copyWith(isSubmitting: true));

    try {
      final userId = _currentUserId;
      debugPrint('User ID: $userId');
      if (userId == null) {
        emit(currentState.copyWith(isSubmitting: false));
        return;
      }

      String? logoUrl;
      if (currentState.logoUrl != null) {
        final logoResult = await uploadBrandLogoUseCase(
          filePath: currentState.logoUrl!,
          userId: userId,
        );

        logoUrl = logoResult.fold(
          (failure) {
            debugPrint('Logo upload failed: ${failure.message}');
            return null;
          },
          (url) => url,
        );

        if (logoUrl != null) {
          debugPrint('Logo uploaded: $logoUrl');
        }
      }

      final createResult = await createBrandUseCase(
        userId: userId,
        name: currentState.name.trim(),
        logoUrl: logoUrl,
      );

      debugPrint('Brand created successfully');

      final brandsResult = await getBrandsUseCase(userId);
      brandsResult.fold(
        (failure) {
          debugPrint('Error loading brands after create: ${failure.message}');
          emit(BrandError(failure.message));
        },
        (brands) {
          if (brands.isEmpty) {
            emit(const BrandEmpty());
          } else {
            emit(BrandLoaded(brands));
          }
        },
      );
    } catch (e) {
      debugPrint('Error creating brand: $e');
      final errorMsg = ErrorHandler.extractErrorMessage(e);
      emit(BrandError(errorMsg));
    }
  }

  Future<void> submitUpdateBrand() async {
    final currentState = state;
    if (currentState is! UpdateBrandFormState) return;

    final nameError = Validators.brandName(currentState.name);
    if (nameError != null) {
      emit(currentState.copyWith(nameError: nameError));
      return;
    }

    emit(currentState.copyWith(isSubmitting: true));

    try {
      String? logoUrl;

      if (currentState.logoUrl != null && !currentState.logoRemoved) {
        if (!currentState.logoUrl!.startsWith('/')) {
          logoUrl = currentState.logoUrl;
        } else {
          final userId = _currentUserId;
          if (userId != null) {
            final logoResult = await uploadBrandLogoUseCase(
              filePath: currentState.logoUrl!,
              userId: userId,
              brandId: currentState.brandId,
            );

            logoUrl = logoResult.fold(
              (failure) {
                debugPrint('Logo upload failed: ${failure.message}');
                return null;
              },
              (url) => url,
            );
          }
        }
      }

      await updateBrandUseCase(
        id: currentState.brandId,
        name: currentState.name.trim(),
        logoUrl: currentState.logoRemoved ? null : logoUrl,
      );

      final userId = _currentUserId;
      final result = await getBrandsUseCase(userId ?? '');
      result.fold(
        (failure) => emit(BrandError(failure.message)),
        (brands) => emit(BrandLoaded(brands)),
      );
    } catch (e) {
      debugPrint('Error updating brand: $e');
      final errorMsg = ErrorHandler.extractErrorMessage(e);
      emit(BrandError(errorMsg));
    }
  }

  Future<void> loadBrands() async {
    emit(const BrandLoading());

    final userId = _currentUserId;
    if (userId == null) {
      emit(const BrandError('User not authenticated'));
      return;
    }

    final result = await getBrandsUseCase(userId);

    result.fold(
      (failure) => emit(BrandError(failure.message)),
      (brands) {
        if (brands.isEmpty) {
          emit(const BrandEmpty());
        } else {
          emit(BrandLoaded(brands));
        }
      },
    );
  }

  Future<void> deleteBrand(String brandId) async {
    final currentState = state;
    if (currentState is BrandLoaded) {
      emit(BrandOperationLoading(currentState.brands));
    }

    final result = await deleteBrandUseCase(brandId);

    result.fold(
      (failure) {
        if (currentState is BrandLoaded) {
          emit(BrandError(failure.message));
          emit(BrandLoaded(currentState.brands));
        } else {
          emit(BrandError(failure.message));
        }
      },
      (_) async {
        final userId = _currentUserId;
        final brandsResult = await getBrandsUseCase(userId ?? '');
        brandsResult.fold(
          (failure) => emit(BrandError(failure.message)),
          (brands) {
            if (brands.isEmpty) {
              emit(const BrandEmpty());
            } else {
              emit(BrandOperationSuccess(brands, 'Brand deleted successfully'));
              emit(BrandLoaded(brands));
            }
          },
        );
      },
    );
  }
}
