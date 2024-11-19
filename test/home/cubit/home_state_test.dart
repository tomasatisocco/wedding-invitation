import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';
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

    test('Names are correct', () {
      expect(
        const HomeState(
          invitation: Invitation(
            id: '1',
            guests: [
              Guest(id: '1', name: 'Guest 1'),
              Guest(id: '2', name: 'Guest 2'),
            ],
          ),
        ).invitationNames,
        'Guest 1 & Guest 2',
      );
    });
  });
}
