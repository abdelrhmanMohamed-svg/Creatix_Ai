import 'package:flutter/material.dart';
import '../../domain/entities/provider_key.dart';

class KeyCardFull extends StatelessWidget {
  final ProviderKey providerKey;
  final VoidCallback onActivate;
  final VoidCallback onDelete;

  const KeyCardFull({
    super.key,
    required this.providerKey,
    required this.onActivate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  providerKey.provider == AiProvider.openai
                      ? Icons.smart_toy
                      : Icons.auto_awesome,
                  color: providerKey.provider == AiProvider.openai
                      ? Colors.green
                      : Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerKey.providerDisplayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        providerKey.isValid ? 'Valid' : 'Invalid',
                        style: TextStyle(
                          color: providerKey.isValid ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                if (providerKey.isActive)
                  const Chip(
                    label: Text('Active'),
                    backgroundColor: Colors.green,
                  ),
              ],
            ),
            if (providerKey.lastValidatedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Last validated: ${_formatDate(providerKey.lastValidatedAt!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!providerKey.isActive)
                  TextButton.icon(
                    onPressed: onActivate,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Activate'),
                  ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}