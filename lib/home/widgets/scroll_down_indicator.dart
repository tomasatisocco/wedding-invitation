import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';

class ScrollDownIndicator extends StatefulWidget {
  const ScrollDownIndicator({super.key});

  @override
  ScrollablePageState createState() => ScrollablePageState();
}

class ScrollablePageState extends State<ScrollDownIndicator>
    with SingleTickerProviderStateMixin {
  late ScrollController? _scrollController;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isArrowVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scrollController = context.read<HomeCubit>().state.scrollController;

    _scrollController?.addListener(() {
      final isScrolled = (_scrollController?.position.pixels ?? 0) > 50;
      if (isScrolled && _isArrowVisible) {
        setState(() {
          _isArrowVisible = false;
        });
      } else if (!isScrolled && !_isArrowVisible) {
        setState(() {
          _isArrowVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnlockCubit, UnlockStatus>(
      listener: (context, state) async {
        if (state.isUnlocked) {
          final position = _scrollController?.position.pixels ?? 0;
          if (position <= 50) {
            setState(() {
              _isArrowVisible = true;
            });
          }
        }
      },
      child: AnimatedOpacity(
        opacity: _isArrowVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value), // Move the arrow up and down
              child: child,
            );
          },
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
