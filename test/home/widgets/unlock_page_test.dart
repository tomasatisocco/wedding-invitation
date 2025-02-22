import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unlock_repository/unlock_repository.dart';

import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';
import 'package:wedding_invitation/home/widgets/unlock_page.dart';

import '../../helpers/pump_app.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

class MockVideoPlayerController extends Mock implements VideoController {}

class MockPlayer extends Mock implements Player {}

class MockUnlockRepository extends Mock implements UnlockRepository {}

const _invitationId = 'invitationId';

void main() {
  late MockUnlockRepository unlockRepository;
  late MockHomeRepository homeRepository;
  late MockVideoPlayerController videoPlayerController;
  late MockPlayer mockPlayer;

  setUpAll(() {
    homeRepository = MockHomeRepository();
    unlockRepository = MockUnlockRepository();
    videoPlayerController = MockVideoPlayerController();
    mockPlayer = MockPlayer();

    registerFallbackValue(Media(''));

    when(() => homeRepository.getInvitation(_invitationId)).thenAnswer(
      (_) async => const Invitation(),
    );
    when(() => homeRepository.initFirebase()).thenAnswer((_) async {});
    when(() => unlockRepository.unlock('Password')).thenAnswer(
      (_) async => true,
    );
    when(() => unlockRepository.unlock('WrongPassword')).thenAnswer(
      (_) async => false,
    );
    when(() => videoPlayerController.player).thenAnswer((_) => mockPlayer);
    when(() => mockPlayer.open(any())).thenAnswer((_) async {});
    when(() => mockPlayer.setPlaylistMode(PlaylistMode.loop)).thenAnswer(
      (_) async => true,
    );
    when(() => mockPlayer.setVolume(0)).thenAnswer((_) async => true);
    when(mockPlayer.play).thenAnswer((_) async {});
  });
  testWidgets('UnlockPage displays initial widgets', (tester) async {
    final homeCubit = HomeCubit(
      homeRepository: homeRepository,
      invitationId: _invitationId,
      testing: true,
    );
    await tester.pumpApp(
      Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(
              create: (_) => homeCubit,
            ),
            BlocProvider(
              create: (_) => UnlockCubit(
                unlockRepository: unlockRepository,
              ),
            ),
          ],
          child: const UnlockPage(),
        ),
      ),
    );

    expect(find.text('SUBMIT'), findsOneWidget);
    expect(find.byKey(const Key('video_player_box')), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(VideoOverlay), findsOneWidget);
  });

  testWidgets('Wrong Message is displayed', (tester) async {
    final homeCubit = HomeCubit(
      homeRepository: homeRepository,
      invitationId: _invitationId,
      testing: true,
    );
    await tester.pumpApp(
      Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) {
              return Scaffold(
                body: MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeCubit>(
                      create: (_) => homeCubit,
                    ),
                    BlocProvider(
                      create: (_) => UnlockCubit(
                        unlockRepository: unlockRepository,
                      ),
                    ),
                  ],
                  child: const UnlockPage(),
                ),
              );
            },
          ),
        ],
      ),
    );

    await tester.enterText(find.byType(TextField), 'WrongPassword');
    await tester.tap(find.text('SUBMIT'));
    await tester.pump();

    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('Correct Password is displayed', (tester) async {
    final homeCubit = HomeCubit(
      invitationId: _invitationId,
      homeRepository: homeRepository,
      testing: true,
    );
    final unlockCubit = UnlockCubit(unlockRepository: unlockRepository);
    await tester.pumpApp(
      Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) {
              return Scaffold(
                body: MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeCubit>(create: (_) => homeCubit),
                    BlocProvider(create: (_) => unlockCubit),
                  ],
                  child: const UnlockPage(),
                ),
              );
            },
          ),
        ],
      ),
    );

    await tester.enterText(find.byType(TextField), 'Password');
    await tester.tap(find.text('SUBMIT'));
    await tester.pump();

    verify(() => unlockRepository.unlock('Password')).called(1);
    expect(unlockCubit.state.isUnlocked, true);
  });
}
