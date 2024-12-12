import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:home_repository/home_repository.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:retry/retry.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required HomeRepository homeRepository,
    required String? invitationId,
    bool? testing,
  })  : _homeRepository = homeRepository,
        _invitationId = invitationId,
        super(const HomeState()) {
    if (testing ?? false) return;
    initVideoController();
  }

  static const animationStepDuration = Duration(milliseconds: 80);

  Future<void> initVideoController([VideoController? controller]) async {
    try {
      emit(const HomeState());
      await retry<void>(
        maxAttempts: 5,
        () async {
          await _homeRepository.initFirebase();
          final invitation = await _homeRepository.getInvitation(_invitationId);
          final videoPlayerController = controller ?? VideoController(Player());
          final player = videoPlayerController.player;
          await player.open(
            Media(
              'https://firebasestorage.googleapis.com/v0/b/wedding-invitation-4ee7d.firebasestorage.app/o/wedding_video_1080p_smaller.mp4?alt=media&token=5308800c-286a-41ec-bc69-7496e157c705',
            ),
          );
          await player.setPlaylistMode(PlaylistMode.loop);
          await player.setVolume(0);
          await player.play();
          emit(
            HomeState(
              videoController: videoPlayerController,
              status: HomeStatus.loaded,
              scrollController: createScrollController(videoPlayerController),
              invitation: invitation,
            ),
          );
        },
      );
    } catch (e) {
      emit(const HomeState(status: HomeStatus.error));
    }
  }

  ScrollController createScrollController(VideoController controller) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      const maxExtent = 1000;
      final scrolled = scrollController.offset / maxExtent;
      final volume = 1 - scrolled;
      controller.player.setVolume(volume < 0 ? 0 : volume);
    });
    return scrollController;
  }

  final HomeRepository _homeRepository;
  final String? _invitationId;
}
