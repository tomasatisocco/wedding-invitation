import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/widgets/pictures_page.dart';

import '../../helpers/helpers.dart';
import '../cubit/home_cubit_test.dart';

class MockPlayer extends Mock implements Player {}

void main() {
  late MockHomeRepository homeRepository;
  late MockVideoPlayerController videoPlayerController;
  late MockPlayer mockPlayer;

  setUpAll(() {
    homeRepository = MockHomeRepository();
    videoPlayerController = MockVideoPlayerController();
    mockPlayer = MockPlayer();

    registerFallbackValue(Media(''));

    when(() => homeRepository.getInvitation('')).thenAnswer(
      (_) async => const Invitation(),
    );
    when(() => homeRepository.initFirebase()).thenAnswer((_) async {});
    when(() => videoPlayerController.player).thenAnswer((_) => mockPlayer);
    when(() => mockPlayer.open(any())).thenAnswer((_) async {});
    when(() => mockPlayer.setPlaylistMode(PlaylistMode.loop)).thenAnswer(
      (_) async => true,
    );
    when(() => mockPlayer.setVolume(0)).thenAnswer((_) async => true);
    when(mockPlayer.play).thenAnswer((_) async {});
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
