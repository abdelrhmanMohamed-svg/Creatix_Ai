import 'dart:async';
import 'dart:io';

import 'package:creatix/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:creatix/core/constants/app_routes.dart';
import 'package:creatix/features/brand_kit_wizard/domain/repositories/brand_kit_repository.dart';
import '../../domain/usecases/get_brands.dart';
import '../../domain/usecases/create_brand.dart';
import '../../domain/usecases/update_brand.dart';
import '../../domain/usecases/delete_brand.dart';
import '../../domain/usecases/upload_brand_logo.dart';
import '../cubit/brand_cubit.dart';
import '../cubit/brand_state.dart';


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
          getBrandsUseCase: getIt<GetBrands>(),
          createBrandUseCase: getIt<CreateBrand>(),
          updateBrandUseCase: getIt<UpdateBrand>(),
          deleteBrandUseCase: getIt<DeleteBrand>(),
          uploadBrandLogoUseCase: getIt<UploadBrandLogo>(),
        );
        cubit.initUpdateBrandForm(brandId: brandId, name: initialName, logoUrl: initialLogoUrl);
        return cubit;
      },
      child: _BrandDetailWithTabs(brandId: brandId),
    );
  }
}

class _BrandDetailWithTabs extends StatefulWidget {
  final String brandId;

  const _BrandDetailWithTabs({required this.brandId});

  @override
  State<_BrandDetailWithTabs> createState() => _BrandDetailWithTabsState();
}

class _BrandDetailWithTabsState extends State<_BrandDetailWithTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Details'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Brand Kit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BrandDetailsTab(brandId: widget.brandId),
          _BrandKitTab(brandId: widget.brandId),
        ],
      ),
    );
  }
}

class _BrandDetailsTab extends StatelessWidget {
  final String brandId;

  const _BrandDetailsTab({required this.brandId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BrandCubit, BrandState>(
      listener: (context, state) {
        if (state is BrandLoaded || state is BrandEmpty) {
          Navigator.pop(context, true);
        } else if (state is BrandError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Failed to update brand')),
          );
        }
      },
      child: BlocBuilder<BrandCubit, BrandState>(
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
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => _showDeleteDialog(context, brandId),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Delete Brand'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String brandId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Brand'),
        content: const Text('Are you sure you want to delete this brand? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BrandCubit>().deleteBrand(brandId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _BrandKitTab extends StatefulWidget {
  final String brandId;

  const _BrandKitTab({required this.brandId});

  @override
  State<_BrandKitTab> createState() => _BrandKitTabState();
}

class _BrandKitTabState extends State<_BrandKitTab> {
  bool _isLoading = true;
  bool _hasBrandKit = false;
  Map<String, dynamic>? _brandKitData;

  @override
  void initState() {
    super.initState();
    _loadBrandKit();
  }

  Future<void> _loadBrandKit() async {
    final repository = getIt<BrandKitRepository>();
    final result = await repository.getBrandKitByBrandId(widget.brandId);
    
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _hasBrandKit = false;
        });
      },
      (brandKit) {
        setState(() {
          _isLoading = false;
          _hasBrandKit = brandKit != null;
          if (brandKit != null) {
            _brandKitData = {
              'businessType': brandKit.businessType,
              'toneOfVoice': brandKit.toneOfVoice,
              'colors': brandKit.colors,
              'targetAudience': brandKit.targetAudience,
              'brandSummary': brandKit.brandSummary,
            };
          }
        });
      },
    );
  }

  void _navigateToWizard() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.brandKitWizard,
      arguments: {'brandId': widget.brandId},
    );
    if (result == true) {
      _loadBrandKit();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasBrandKit) {
      return _buildEmptyState();
    }

    return _buildBrandKitSummary();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.palette_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Brand Kit Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a Brand Kit to define your brand identity including business type, tone, colors, and target audience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _navigateToWizard,
                icon: const Icon(Icons.add),
                label: const Text('Create Brand Kit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandKitSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Business Type',
            _brandKitData?['businessType'] ?? 'Not set',
            Icons.business,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Tone of Voice',
            _brandKitData?['toneOfVoice'] ?? 'Not set',
            Icons.record_voice_over,
          ),
          const SizedBox(height: 12),
          _buildColorCard(
            'Colors',
            _brandKitData?['colors'] ?? [],
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Target Audience',
            _brandKitData?['targetAudience'] ?? 'Not set',
            Icons.people,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Brand Summary',
            _brandKitData?['brandSummary'] ?? 'Not set',
            Icons.description,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _navigateToWizard,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Brand Kit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard(String title, List<String> colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.palette, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                if (colors.isEmpty)
                  const Text('Not set', style: TextStyle(fontSize: 14))
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: colors.map((color) {
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}