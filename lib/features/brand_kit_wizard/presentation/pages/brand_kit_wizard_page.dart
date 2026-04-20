import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/repositories/brand_kit_repository.dart';
import '../cubit/brand_kit_wizard_cubit.dart';
import '../cubit/brand_kit_wizard_state.dart';
import '../constants/wizard_steps.dart';

final sl = GetIt.instance;

class BrandKitWizardPage extends StatelessWidget {
  final String brandId;
  final VoidCallback? onComplete;

  const BrandKitWizardPage({
    super.key,
    required this.brandId,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandKitWizardCubit(
        repository: sl<BrandKitRepository>(),
        brandId: brandId,
      ),
      child: _BrandKitWizardContent(onComplete: onComplete),
    );
  }
}

class _BrandKitWizardContent extends StatefulWidget {
  final VoidCallback? onComplete;

  const _BrandKitWizardContent({this.onComplete});

  @override
  State<_BrandKitWizardContent> createState() => _BrandKitWizardContentState();
}

class _BrandKitWizardContentState extends State<_BrandKitWizardContent> {
  late BrandKitWizardCubit _cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = BlocProvider.of<BrandKitWizardCubit>(context, listen: false);
    _cubit.loadExistingBrandKit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrandKitWizardCubit, BrandKitWizardState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == BrandKitWizardStatus.success) {
          widget.onComplete?.call();
          _showSuccessSnackBar(context);
          _navigateBack(context);
        } else if (state.status == BrandKitWizardStatus.error) {
          _showErrorSnackBar(context, state.errorMessage ?? 'An error occurred');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Brand Kit Wizard'),
            actions: [
              if (state.currentStep > 0)
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () => _cubit.goToStep(0),
                ),
            ],
          ),
          body: Column(
            children: [
              _buildProgressIndicator(context, state),
              Expanded(
                child: _buildCurrentStep(state),
              ),
              _buildNavigationButtons(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(BuildContext context, BrandKitWizardState state) {
    final stepTitles = WizardStepsConfig.stepTitles;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(WizardStepsConfig.totalSteps, (index) {
              final isActive = index == state.currentStep;
              final isCompleted = index < state.currentStep;
              return _buildStepIndicatorItem(index, isActive, isCompleted);
            }),
          ),
          const SizedBox(height: 8),
          Text(
            WizardStepsConfig.getStepTitle(state.currentStep),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicatorItem(int index, bool isActive, bool isCompleted) {
    return GestureDetector(
      onTap: () {
        if (isCompleted || index == 0) {
          _cubit.goToStep(index);
        }
      },
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Theme.of(context).primaryColor
                  : isCompleted
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                      : Colors.grey.shade300,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          if (index < WizardStepsConfig.lastStepIndex)
            Container(
              width: 40,
              height: 2,
              color: isCompleted
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(BrandKitWizardState state) {
    if (state.status == BrandKitWizardStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return WizardStepsConfig.createStep(
      state.currentStep,
      onComplete: widget.onComplete,
    );
  }

  Widget _buildNavigationButtons(BuildContext context, BrandKitWizardState state) {
    if (state.currentStep == WizardStepsConfig.lastStepIndex) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (state.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _cubit.previousStep(),
                child: const Text('Back'),
              ),
            ),
          if (state.currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: state.currentStep > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: state.canProceedFromCurrentStep
                  ? () => _cubit.nextStep()
                  : null,
              child: Text(
                state.currentStep == 3 ? 'Review' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Brand Kit saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    Timer(const Duration(milliseconds: 500), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }
}