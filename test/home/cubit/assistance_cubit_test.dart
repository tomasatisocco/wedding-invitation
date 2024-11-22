import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/home/cubit/assistance_cubit.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  group('AssistanceCubit', () {
    late MockHomeRepository mockHomeRepository;
    late Invitation mockInvitation;
    late Guest mockGuest;

    setUp(() {
      mockHomeRepository = MockHomeRepository();
      mockGuest = const Guest(id: '1', name: 'Guest 1');
      mockInvitation = Invitation(guests: [mockGuest]);
      when(() => mockHomeRepository.initFirebase()).thenAnswer((_) async {});
    });

    test('initial state is AssistanceState with unconfirmed status', () {
      final assistanceCubit = AssistanceCubit(
        homeRepository: MockHomeRepository(),
        originalInvitation: mockInvitation,
      );
      expect(
        assistanceCubit.state,
        AssistanceState(
          status: AssistanceStatus.unconfirmed,
          invitation: mockInvitation,
        ),
      );
      expect(assistanceCubit.confirmEnabled, false);
    });

    blocTest<AssistanceCubit, AssistanceState>(
      'Update invitation successfully',
      build: () => AssistanceCubit(
        originalInvitation: mockInvitation,
        homeRepository: mockHomeRepository,
      ),
      setUp: () {
        when(
          () => mockHomeRepository.updateInvitation(
            const Invitation(
              guests: [
                Guest(name: 'Guest 1', isAttending: true),
              ],
            ),
          ),
        ).thenAnswer(
          (_) async => true,
        );
      },
      act: (cubit) async {
        cubit.updateInvitation(
          const Guest(
            id: '1',
            name: 'Guest 1',
            isAttending: true,
          ),
        );

        await cubit.confirmInvitation();
      },
      expect: () => [
        const AssistanceState(
          status: AssistanceStatus.unconfirmed,
          invitation: Invitation(
            guests: [
              Guest(id: '1', name: 'Guest 1', isAttending: true),
            ],
          ),
        ),
        const AssistanceState(
          status: AssistanceStatus.confirming,
          invitation: Invitation(
            guests: [
              Guest(id: '1', name: 'Guest 1', isAttending: true),
            ],
          ),
        ),
        const AssistanceState(
          status: AssistanceStatus.confirmed,
          invitation: Invitation(
            guests: [
              Guest(id: '1', name: 'Guest 1', isAttending: true),
            ],
          ),
        ),
      ],
    );

    blocTest<AssistanceCubit, AssistanceState>(
      'Update invitation with error',
      build: () => AssistanceCubit(
        originalInvitation: mockInvitation,
        homeRepository: mockHomeRepository,
      ),
      setUp: () {
        when(
          () => mockHomeRepository.updateInvitation(
            const Invitation(
              guests: [
                Guest(name: 'Guest 1', isAttending: true),
              ],
            ),
          ),
        ).thenAnswer(
          (_) async => false,
        );
      },
      act: (cubit) async {
        cubit.updateInvitation(
          const Guest(
            id: '1',
            name: 'Guest 1',
            isAttending: true,
          ),
        );

        await cubit.confirmInvitation();
      },
      expect: () => [
        const AssistanceState(
          status: AssistanceStatus.unconfirmed,
          invitation: Invitation(
            guests: [
              Guest(id: '1', name: 'Guest 1', isAttending: true),
            ],
          ),
        ),
        const AssistanceState(
          status: AssistanceStatus.confirming,
          invitation: Invitation(
            guests: [
              Guest(id: '1', name: 'Guest 1', isAttending: true),
            ],
          ),
        ),
        const AssistanceState(
          status: AssistanceStatus.error,
          invitation: Invitation(
            guests: [
              Guest(id: '1', name: 'Guest 1', isAttending: true),
            ],
          ),
        ),
      ],
    );
  });
}
