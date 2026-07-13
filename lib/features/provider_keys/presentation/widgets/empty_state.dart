import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddKey;

  const EmptyState({
    super.key,
    required this.onAddKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.key_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No API Keys Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first API key to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAddKey,
            icon: const Icon(Icons.add),
            label: const Text('Add Key'),
          ),
        ],
      ),
    );
  }
}