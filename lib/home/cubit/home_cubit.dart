import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:home_repository/home_repository.dart';
import 'package:retry/retry.dart';
import 'package:video_player/video_player.dart';

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

  Future<void> initVideoController([VideoPlayerController? controller]) async {
    try {
      emit(const HomeState());
      await retry<void>(
        maxAttempts: 5,
        () async {
          await _homeRepository.initFirebase();
          final invitation = await _homeRepository.getInvitation(_invitationId);
          final videoPlayerController = controller ??
              VideoPlayerController.networkUrl(
                Uri.parse(
                  'https://firebasestorage.googleapis.com/v0/b/wedding-invitation-4ee7d.firebasestorage.app/o/Videoleap_2023_10_01_11_14_08_462.mp4?alt=media&token=5308800c-286a-41ec-bc69-7496e157c705',
                ),
              );
          await videoPlayerController.initialize();
          await videoPlayerController.setVolume(0);
          await videoPlayerController.setLooping(true);
          await videoPlayerController.play();
          emit(
            HomeState(
              videoController: videoPlayerController,
              status: HomeStatus.loaded,
              scrollController: ScrollController(),
              invitation: invitation,
            ),
          );
        },
      );
    } catch (e) {
      emit(const HomeState(status: HomeStatus.error));
    }
  }

  Future<void> updateInvitation(Guest? guest) async {
    try {
      if (guest == null) return;
      final newInvitation = state.invitation!.copyWith(
        guests: state.invitation!.guests
            ?.map((e) => e.name == guest.name ? guest : e)
            .toList(),
      );

      final updated = await _homeRepository.updateInvitation(newInvitation);
      if (!updated) return;

      emit(
        HomeState(
          videoController: state.videoController,
          status: HomeStatus.loaded,
          scrollController: state.scrollController,
          invitation: newInvitation,
        ),
      );
    } catch (_) {}
  }

  final HomeRepository _homeRepository;
  final String? _invitationId;
}
