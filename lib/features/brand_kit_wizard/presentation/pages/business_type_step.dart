import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/business_type.dart';
import '../cubit/brand_kit_wizard_cubit.dart';
import '../cubit/brand_kit_wizard_state.dart';

class BusinessTypeStep extends StatelessWidget {
  const BusinessTypeStep({super.key});

  @override
  Widget build(BuildContext context) {
   
    return BlocBuilder<BrandKitWizardCubit, BrandKitWizardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What type of business is this brand for?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the category that best describes your business. This helps us tailor the branding suggestions to your industry.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: BusinessType.predefined.length,
                itemBuilder: (context, index) {
                  final type = BusinessType.predefined[index];
                  final isSelected = state.businessType == type.id;
                  return GestureDetector(
                    onTap: () {
                      context.read<BrandKitWizardCubit>().selectBusinessType(
                        type.id,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconData(type.icon),
                            size: 32,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            type.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    final icons = {
      'restaurant': Icons.restaurant,
      'computer': Icons.computer,
      'business': Icons.business,
      'store': Icons.store,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'account_balance': Icons.account_balance,
      'movie': Icons.movie,
      'flight': Icons.flight,
      'fastfood': Icons.fastfood,
      'checkroom': Icons.checkroom,
      'home': Icons.home,
      'fitness_center': Icons.fitness_center,
      'spa': Icons.spa,
      'more_horiz': Icons.more_horiz,
    };
    return icons[iconName] ?? Icons.business;
  }
}
