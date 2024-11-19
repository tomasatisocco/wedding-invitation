import 'package:admin_repository/admin_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/cubit/invitation_cubit.dart';

import '../../mocks.dart';

void main() {
  group('InvitationCubit', () {
    late InvitationCubit invitationCubit;
    late MockAdminRepository mockAdminRepository;
    late Invitation mockInvitation;

    setUp(() {
      mockAdminRepository = MockAdminRepository();
      mockInvitation = const Invitation(
        id: '1',
        guests: [
          Guest(id: '1', name: 'Guest 1'),
          Guest(id: '2', name: 'Guest 2'),
        ],
      );
      invitationCubit = InvitationCubit(
        adminRepository: mockAdminRepository,
        invitation: mockInvitation,
      );
    });

    test('initial state is InvitationState with loading status', () {
      expect(
        invitationCubit.state,
        InvitationState(
          actualInvitation: mockInvitation,
          originalInvitation: mockInvitation,
        ),
      );
    });

    blocTest<InvitationCubit, InvitationState>(
      'Update invitation',
      build: () => invitationCubit,
      act: (cubit) => cubit.updateInvitation(
        mockInvitation.copyWith(
          id: '2',
        ),
      ),
      expect: () => [
        InvitationState(
          actualInvitation: mockInvitation.copyWith(
            id: '2',
          ),
          originalInvitation: mockInvitation,
        ),
      ],
    );

    blocTest<InvitationCubit, InvitationState>(
      'Update guest',
      build: () => invitationCubit,
      act: (cubit) => cubit.updateGuest(
        const Guest(id: '2', name: 'Guest 2 Updated'),
      ),
      expect: () => [
        InvitationState(
          actualInvitation: mockInvitation.copyWith(
            guests: [
              const Guest(id: '1', name: 'Guest 1'),
              const Guest(id: '2', name: 'Guest 2 Updated'),
            ],
          ),
          originalInvitation: mockInvitation,
        ),
      ],
    );

    blocTest<InvitationCubit, InvitationState>(
      'Delete guest',
      build: () => invitationCubit,
      act: (cubit) => cubit.deleteGuest(
        const Guest(id: '2', name: 'Guest 2 Updated'),
      ),
      expect: () => [
        InvitationState(
          actualInvitation: mockInvitation.copyWith(
            guests: [
              const Guest(id: '1', name: 'Guest 1'),
            ],
          ),
          originalInvitation: mockInvitation,
        ),
      ],
    );

    blocTest<InvitationCubit, InvitationState>(
      'Add guest',
      build: () => invitationCubit,
      act: (cubit) => cubit.addGuest(
        const Guest(id: '3', name: 'Guest 3'),
      ),
      expect: () => [
        InvitationState(
          actualInvitation: mockInvitation.copyWith(
            guests: [
              const Guest(id: '1', name: 'Guest 1'),
              const Guest(id: '2', name: 'Guest 2'),
              const Guest(id: '3', name: 'Guest 3'),
            ],
          ),
          originalInvitation: mockInvitation,
        ),
      ],
    );

    blocTest<InvitationCubit, InvitationState>(
      'Save invitation successfully',
      build: () => invitationCubit,
      setUp: () {
        when(
          () => mockAdminRepository.updateInvitation(mockInvitation),
        ).thenAnswer((_) async => true);
      },
      act: (cubit) => cubit.saveInvitation(),
      expect: () => [
        InvitationState(
          status: InvitationStatus.loading,
          actualInvitation: mockInvitation,
          originalInvitation: mockInvitation,
        ),
        InvitationState(
          actualInvitation: mockInvitation,
          originalInvitation: mockInvitation,
        ),
      ],
    );

    blocTest<InvitationCubit, InvitationState>(
      'Save invitation unsuccessfully',
      build: () => invitationCubit,
      setUp: () {
        when(
          () => mockAdminRepository.updateInvitation(mockInvitation),
        ).thenAnswer((_) async => false);
      },
      act: (cubit) => cubit.saveInvitation(),
      expect: () => [
        InvitationState(
          status: InvitationStatus.loading,
          actualInvitation: mockInvitation,
          originalInvitation: mockInvitation,
        ),
      ],
    );

    blocTest<InvitationCubit, InvitationState>(
      'Save invitation with failure',
      build: () => invitationCubit,
      setUp: () {
        when(
          () => mockAdminRepository.updateInvitation(mockInvitation),
        ).thenThrow(Exception());
      },
      act: (cubit) => cubit.saveInvitation(),
      expect: () => [
        InvitationState(
          status: InvitationStatus.loading,
          actualInvitation: mockInvitation,
          originalInvitation: mockInvitation,
        ),
        InvitationState(
          status: InvitationStatus.error,
          actualInvitation: mockInvitation,
          originalInvitation: mockInvitation,
        ),
      ],
    );
  });
}
