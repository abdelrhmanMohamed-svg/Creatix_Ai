import 'package:flutter/material.dart';
import '../../domain/entities/provider_key.dart';

class ProviderSelector extends StatelessWidget {
  final AiProvider selectedProvider;
  final ValueChanged<AiProvider> onProviderChanged;

  const ProviderSelector({
    super.key,
    required this.selectedProvider,
    required this.onProviderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Provider',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<AiProvider>(
          segments: const [
            ButtonSegment<AiProvider>(
              value: AiProvider.openai,
              label: Text('OpenAI'),
              icon: Icon(Icons.smart_toy),
            ),
            ButtonSegment<AiProvider>(
              value: AiProvider.gemini,
              label: Text('Gemini'),
              icon: Icon(Icons.auto_awesome),
            ),
          ],
          selected: {selectedProvider},
          onSelectionChanged: (selected) {
            onProviderChanged(selected.first);
          },
        ),
      ],
    );
  }
}