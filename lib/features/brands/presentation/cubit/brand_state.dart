import 'package:equatable/equatable.dart';
import '../../domain/entities/brand_entity.dart';

abstract class BrandState extends Equatable {
  final List<BrandEntity> brands;
  final bool isLoading;
  final String? error;

  const BrandState({
    this.brands = const [],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [brands, isLoading, error];
}

class BrandInitial extends BrandState {
  const BrandInitial() : super();
}

class BrandLoading extends BrandState {
  const BrandLoading() : super(isLoading: true);
}

class BrandLoaded extends BrandState {
  const BrandLoaded(List<BrandEntity> brands) : super(brands: brands);
}

class BrandEmpty extends BrandState {
  const BrandEmpty() : super();
}

class BrandError extends BrandState {
  const BrandError(String error) : super(error: error);
}

class BrandOperationLoading extends BrandState {
  final List<BrandEntity> brands;

  const BrandOperationLoading(this.brands)
      : super(brands: brands, isLoading: true);

  @override
  List<Object?> get props => [brands, isLoading, error];
}

class BrandOperationSuccess extends BrandState {
  final List<BrandEntity> brands;
  final String message;

  const BrandOperationSuccess(this.brands, this.message)
      : super(brands: brands);

  @override
  List<Object?> get props => [brands, message, isLoading, error];
}

class CreateBrandFormState extends BrandState {
  final String name;
  final String? logoUrl;
  final String? nameError;
  final bool isSubmitting;

  const CreateBrandFormState({
    this.name = '',
    this.logoUrl,
    this.nameError,
    this.isSubmitting = false,
    List<BrandEntity>? brands,
  }) : super(isLoading: isSubmitting, brands: brands ?? const []);

  @override
  List<Object?> get props =>
      [name, logoUrl, nameError, isSubmitting, brands, isLoading, error];

  CreateBrandFormState copyWith({
    String? name,
    String? logoUrl,
    String? nameError,
    bool? isSubmitting,
    List<BrandEntity>? brands,
  }) {
    return CreateBrandFormState(
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      nameError: nameError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      brands: brands ?? this.brands,
    );
  }
}

class UpdateBrandFormState extends BrandState {
  final String brandId;
  final String name;
  final String? logoUrl;
  final String? nameError;
  final bool isSubmitting;
  final bool logoRemoved;

  const UpdateBrandFormState({
    required this.brandId,
    this.name = '',
    this.logoUrl,
    this.nameError,
    this.isSubmitting = false,
    this.logoRemoved = false,
    List<BrandEntity>? brands,
  }) : super(isLoading: isSubmitting, brands: brands ?? const []);

  @override
  List<Object?> get props => [
        brandId,
        name,
        logoUrl,
        nameError,
        isSubmitting,
        logoRemoved,
        brands,
        isLoading,
        error
      ];

  UpdateBrandFormState copyWith({
    String? name,
    String? logoUrl,
    String? nameError,
    bool? isSubmitting,
    bool? logoRemoved,
    List<BrandEntity>? brands,
  }) {
    return UpdateBrandFormState(
      brandId: brandId,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      nameError: nameError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      logoRemoved: logoRemoved ?? this.logoRemoved,
      brands: brands ?? this.brands,
    );
  }
}
