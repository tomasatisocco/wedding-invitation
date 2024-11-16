// test/unlock/cubit/unlock_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unlock_repository/unlock_repository.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';

class MockUnlockRepository extends Mock implements UnlockRepository {}

void main() {
  group('UnlockCubit', () {
    late MockUnlockRepository unlockRepository;

    setUp(() {
      unlockRepository = MockUnlockRepository();
    });

    test('initial state is UnlockState with loading status', () {
      final unlockCubit = UnlockCubit(unlockRepository: unlockRepository);
      expect(unlockCubit.state, UnlockStatus.locked);
    });

    blocTest<UnlockCubit, UnlockStatus>(
      'emits UnlockStatus with unlocked status when unlock is successful',
      build: () => UnlockCubit(unlockRepository: unlockRepository),
      act: (cubit) => cubit.unlock('Password'),
      setUp: () {
        when(
          () => unlockRepository.unlock('Password'),
        ).thenAnswer((_) async => true);
      },
      expect: () => [
        UnlockStatus.unlocking,
        UnlockStatus.unlocked,
      ],
    );

    blocTest<UnlockCubit, UnlockStatus>(
      'emits ErrorStatus with unlocked status when unlock is unsuccessful',
      build: () => UnlockCubit(unlockRepository: unlockRepository),
      act: (cubit) => cubit.unlock('WrongPassword'),
      setUp: () {
        when(
          () => unlockRepository.unlock('WrongPassword'),
        ).thenAnswer((_) async => false);
      },
      expect: () => [
        UnlockStatus.unlocking,
        UnlockStatus.error,
      ],
    );

    blocTest<UnlockCubit, UnlockStatus>(
      'emits ErrorStatus with unlocked status when unlock fails',
      build: () => UnlockCubit(unlockRepository: unlockRepository),
      act: (cubit) => cubit.unlock('WrongPassword'),
      setUp: () {
        when(() => unlockRepository.unlock('WrongPassword')).thenThrow(
          Exception('Wrong'),
        );
      },
      expect: () => [
        UnlockStatus.unlocking,
        UnlockStatus.error,
      ],
    );
  });
}
