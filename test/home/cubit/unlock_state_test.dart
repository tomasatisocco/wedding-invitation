// test/unlock/cubit/unlock_state_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/cubit/unlock_cubit.dart';

void main() {
  group('UnlockState', () {
    test('supports value equality', () {
      expect(
        UnlockStatus.unlocking,
        UnlockStatus.unlocking,
      );
    });

    test('supports property equality', () {
      expect(
        UnlockStatus.unlocking,
        UnlockStatus.unlocking,
      );
    });

    test('isLoading returns true when status is loading', () {
      expect(
        UnlockStatus.unlocking.isUnlocking,
        true,
      );
    });

    test('isUnlocked returns true when status is unlocked', () {
      expect(
        UnlockStatus.unlocked.isUnlocked,
        true,
      );
    });

    test('isError returns true when status is error', () {
      expect(
        UnlockStatus.error.isError,
        true,
      );
    });
  });
}
