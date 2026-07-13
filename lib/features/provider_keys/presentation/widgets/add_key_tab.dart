import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/provider_key.dart';
import '../cubit/provider_key_cubit.dart';
import '../cubit/provider_key_state.dart';
import '../widgets/widgets.dart';

class AddKeyTab extends StatefulWidget {
  final AiProvider selectedProvider;
  final bool isObscured;
  final TabController tabController;
  final ValueChanged<AiProvider> onProviderChanged;
  final VoidCallback onToggleVisibility;

  const AddKeyTab({
    super.key,
    required this.selectedProvider,
    required this.isObscured,
    required this.tabController,
    required this.onProviderChanged,
    required this.onToggleVisibility,
  });

  @override
  State<AddKeyTab> createState() => _AddKeyTabState();
}

class _AddKeyTabState extends State<AddKeyTab> {
  final _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderKeyCubit, ProviderKeyState>(
      listener: (context, state) {
        if (state is ProviderKeyOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          _apiKeyController.clear();
          widget.tabController.animateTo(1);
          context.read<ProviderKeyCubit>().loadProviderKeys();
        } else if (state is ProviderKeyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProviderSelector(
                selectedProvider: widget.selectedProvider,
                onProviderChanged: widget.onProviderChanged,
              ),
              const SizedBox(height: 24),
              ApiKeyInput(
                controller: _apiKeyController,
                isObscured: widget.isObscured,
                onToggleVisibility: widget.onToggleVisibility,
              ),
              const SizedBox(height: 24),
              SubmitButton(
                state: state,
                onPressed: () => _submitApiKey(context),
              ),
              const SizedBox(height: 32),
              _buildExistingKeysPreview(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExistingKeysPreview(BuildContext context) {
    return BlocBuilder<ProviderKeyCubit, ProviderKeyState>(
      builder: (context, state) {
        if (state is ProviderKeysLoaded && state.providerKeys.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Keys',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...state.providerKeys.take(2).map((key) => KeyCardCompact(providerKey: key)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _submitApiKey(BuildContext context) {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an API key'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    context.read<ProviderKeyCubit>().addProviderKey(
          provider: widget.selectedProvider,
          apiKey: apiKey,
        );
  }
}