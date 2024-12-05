import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_player/video_player.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';
import 'package:wedding_invitation/home/widgets/assistance_page.dart';

import '../../helpers/pump_app.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

class MockVideoPlayerController extends Mock implements VideoPlayerController {}

const _invitationId = 'invitationId';

void main() {
  late HomeRepository homeRepository;
  late MockVideoPlayerController videoPlayerController;
  late Invitation mockInvitation;

  setUpAll(() {
    homeRepository = MockHomeRepository();
    videoPlayerController = MockVideoPlayerController();
    mockInvitation = const Invitation(
      id: '1',
      guests: [
        Guest(id: '1', name: 'Guest 1'),
        Guest(id: '2', name: 'Guest 2'),
      ],
    );
    final updatedMockInvitation = mockInvitation.copyWith(
      guests: [
        const Guest(id: '1', name: 'Guest 1', isAttending: true),
        const Guest(id: '2', name: 'Guest 2', isAttending: false),
      ],
    );

    when(() => homeRepository.initFirebase()).thenAnswer((_) async {});
    when(() => homeRepository.getInvitation(_invitationId)).thenAnswer(
      (_) async => mockInvitation,
    );

    when(() => homeRepository.updateInvitation(updatedMockInvitation))
        .thenAnswer(
      (_) async => true,
    );

    when(videoPlayerController.initialize).thenAnswer((_) async {});
    when(() => videoPlayerController.setLooping(true)).thenAnswer(
      (_) async => true,
    );
    when(() => videoPlayerController.setVolume(0)).thenAnswer(
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

  testWidgets('Assistance page displays initial widgets', (tester) async {
    final homeCubit = HomeCubit(
      homeRepository: homeRepository,
      invitationId: _invitationId,
      testing: true,
    );

    await homeCubit.initVideoController(videoPlayerController);
    await tester.pumpApp(
      Scaffold(
        body: RepositoryProvider(
          create: (context) => homeRepository,
          child: BlocProvider<HomeCubit>(
            create: (_) => homeCubit,
            child: const SingleChildScrollView(
              child: AssistancePage(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('ATTENDANCE'), findsOneWidget);
    expect(find.text('Yes'), findsNWidgets(2));
    expect(find.text('No'), findsNWidgets(2));
    expect(find.byType(ConfirmButton), findsOneWidget);
  });

  testWidgets('Assistance page update invitation', (tester) async {
    final homeCubit = HomeCubit(
      homeRepository: homeRepository,
      invitationId: _invitationId,
      testing: true,
    );

    await homeCubit.initVideoController(videoPlayerController);
    await tester.pumpApp(
      Scaffold(
        body: RepositoryProvider(
          create: (context) => homeRepository,
          child: BlocProvider<HomeCubit>(
            create: (_) => homeCubit,
            child: const SingleChildScrollView(
              child: AssistancePage(),
            ),
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(find.text('Confirm'), 50);
    await tester.tap(find.text('Yes').first);
    await tester.tap(find.text('No').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ConfirmButton));
    await tester.pumpAndSettle();

    expect(find.text('Confirmed'), findsOneWidget);
  });
}
