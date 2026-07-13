import 'package:flutter/material.dart';
import '../../domain/entities/provider_key.dart';

class KeyCardCompact extends StatelessWidget {
  final ProviderKey providerKey;

  const KeyCardCompact({
    super.key,
    required this.providerKey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          providerKey.provider == AiProvider.openai
              ? Icons.smart_toy
              : Icons.auto_awesome,
          color: providerKey.provider == AiProvider.openai
              ? Colors.green
              : Colors.blue,
        ),
        title: Text(providerKey.providerDisplayName),
        subtitle: Text(
          providerKey.isValid ? 'Valid' : 'Invalid',
          style: TextStyle(
            color: providerKey.isValid ? Colors.green : Colors.red,
          ),
        ),
        trailing: providerKey.isActive
            ? const Chip(
                label: Text('Active'),
                backgroundColor: Colors.green,
              )
            : null,
      ),
    );
  }
}