import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:creatix/core/supabase/supabase_client.dart';
import '../../domain/usecases/get_brands.dart';
import '../../domain/usecases/create_brand.dart';
import '../../domain/usecases/update_brand.dart';
import '../../domain/usecases/delete_brand.dart';
import '../../domain/usecases/upload_brand_logo.dart';
import '../cubit/brand_cubit.dart';
import '../cubit/brand_state.dart';

final sl = GetIt.instance;

class UpdateBrandPage extends StatelessWidget {
  final String brandId;
  final String initialName;
  final String? initialLogoUrl;

  const UpdateBrandPage({
    super.key,
    required this.brandId,
    required this.initialName,
    this.initialLogoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = BrandCubit(
          getBrandsUseCase: sl<GetBrands>(),
          createBrandUseCase: sl<CreateBrand>(),
          updateBrandUseCase: sl<UpdateBrand>(),
          deleteBrandUseCase: sl<DeleteBrand>(),
          uploadBrandLogoUseCase: sl<UploadBrandLogo>(),
        );
        cubit.initUpdateBrandForm(brandId: brandId, name: initialName, logoUrl: initialLogoUrl);
        return cubit;
      },
      child: const _UpdateBrandView(),
    );
  }
}

class _UpdateBrandView extends StatelessWidget {
  const _UpdateBrandView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Brand'),
        centerTitle: true,
      ),
      body: BlocConsumer<BrandCubit, BrandState>(
        listener: (context, state) {
          debugPrint('UpdateBrandPage state: $state');
          if (state is BrandLoaded || state is BrandEmpty) {
            Navigator.pop(context, true);
          }
          if (state is BrandError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Error'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is! UpdateBrandFormState) {
            return const Center(child: CircularProgressIndicator());
          }

          final logoUrl = state.logoUrl;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => context.read<BrandCubit>().pickLogoForUpdate(),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: logoUrl != null && logoUrl.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: logoUrl.startsWith('/')
                                    ? Image.file(File(logoUrl), fit: BoxFit.cover)
                                    : Image.network(logoUrl, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () => context.read<BrandCubit>().removeLogoForUpdate(),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text('Tap to change logo', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: state.name,
                  decoration: InputDecoration(
                    labelText: 'Brand Name',
                    hintText: 'Enter brand name',
                    errorText: state.nameError,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (value) => context.read<BrandCubit>().onUpdateBrandNameChanged(value),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            debugPrint('Submitting update brand: ${state.name}');
                            context.read<BrandCubit>().submitUpdateBrand();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                          )
                        : const Text('Update Brand'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}