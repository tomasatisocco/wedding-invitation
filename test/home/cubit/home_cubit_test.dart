import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_player/video_player.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';

class MockVideoPlayerController extends Mock implements VideoPlayerController {}

void main() {
  group('HomeCubit', () {
    late MockVideoPlayerController mockVideoPlayerController;

    setUp(() {
      mockVideoPlayerController = MockVideoPlayerController();
    });

    test('initial state is HomeState with loading status', () {
      final homeCubit = HomeCubit();
      expect(homeCubit.state, const HomeState());
    });

    blocTest<HomeCubit, HomeState>(
      'emits HomeState with loaded status when video controller is initialized',
      build: () => HomeCubit(testing: true),
      setUp: () {
        when(mockVideoPlayerController.initialize).thenAnswer((_) async {});
        when(() => mockVideoPlayerController.setLooping(true)).thenAnswer(
          (_) async => true,
        );
        when(() => mockVideoPlayerController.setVolume(0)).thenAnswer(
          (_) async => true,
        );
        when(mockVideoPlayerController.play).thenAnswer((_) async {});
      },
      act: (cubit) => cubit.initVideoController(mockVideoPlayerController),
      expect: () => [
        const HomeState(),
        const HomeState(status: HomeStatus.loaded),
      ],
      verify: (cubit) {
        verify(() => mockVideoPlayerController.initialize()).called(1);
        verify(() => mockVideoPlayerController.setLooping(true)).called(1);
        verify(() => mockVideoPlayerController.setVolume(0)).called(1);
        verify(() => mockVideoPlayerController.play()).called(1);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'emits HomeState with error status when video controller initialization fails',
      build: () => HomeCubit(testing: true),
      setUp: () => when(mockVideoPlayerController.initialize).thenThrow(
        Exception(),
      ),
      act: (cubit) => cubit.initVideoController(mockVideoPlayerController),
      expect: () => [
        const HomeState(),
        const HomeState(status: HomeStatus.error),
      ],
      verify: (cubit) {
        verify(() => mockVideoPlayerController.initialize()).called(5);
      },
    );
  });
}
