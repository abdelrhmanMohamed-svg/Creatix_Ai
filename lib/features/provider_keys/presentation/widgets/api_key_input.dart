import 'package:flutter/material.dart';

class ApiKeyInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscured;
  final VoidCallback onToggleVisibility;

  const ApiKeyInput({
    super.key,
    required this.controller,
    required this.isObscured,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Key',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            hintText: 'Enter your API key',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your API key will be securely encrypted and stored',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }
}