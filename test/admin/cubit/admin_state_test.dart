// test/admin/cubit/admin_state_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';

void main() {
  group('AdminState', () {
    test('supports value equality', () {
      expect(
        const AdminState(),
        const AdminState(),
      );
    });

    test('supports property equality', () {
      expect(
        const AdminState().props,
        const AdminState().props,
      );
    });

    test('isLoading returns true when status is loading', () {
      expect(
        const AdminState().isLoading,
        true,
      );
    });

    test('isLoaded returns true when status is loaded', () {
      expect(
        const AdminState(status: AdminStatus.loaded).isLoaded,
        true,
      );
    });

    test('isError returns true when status is error', () {
      expect(
        const AdminState(status: AdminStatus.error).isError,
        true,
      );
    });
  });
}
