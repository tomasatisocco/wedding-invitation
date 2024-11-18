import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';
import 'package:wedding_invitation/admin/cubit/auth_cubit.dart';
import 'package:wedding_invitation/admin/view/invitations_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(
            adminRepository: context.read<AdminRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => AdminCubit(
            adminRepository: context.read<AdminRepository>(),
          ),
        ),
      ],
      child: const AdminPageView(),
    );
  }
}

class AdminPageView extends StatelessWidget {
  const AdminPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStatus>(
      builder: (context, state) {
        if (state.isAuthenticated) return const InvitationsPage();
        return const LoginPage();
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthStatus>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().authenticateWithGoogle();
                  },
                  child: const Text('Login'),
                ),
                const Gap(8),
                Visibility(
                  visible: state.isError,
                  child: const Text(
                    'Error',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
