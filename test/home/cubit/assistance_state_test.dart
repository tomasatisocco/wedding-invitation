import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';
import 'package:wedding_invitation/home/cubit/assistance_cubit.dart';

void main() {
  group('AssistanceState', () {
    test('supports value equality', () {
      const state1 = AssistanceState(
        status: AssistanceStatus.confirming,
        invitation: Invitation(),
      );
      const state2 = AssistanceState(
        status: AssistanceStatus.confirming,
        invitation: Invitation(),
      );
      expect(state1, state2);
    });

    test('supports property equality', () {
      const state1 = AssistanceState(
        status: AssistanceStatus.confirming,
        invitation: Invitation(),
      );
      const state2 = AssistanceState(
        status: AssistanceStatus.confirming,
        invitation: Invitation(),
      );
      expect(state1.props, state2.props);
    });

    test('isConfirming returns true when status is confirming', () {
      const state = AssistanceState(
        status: AssistanceStatus.confirming,
        invitation: Invitation(),
      );
      expect(state.isLoading, true);
    });

    test('isLoaded returns true when status is confirmed', () {
      const state = AssistanceState(
        status: AssistanceStatus.confirmed,
        invitation: Invitation(),
      );
      expect(state.isConfirmed, true);
    });

    test('isError returns true when status is error', () {
      const state = AssistanceState(
        status: AssistanceStatus.error,
        invitation: Invitation(),
      );
      expect(state.isError, true);
    });
  });
}
