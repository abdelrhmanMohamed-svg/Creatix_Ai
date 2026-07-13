import 'package:flutter/material.dart';
import '../../domain/entities/provider_key.dart';

class FilterChips extends StatelessWidget {
  final List<ProviderKey> keys;
  final AiProvider? selectedProvider;
  final ValueChanged<AiProvider?> onFilterChanged;

  const FilterChips({
    super.key,
    required this.keys,
    required this.selectedProvider,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedProvider == null,
            onSelected: (_) => onFilterChanged(null),
          ),
          const SizedBox(width: 8),
          if (keys.any((k) => k.provider == AiProvider.openai))
            FilterChip(
              label: const Text('OpenAI'),
              avatar: const Icon(Icons.smart_toy, size: 18),
              selected: selectedProvider == AiProvider.openai,
              onSelected: (_) => onFilterChanged(AiProvider.openai),
            ),
          const SizedBox(width: 8),
          if (keys.any((k) => k.provider == AiProvider.gemini))
            FilterChip(
              label: const Text('Gemini'),
              avatar: const Icon(Icons.auto_awesome, size: 18),
              selected: selectedProvider == AiProvider.gemini,
              onSelected: (_) => onFilterChanged(AiProvider.gemini),
            ),
        ],
      ),
    );
  }
}