import 'package:flutter/material.dart';
import '../cubit/provider_key_state.dart';

class SubmitButton extends StatelessWidget {
  final ProviderKeyState state;
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = state is ProviderKeyLoading;
    return FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.save),
      label: const Text('Add API Key'),
    );
  }
}