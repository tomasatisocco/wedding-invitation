import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/cubit/auth_cubit.dart';

import '../../mocks.dart';

void main() {
  group('AuthCubit', () {
    late AuthCubit authCubit;
    late MockAdminRepository mockAdminRepository;

    setUp(() {
      mockAdminRepository = MockAdminRepository();
      authCubit = AuthCubit(
        adminRepository: mockAdminRepository,
        testing: true,
      );

      when(() => mockAdminRepository.initFirebase()).thenAnswer((_) async {});
      when(() => mockAdminRepository.listenToAuthState()).thenAnswer(
        (_) => const Stream.empty(),
      );
    });

    test('initial state is AuthStatus with unauthenticated status', () {
      expect(authCubit.state, AuthStatus.unauthenticated);
    });

    blocTest<AuthCubit, AuthStatus>(
      'emits AuthStatus with authenticating status when login is called',
      build: () => authCubit,
      setUp: () {
        when(() => mockAdminRepository.authenticateWithGoogle()).thenAnswer(
          (_) async => null,
        );
        when(() => mockAdminRepository.isAdminUser('')).thenAnswer(
          (_) async => true,
        );
      },
      act: (cubit) async {
        await cubit.initializeFirebase();
        await cubit.authenticateWithGoogle();
      },
      expect: () => [
        AuthStatus.loading,
        AuthStatus.authenticated,
      ],
    );

    blocTest<AuthCubit, AuthStatus>(
      'emits AuthStatus with error status when login fails',
      build: () => authCubit,
      setUp: () {
        when(() => mockAdminRepository.authenticateWithGoogle()).thenThrow(
          Exception(),
        );
        when(() => mockAdminRepository.isAdminUser('')).thenAnswer(
          (_) async => true,
        );
      },
      act: (cubit) async {
        await cubit.listenToUserChanges();
        await cubit.authenticateWithGoogle();
      },
      expect: () => [
        AuthStatus.loading,
        AuthStatus.error,
      ],
    );

    blocTest<AuthCubit, AuthStatus>(
      'emits AuthStatus with unauthenticated status when suer is not admin',
      build: () => authCubit,
      setUp: () {
        when(() => mockAdminRepository.authenticateWithGoogle()).thenAnswer(
          (_) async => null,
        );
        when(() => mockAdminRepository.isAdminUser('')).thenAnswer(
          (_) async => false,
        );
      },
      act: (cubit) async {
        await cubit.listenToUserChanges();
        await cubit.authenticateWithGoogle();
      },
      expect: () => [
        AuthStatus.loading,
        AuthStatus.unauthenticated,
      ],
    );

    blocTest<AuthCubit, AuthStatus>(
      'emits AuthStatus with unauthenticated initial user is not admin',
      build: () => authCubit,
      setUp: () {
        when(() => mockAdminRepository.listenToAuthState()).thenAnswer(
          (_) => Stream.value(null),
        );
        when(() => mockAdminRepository.isAdminUser('')).thenAnswer(
          (_) async => false,
        );
      },
      act: (cubit) async {
        await cubit.listenToUserChanges();
      },
      expect: () => [
        AuthStatus.unauthenticated,
      ],
    );

    blocTest<AuthCubit, AuthStatus>(
      'emits AuthStatus with unauthenticated initial user is admin',
      build: () => authCubit,
      setUp: () {
        when(() => mockAdminRepository.listenToAuthState()).thenAnswer(
          (_) => Stream.value(null),
        );
        when(() => mockAdminRepository.isAdminUser('')).thenAnswer(
          (_) async => true,
        );
      },
      act: (cubit) async {
        await cubit.listenToUserChanges();
      },
      expect: () => [
        AuthStatus.authenticated,
      ],
    );
  });
}
