import 'package:admin_repository/admin_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/admin/cubit/invitation_cubit.dart';

void main() {
  group('InvitationState', () {
    test('supports value equality', () {
      expect(
        const InvitationState(
          status: InvitationStatus.loading,
          actualInvitation: Invitation(),
          originalInvitation: Invitation(),
        ),
        const InvitationState(
          status: InvitationStatus.loading,
          actualInvitation: Invitation(),
          originalInvitation: Invitation(),
        ),
      );
    });

    test('supports property equality', () {
      expect(
        const InvitationState(
          status: InvitationStatus.loading,
          actualInvitation: Invitation(),
          originalInvitation: Invitation(),
        ).props,
        const InvitationState(
          status: InvitationStatus.loading,
          actualInvitation: Invitation(),
          originalInvitation: Invitation(),
        ).props,
      );
    });

    test('isLoading returns true when status is loading', () {
      expect(
        const InvitationState(
          status: InvitationStatus.loading,
          actualInvitation: Invitation(),
          originalInvitation: Invitation(),
        ).isLoading,
        true,
      );
    });

    test('isLoaded returns true when status is loaded', () {
      expect(
        const InvitationState(
          actualInvitation: Invitation(),
          originalInvitation: Invitation(),
        ).isLoaded,
        true,
      );
    });

    test('isError returns true when status is error', () {
      expect(
        const InvitationState(
          status: InvitationStatus.error,
          actualInvitation: Invitation(),
          originalInvitation: Invitation(),
        ).isError,
        true,
      );
    });

    test('both invitation are the same', () {
      expect(
        const InvitationState(
          status: InvitationStatus.error,
          actualInvitation: Invitation(),
          originalInvitation: Invitation(),
        ).isUpToDate,
        true,
      );
    });
  });
}
