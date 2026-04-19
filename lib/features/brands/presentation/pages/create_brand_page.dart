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

class CreateBrandPage extends StatelessWidget {
  const CreateBrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandCubit(
        getBrandsUseCase: sl<GetBrands>(),
        createBrandUseCase: sl<CreateBrand>(),
        updateBrandUseCase: sl<UpdateBrand>(),
        deleteBrandUseCase: sl<DeleteBrand>(),
        uploadBrandLogoUseCase: sl<UploadBrandLogo>(),
      )..initCreateBrandForm(),
      child: const _CreateBrandView(),
    );
  }
}

class _CreateBrandView extends StatelessWidget {
  const _CreateBrandView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Brand'),
        centerTitle: true,
      ),
      body: BlocConsumer<BrandCubit, BrandState>(
        listener: (context, state) {
          debugPrint('CreateBrandPage state: $state');
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
          if (state is! CreateBrandFormState) {
            return const Center(child: CircularProgressIndicator());
          }

          final logoUrl = state.logoUrl ?? '';
          debugPrint('CreateBrandPage logoUrl: $logoUrl, name: ${state.name}');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => context.read<BrandCubit>().pickLogoForCreate(),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: logoUrl.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(File(logoUrl), fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () => context.read<BrandCubit>().removeLogoForCreate(),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text('Tap to add logo (optional)', style: TextStyle(color: Colors.grey[600])),
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
                  onChanged: (value) => context.read<BrandCubit>().onCreateBrandNameChanged(value),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            debugPrint('Submitting create brand: ${state.name}');
                            context.read<BrandCubit>().submitCreateBrand();
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
                        : const Text('Create Brand'),
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