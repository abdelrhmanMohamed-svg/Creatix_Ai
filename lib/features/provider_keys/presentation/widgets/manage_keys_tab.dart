import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/provider_key.dart';
import '../cubit/provider_key_cubit.dart';
import '../cubit/provider_key_state.dart';
import '../widgets/widgets.dart';

class ManageKeysTab extends StatefulWidget {
  final VoidCallback onAddKey;

  const ManageKeysTab({super.key, required this.onAddKey});

  @override
  State<ManageKeysTab> createState() => _ManageKeysTabState();
}

class _ManageKeysTabState extends State<ManageKeysTab> {
  AiProvider? _filterProvider;

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
        } else if (state is ProviderKeyError) {
          debugPrint(state.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is ProviderKeyLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<ProviderKey> keys = [];
        if (state is ProviderKeysLoaded) {
          keys = state.providerKeys;
        }

        if (keys.isEmpty) {
          return EmptyState(onAddKey: widget.onAddKey);
        }

        return Column(
          children: [
            FilterChips(
              keys: keys,
              selectedProvider: _filterProvider,
              onFilterChanged: (provider) {
                setState(() {
                  _filterProvider = provider;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: keys.length,
                itemBuilder: (context, index) {
                  final key = keys[index];
                  if (_filterProvider != null &&
                      key.provider != _filterProvider) {
                    return const SizedBox.shrink();
                  }
                  return KeyCardFull(
                    providerKey: key,
                    onActivate: () => _activateKey(context, key.id!),
                    onDelete: () => _deleteKey(context, key.id!),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _activateKey(BuildContext context, String id) {
    context.read<ProviderKeyCubit>().activateProviderKey(id);
  }

  void _deleteKey(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete API Key'),
        content: const Text('Are you sure you want to delete this API key?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProviderKeyCubit>().deleteProviderKey(id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
