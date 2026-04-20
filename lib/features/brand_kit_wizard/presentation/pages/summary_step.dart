import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/brand_kit_wizard_cubit.dart';
import '../cubit/brand_kit_wizard_state.dart';

class SummaryStep extends StatefulWidget {
  final VoidCallback? onComplete;

  const SummaryStep({super.key, this.onComplete});

  @override
  State<SummaryStep> createState() => _SummaryStepState();
}

class _SummaryStepState extends State<SummaryStep> {
  final _summaryController = TextEditingController();

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandKitWizardCubit, BrandKitWizardState>(
      builder: (context, state) {
        if (_summaryController.text.isEmpty && state.brandSummary != null) {
          _summaryController.text = state.brandSummary!;
        }

        final isGenerating =
            state.status == BrandKitWizardStatus.generatingSummary;
        final isSaving = state.status == BrandKitWizardStatus.saving;
        final hasError = state.status == BrandKitWizardStatus.error;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review your brand summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Here\'s a summary of your brand based on the information you provided. You can edit it manually if needed.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildSummaryCard(
                context,
                'Business Type',
                state.businessType ?? 'Not selected',
                Icons.business,
              ),
              _buildSummaryCard(
                context,
                'Tone of Voice',
                state.toneOfVoice ?? 'Not selected',
                Icons.record_voice_over,
              ),
              _buildSummaryCard(
                context,
                'Colors',
                state.colors.isEmpty ? 'Not selected' : state.colors.join(', '),
                Icons.palette,
              ),
              _buildSummaryCard(
                context,
                'Target Audience',
                state.targetAudience ?? 'Not entered',
                Icons.people,
              ),
              const SizedBox(height: 24),
              const Text(
                'Brand Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (isGenerating)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Generating brand summary...'),
                    ],
                  ),
                )
              else
                TextField(
                  controller: _summaryController,
                  maxLines: 6,
                  onChanged: (value) {
                    context.read<BrandKitWizardCubit>().setBrandSummary(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter a brand summary...',
                    border: OutlineInputBorder(),
                  ),
                ),
              if (hasError) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage ?? 'An error occurred',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () {
                          if (_summaryController.text.isNotEmpty) {
                            context.read<BrandKitWizardCubit>().setBrandSummary(
                              _summaryController.text,
                            );
                          }
                          context.read<BrandKitWizardCubit>().saveBrandKit();
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Save Brand Kit',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
