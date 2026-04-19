import 'package:creatix/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/usecases/create_brand.dart';
import '../../domain/usecases/delete_brand.dart';
import '../../domain/usecases/get_brands.dart';
import '../../domain/usecases/update_brand.dart';
import '../../domain/usecases/upload_brand_logo.dart';
import '../cubit/brand_cubit.dart';
import '../cubit/brand_state.dart';

final sl = GetIt.instance;

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandCubit(
        getBrandsUseCase: sl<GetBrands>(),
        createBrandUseCase: sl<CreateBrand>(),
        updateBrandUseCase: sl<UpdateBrand>(),
        deleteBrandUseCase: sl<DeleteBrand>(),
        uploadBrandLogoUseCase: sl<UploadBrandLogo>(),
      )..loadBrands(),
      child: const BrandsView(),
    );
  }
}

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        leadingWidth: 0.0,
        title: const Text('My Brands'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _navigateToProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.createBrand,
              );
              if (result == true && context.mounted) {
                context.read<BrandCubit>().loadBrands();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<BrandCubit, BrandState>(
        builder: (context, state) {
          if (state is BrandLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BrandError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.error ?? 'Something went wrong',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BrandCubit>().loadBrands();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is BrandEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No brands yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first brand to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        AppRoutes.createBrand,
                      );
                      if (result == true && context.mounted) {
                        context.read<BrandCubit>().loadBrands();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Brand'),
                  ),
                ],
              ),
            );
          }

          if (state is BrandLoaded ||
              state is BrandOperationLoading ||
              state is BrandOperationSuccess) {
            final brands = state is BrandLoaded
                ? state.brands
                : state is BrandOperationLoading
                ? state.brands
                : (state as BrandOperationSuccess).brands;
            final isDeleting = state is BrandOperationLoading;

            return ListView.builder(
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Dismissible(
                  key: Key(brand.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Brand'),
                        content: Text(
                          'Are you sure you want to delete "${brand.name}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    context.read<BrandCubit>().deleteBrand(brand.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${brand.name} deleted')),
                    );
                  },
                  child: ListTile(
                    leading: brand.logoUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(brand.logoUrl!),
                          )
                        : CircleAvatar(
                            child: Text(brand.name[0].toUpperCase()),
                          ),
                    title: Text(brand.name),
                    subtitle: Text(
                      'Created ${_formatDate(brand.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: isDeleting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: isDeleting
                        ? null
                        : () async {
                            final result = await Navigator.pushNamed(
                              context,
                              AppRoutes.updateBrand,
                              arguments: {
                                'brandId': brand.id,
                                'initialName': brand.name,
                                'initialLogoUrl': brand.logoUrl,
                              },
                            );
                            if (result == true && context.mounted) {
                              context.read<BrandCubit>().loadBrands();
                            }
                          },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToProfile(BuildContext context) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null && context.mounted) {
      await Navigator.pushNamed(context, AppRoutes.profile, arguments: userId);
    }
  }
}