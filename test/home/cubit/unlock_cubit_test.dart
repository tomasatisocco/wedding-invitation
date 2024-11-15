// test/unlock/cubit/unlock_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';

class MockHttpsCallable extends Mock implements HttpsCallable {}

class MockHttpsCallableResponse extends Mock
    implements HttpsCallableResult<Map<dynamic, dynamic>> {
  MockHttpsCallableResponse(this.data);

  @override
  final Map<dynamic, dynamic> data;
}

void main() {
  group('UnlockCubit', () {
    late MockHttpsCallable callable;
    late MockHttpsCallableResponse correctResponse;

    setUp(() {
      callable = MockHttpsCallable();
      correctResponse = MockHttpsCallableResponse({'unlocked': true});
    });

    test('initial state is UnlockState with loading status', () {
      final unlockCubit = UnlockCubit();
      expect(unlockCubit.state, UnlockStatus.locked);
    });

    blocTest<UnlockCubit, UnlockStatus>(
      'emits UnlockStatus with unlocked status when unlock is successful',
      build: UnlockCubit.new,
      act: (cubit) => cubit.unlock('Password', callable),
      setUp: () {
        when(
          () => callable.call<Map<dynamic, dynamic>>(
            <String, dynamic>{'password': 'Password'},
          ),
        ).thenAnswer(
          (_) async => correctResponse,
        );
      },
      expect: () => [
        UnlockStatus.unlocking,
        UnlockStatus.unlocked,
      ],
    );

    blocTest<UnlockCubit, UnlockStatus>(
      'emits ErrorStatus with unlocked status when unlock is successful',
      build: UnlockCubit.new,
      act: (cubit) => cubit.unlock('WrongPassword', callable),
      setUp: () {
        when(
          () => callable.call<Map<dynamic, dynamic>>(
            <String, dynamic>{'password': 'Password'},
          ),
        ).thenAnswer(
          (_) async => correctResponse,
        );
      },
      expect: () => [
        UnlockStatus.unlocking,
        UnlockStatus.error,
      ],
    );
  });
}
