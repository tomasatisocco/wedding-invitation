import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_repository/home_repository.dart';
import 'package:unlock_repository/unlock_repository.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';
import 'package:wedding_invitation/home/widgets/assistance_page.dart';
import 'package:wedding_invitation/home/widgets/count_down_page.dart';
import 'package:wedding_invitation/home/widgets/dress_code_page.dart';
import 'package:wedding_invitation/home/widgets/foreign_guide_page.dart';
import 'package:wedding_invitation/home/widgets/gift_page.dart';
import 'package:wedding_invitation/home/widgets/info_page.dart';
import 'package:wedding_invitation/home/widgets/pictures_page.dart';
import 'package:wedding_invitation/home/widgets/unlock_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.id,
    super.key,
  });

  final String? id;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(
            homeRepository: context.read<HomeRepository>(),
            invitationId: id,
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
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: state.isLoaded ? const _HomeWidget() : const _SplashPage(),
        );
      },
    );
  }
}

class _HomeWidget extends StatelessWidget {
  const _HomeWidget();

  @override
  Widget build(BuildContext context) {
    final isLocked =
        context.select((UnlockCubit cubit) => cubit.state.isLocked);
    final scrollController = context.read<HomeCubit>().state.scrollController;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: isLocked ? const NeverScrollableScrollPhysics() : null,
        controller: scrollController,
        child: const Column(
          children: [
            ForeignGuidePage(),
            UnlockPage(),
            CountDownPage(),
            InfoPage(),
            DressCodePage(),
            PicturesPage(),
            GiftPage(),
            AssistancePage(),
          ],
        ),
      ),
    );
  }
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/gif/splash.gif'),
      ),
    );
  }
}
