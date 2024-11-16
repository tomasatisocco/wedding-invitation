import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_repository/home_repository.dart';
import 'package:unlock_repository/unlock_repository.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';
import 'package:wedding_invitation/home/widgets/unlock_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(
            homeRepository: context.read<HomeRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => UnlockCubit(
            unlockRepository: context.read<UnlockRepository>(),
          ),
        ),
      ],
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLocked =
        context.select((UnlockCubit cubit) => cubit.state.isLocked);
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.isLoading) const _LoadingPage();
        final videoController = state.videoController;
        if (videoController == null) return const _LoadingPage();
        return Scaffold(
          body: ListView(
            physics: isLocked ? const NeverScrollableScrollPhysics() : null,
            children: const [
              UnlockPage(),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
