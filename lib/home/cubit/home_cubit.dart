import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:retry/retry.dart';
import 'package:video_player/video_player.dart';
import 'package:wedding_invitation/firebase_options.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({bool? testing}) : super(const HomeState()) {
    if (testing ?? false) return;
    initFirebase();
    initVideoController();
  }

  static const animationStepDuration = Duration(milliseconds: 80);

  Future<void> initVideoController([VideoPlayerController? controller]) async {
    try {
      emit(const HomeState());
      await retry<void>(
        maxAttempts: 5,
        () async {
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
            ),
          );
        },
      );
    } catch (e) {
      emit(const HomeState(status: HomeStatus.error));
    }
  }

  Future<void> initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {}
  }
}
