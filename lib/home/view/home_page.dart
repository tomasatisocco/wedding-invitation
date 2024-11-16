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
    return Scaffold(
      body: ListView(
        physics: isLocked ? const NeverScrollableScrollPhysics() : null,
        children: const [
          UnlockPage(),
        ],
      ),
    );
  }
}

class _SplashPage extends StatefulWidget {
  const _SplashPage();
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: const Color(0xFFEAE4DD),
        child: Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return AnimatedScale(
                scale: 3 + 1 * _scaleAnimation.value,
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  'assets/images/wedding_logo.png',
                  width: 150,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
