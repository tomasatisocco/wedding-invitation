import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';
import 'package:wedding_invitation/home/widgets/scroll_down_indicator.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';
import 'package:wedding_invitation/l10n/l10n.dart';

class UnlockPage extends StatelessWidget {
  const UnlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<HomeCubit>().state;
    final controller = state.videoController;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final height = controller?.player.state.height ?? 2160;
    final width = controller?.player.state.width ?? 3840;
    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: height.toDouble(),
                width: width.toDouble(),
                key: const Key('video_player_box'),
                child: controller != null
                    ? Video(controller: controller)
                    : const SizedBox(),
              ),
            ),
          ),
          const Positioned.fill(child: VideoOverlay()),
          const Positioned(
            bottom: 50,
            child: ScrollDownIndicator(),
          ),
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
            .videoController
            ?.player
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
    final names = context.read<HomeCubit>().state.invitationNames;
    final isSingle = names?.split('&').length == 1;
    return BlocListener<UnlockCubit, UnlockStatus>(
      listener: (context, state) {
        if (state.isUnlocked) {
          _animationController.forward();
        }
        if (state.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.somethingWrong)),
          );
        }
      },
      child: FadeTransition(
        key: const Key('unlock_fade_transition'),
        opacity: _opacityAnimation,
        child: Container(
          color: const Color(0xFF737373).withOpacity(0.6),
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                isSingle ? context.l10n.singleWelcome : context.l10n.welcome,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              const Gap(8),
              AutoSizeText(
                names ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              const Gap(16),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  minWidth: 300,
                  maxHeight: 56,
                ),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFa17a2d),
                      Color(0xFFfcfedb),
                      Color(0xFFa17a2d),
                      Color(0xFFfcfedb),
                      Color(0xFFa17a2d),
                      Color(0xFFfcfedb),
                    ],
                    tileMode: TileMode.repeated,
                    transform: GradientRotation(60),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _textEditingController,
                  key: const Key('unlock_password'),
                  textAlign: TextAlign.center,
                  onFieldSubmitted: (pass) =>
                      context.read<UnlockCubit>().unlock(pass),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.brown,
                  ),
                  decoration: InputDecoration(
                    hintText: context.l10n.enterPassword.toUpperCase(),
                    hintStyle: const TextStyle(
                      color: Colors.brown,
                      fontSize: 12,
                    ),
                    fillColor: Colors.white,
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                      minWidth: 300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                ),
              ),
              const Gap(16),
              BlocBuilder<UnlockCubit, UnlockStatus>(
                builder: (context, state) {
                  if (state.isUnlocking) {
                    return WeddingButton(
                      text: context.l10n.submitting.toUpperCase(),
                    );
                  }
                  return WeddingButton(
                    onPressed: () => context
                        .read<UnlockCubit>()
                        .unlock(_textEditingController.text),
                    text: context.l10n.submit.toUpperCase(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
