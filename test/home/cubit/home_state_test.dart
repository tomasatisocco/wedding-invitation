import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';

void main() {
  group('HomeState', () {
    test('supports value equality', () {
      expect(
        const HomeState(),
        const HomeState(),
      );
    });

    test('supports property equality', () {
      expect(
        const HomeState().props,
        const HomeState().props,
      );
    });

    test('isLoading returns true when status is loading', () {
      expect(
        const HomeState().isLoading,
        true,
      );
    });

    test('isLoaded returns true when status is loaded', () {
      expect(
        const HomeState(status: HomeStatus.loaded).isLoaded,
        true,
      );
    });

    test('isError returns true when status is error', () {
      expect(
        const HomeState(status: HomeStatus.error).isError,
        true,
      );
    });
  });
}
