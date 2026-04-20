import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tone_of_voice.dart';
import '../cubit/brand_kit_wizard_cubit.dart';
import '../cubit/brand_kit_wizard_state.dart';

class ToneOfVoiceStep extends StatelessWidget {
  const ToneOfVoiceStep({super.key});

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
                'How should your brand sound?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose the tone of voice that best represents your brand\'s personality. This will guide how we craft your brand messaging.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ...ToneOfVoice.predefined.map((tone) {
                final isSelected = state.toneOfVoice == tone.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      context.read<BrandKitWizardCubit>().selectToneOfVoice(
                        tone.id,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                width: 2,
                              ),
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tone.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tone.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
