import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';
import 'package:media_kit/media_kit.dart';

import 'package:media_kit_video/media_kit_video.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';

class MockVideoPlayerController extends Mock implements VideoController {}

class MockPlayer extends Mock implements Player {}

class MockHomeRepository extends Mock implements HomeRepository {}

const _invitationId = 'invitationId';

void main() {
  group('HomeCubit', () {
    late MockPlayer mockPlayer;
    late MockVideoPlayerController mockVideoPlayerController;
    late MockHomeRepository mockHomeRepository;

    setUpAll(() {
      registerFallbackValue(Media(''));
    });

    setUp(() {
      mockVideoPlayerController = MockVideoPlayerController();
      mockHomeRepository = MockHomeRepository();
      mockPlayer = MockPlayer();
      when(() => mockHomeRepository.initFirebase()).thenAnswer((_) async {});
    });

    test('initial state is HomeState with loading status', () {
      final homeCubit = HomeCubit(
        homeRepository: MockHomeRepository(),
        invitationId: _invitationId,
      );
      expect(homeCubit.state, const HomeState());
    });

    blocTest<HomeCubit, HomeState>(
      'emits HomeState with loaded status when video controller is initialized',
      build: () => HomeCubit(
        testing: true,
        homeRepository: mockHomeRepository,
        invitationId: _invitationId,
      ),
      setUp: () {
        when(() => mockHomeRepository.getInvitation(_invitationId)).thenAnswer(
          (_) async => const Invitation(),
        );

        when(() => mockVideoPlayerController.player).thenAnswer(
          (_) => mockPlayer,
        );
        when(() => mockPlayer.open(any())).thenAnswer((_) async {});
        when(() => mockPlayer.setPlaylistMode(PlaylistMode.loop)).thenAnswer(
          (_) async => true,
        );
        when(() => mockPlayer.setVolume(0)).thenAnswer((_) async => true);
        when(mockPlayer.play).thenAnswer((_) async {});
      },
      act: (cubit) => cubit.initVideoController(mockVideoPlayerController),
      expect: () => [
        const HomeState(),
        const HomeState(status: HomeStatus.loaded),
      ],
      verify: (cubit) {
        verify(() => mockPlayer.open(any())).called(1);
        verify(() => mockPlayer..setPlaylistMode(PlaylistMode.loop)).called(1);
        verify(() => mockPlayer.setVolume(0)).called(1);
        verify(() => mockPlayer.play()).called(1);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'emits HomeState with error status when video controller initialization fails',
      build: () => HomeCubit(
        testing: true,
        homeRepository: mockHomeRepository,
        invitationId: _invitationId,
      ),
      setUp: () {
        when(() => mockHomeRepository.getInvitation(_invitationId)).thenAnswer(
          (_) async => const Invitation(),
        );
        when(() => mockVideoPlayerController.player).thenThrow(Exception());
      },
      act: (cubit) => cubit.initVideoController(mockVideoPlayerController),
      expect: () => [
        const HomeState(),
        const HomeState(status: HomeStatus.error),
      ],
      verify: (cubit) {
        verify(() => mockVideoPlayerController.player).called(5);
      },
    );
  });
}
