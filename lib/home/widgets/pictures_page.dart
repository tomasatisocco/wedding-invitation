import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';

class PicturesPage extends StatefulWidget {
  const PicturesPage({super.key});

  @override
  PicturesPageState createState() => PicturesPageState();
}

class PicturesPageState extends State<PicturesPage> {
  late ScrollController _scrollController;
  double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = context.read<HomeCubit>().state.scrollController!;
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Gap(64),
        _ImageWidget(
          'assets/images/photo_section_1.png',
          _scrollPosition,
          0,
        ),
        const Gap(16),
        _ImageWidget(
          'assets/images/photo_section_2.png',
          _scrollPosition,
          1,
        ),
        const Gap(16),
        _ImageWidget(
          'assets/images/photo_section_3.png',
          _scrollPosition,
          2,
        ),
      ],
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget(
    this.imagePath,
    this.scrollPosition,
    this.index,
  );

  final String imagePath;
  final int index;
  final num scrollPosition;

  static const startOfWidget = 1100;
  static const delay = 200;

  double _calculateOpacity() {
    final animationStart = startOfWidget + index * delay;
    final animationEnd = animationStart + 300;
    if (scrollPosition < animationStart) return 0;
    if (scrollPosition > animationEnd) return 1;
    return (scrollPosition - animationStart) / (animationEnd - animationStart);
  }

  double _calculateOffset() {
    final animationStart = startOfWidget + index * delay;
    final animationEnd = animationStart + 300;
    final isLeft = index.isEven;
    const init = 400.0;
    if (scrollPosition < animationStart) return isLeft ? -init : init;
    if (scrollPosition > animationEnd) return 0;

    final progress =
        (scrollPosition - animationStart) / (animationEnd - animationStart);
    return (isLeft ? -init : init) * (1 - progress);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _calculateOpacity(),
      child: Transform.translate(
        offset: Offset(_calculateOffset(), 0),
        child: Image.asset(
          imagePath,
          width: 600,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
