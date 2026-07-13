import 'package:creatix/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/provider_key.dart';
import '../cubit/provider_key_cubit.dart';
import '../widgets/widgets.dart';

class ProviderKeyStoragePage extends StatefulWidget {
  const ProviderKeyStoragePage({super.key});

  @override
  State<ProviderKeyStoragePage> createState() => _ProviderKeyStoragePageState();
}

class _ProviderKeyStoragePageState extends State<ProviderKeyStoragePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AiProvider _selectedProvider = AiProvider.openai;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProviderKeyCubit>()..loadProviderKeys(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Provider Keys'),
              centerTitle: true,
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Add Key', icon: Icon(Icons.add)),
                  Tab(text: 'Manage Keys', icon: Icon(Icons.list)),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                AddKeyTab(
                  selectedProvider: _selectedProvider,
                  isObscured: _isObscured,
                  tabController: _tabController,
                  onProviderChanged: (provider) {
                    setState(() {
                      _selectedProvider = provider;
                    });
                  },
                  onToggleVisibility: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
                ManageKeysTab(onAddKey: () => _tabController.animateTo(0)),
              ],
            ),
          );
        }
      ),
    );
  }
}
