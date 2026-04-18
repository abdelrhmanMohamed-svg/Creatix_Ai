import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:creatix/features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return ProfilePage(userId: state.user.id);
        }
        return const Scaffold(
          body: Center(child: Text('Error: No user found')),
        );
      },
    );
  }
}
