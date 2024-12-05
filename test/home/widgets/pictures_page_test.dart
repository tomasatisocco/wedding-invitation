import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_player/video_player.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/widgets/pictures_page.dart';

import '../../helpers/helpers.dart';
import '../cubit/home_cubit_test.dart';

void main() {
  late MockHomeRepository homeRepository;
  late MockVideoPlayerController videoPlayerController;

  setUpAll(() {
    homeRepository = MockHomeRepository();
    videoPlayerController = MockVideoPlayerController();

    when(() => homeRepository.getInvitation('')).thenAnswer(
      (_) async => const Invitation(),
    );
    when(() => homeRepository.initFirebase()).thenAnswer((_) async {});
    when(videoPlayerController.initialize).thenAnswer((_) async {});
    when(() => videoPlayerController.setLooping(true)).thenAnswer(
      (_) async => true,
    );
    when(() => videoPlayerController.setVolume(any())).thenAnswer(
      (_) async => true,
    );
    when(videoPlayerController.play).thenAnswer((_) async {});
    when(() => videoPlayerController.value).thenAnswer(
      (_) => const VideoPlayerValue(
        isInitialized: true,
        duration: Duration(seconds: 10),
        size: Size(100, 100),
      ),
    );
  });

  testWidgets('PicturesPage renders correctly', (tester) async {
    final homeCubit = HomeCubit(
      homeRepository: homeRepository,
      invitationId: '',
      testing: true,
    );
    await homeCubit.initVideoController(videoPlayerController);
    await tester.pumpApp(
      BlocProvider(
        create: (_) => homeCubit,
        child: SingleChildScrollView(
          controller: homeCubit.state.scrollController,
          child: const Column(
            children: [
              SizedBox(
                height: 2400,
              ),
              PicturesPage(),
            ],
          ),
        ),
      ),
    );

    homeCubit.state.scrollController?.jumpTo(2000);

    await tester.pump();

    expect(
      find.image(const AssetImage('assets/images/photo_section_1.png')),
      findsOneWidget,
    );
  });
}
