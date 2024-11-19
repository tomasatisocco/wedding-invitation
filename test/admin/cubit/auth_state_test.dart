import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/admin/cubit/auth_cubit.dart';

void main() {
  group('AuthState', () {
    test('supports value equality', () {
      expect(
        AuthStatus.unauthenticated,
        AuthStatus.unauthenticated,
      );
    });

    test('supports property equality', () {
      expect(
        AuthStatus.unauthenticated,
        AuthStatus.unauthenticated,
      );
    });

    test('isUnauthenticated returns true when status is unauthenticated', () {
      expect(
        AuthStatus.unauthenticated.isUnauthenticated,
        true,
      );
    });

    test('isAuthenticating returns true when status is authenticating', () {
      expect(
        AuthStatus.loading.isLoading,
        true,
      );
    });

    test('isAuthenticated returns true when status is authenticated', () {
      expect(
        AuthStatus.authenticated.isAuthenticated,
        true,
      );
    });

    test('isError returns true when status is error', () {
      expect(
        AuthStatus.error.isError,
        true,
      );
    });
  });
}
