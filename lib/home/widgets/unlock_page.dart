import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:video_player/video_player.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';

class UnlockPage extends StatelessWidget {
  const UnlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeCubit>().state.videoController!;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          ),
          const Positioned.fill(child: VideoOverlay()),
        ],
      ),
    );
  }
}

class VideoOverlay extends StatefulWidget {
  const VideoOverlay({super.key});

  @override
  State<VideoOverlay> createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<VideoOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _textEditingController = TextEditingController();

    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation.addListener(
      () {
        context
            .read<HomeCubit>()
            .state
            .videoController!
            .setVolume(_animationController.value);
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnlockCubit, UnlockStatus>(
      listener: (context, state) {
        if (state.isUnlocked) {
          _animationController.forward();
        }
        if (state.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong Password')),
          );
        }
      },
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          color: Colors.brown.withOpacity(0.6),
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 60,
                color: Colors.white,
              ),
              const Text(
                'Tomas & Emilia',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _textEditingController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'ENTER  PASSWORD',
                  fillColor: const Color(0xFFEFEBE5),
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                    minWidth: 300,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
              ),
              const Gap(16),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  minWidth: 300,
                  maxHeight: 50,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF9D887B),
                ),
                child: MaterialButton(
                  onPressed: () => context
                      .read<UnlockCubit>()
                      .unlock(_textEditingController.text),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: BlocBuilder<UnlockCubit, UnlockStatus>(
                      builder: (context, state) {
                        return Text(
                          (state.isUnlocking || state.isUnlocked)
                              ? 'SUBMITTING...'
                              : 'SUBMIT',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
