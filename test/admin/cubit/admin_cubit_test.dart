import 'package:admin_repository/admin_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';
import '../../mocks.dart';

void main() {
  group('AdminCubit', () {
    late AdminCubit adminCubit;
    late MockAdminRepository mockAdminRepository;
    late Invitation mockInvitation1;
    late Invitation mockInvitation2;

    setUp(() {
      mockAdminRepository = MockAdminRepository();
      adminCubit = AdminCubit(
        adminRepository: mockAdminRepository,
        testing: true,
      );

      mockInvitation1 = const Invitation(id: '1');
      mockInvitation2 = const Invitation(id: '2');
    });

    test('initial state is AdminState with loading status', () {
      expect(adminCubit.state, const AdminState());
    });

    blocTest<AdminCubit, AdminState>(
      'Automatic loading of data',
      build: () => AdminCubit(adminRepository: mockAdminRepository),
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenAnswer(
          (_) async => [],
        );
      },
      expect: () => [
        const AdminState(status: AdminStatus.loaded),
      ],
    );

    blocTest<AdminCubit, AdminState>(
      'emits AdminState with loaded status when data is loaded',
      build: () => adminCubit,
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenAnswer(
          (_) async => [],
        );
      },
      act: (cubit) => cubit.getInvitations(),
      expect: () => [
        const AdminState(),
        const AdminState(status: AdminStatus.loaded),
      ],
    );

    blocTest<AdminCubit, AdminState>(
      'emits AdminState with error status when data loading fails',
      build: () => adminCubit,
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenThrow(Exception());
      },
      act: (cubit) => cubit.getInvitations(),
      expect: () => [
        const AdminState(),
        const AdminState(status: AdminStatus.error),
      ],
    );

    blocTest<AdminCubit, AdminState>(
      'emits AdminState in searching',
      build: () => adminCubit,
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenAnswer(
          (_) async => [mockInvitation1, mockInvitation2],
        );
      },
      act: (cubit) async {
        await cubit.getInvitations();
        cubit.search('1');
      },
      expect: () => [
        const AdminState(),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1, mockInvitation2],
        ),
        AdminState(status: AdminStatus.loaded, invitations: [mockInvitation1]),
      ],
    );

    blocTest<AdminCubit, AdminState>(
      'emits AdminState in selecting',
      build: () => adminCubit,
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenAnswer(
          (_) async => [mockInvitation1, mockInvitation2],
        );
      },
      act: (cubit) async {
        await cubit.getInvitations();
        cubit.selectInvitation(mockInvitation1);
      },
      expect: () => [
        const AdminState(),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1, mockInvitation2],
        ),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1, mockInvitation2],
          selectedInvitation: mockInvitation1,
        ),
      ],
    );

    blocTest<AdminCubit, AdminState>(
      'emits AdminState in adding',
      build: () => adminCubit,
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenAnswer(
          (_) async => [mockInvitation1],
        );
        when(() => mockAdminRepository.addInvitation(mockInvitation2))
            .thenAnswer(
          (_) async => true,
        );
      },
      act: (cubit) async {
        await cubit.getInvitations();
        await cubit.addInvitation(mockInvitation2);
      },
      expect: () => [
        const AdminState(),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1],
        ),
        const AdminState(),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1],
          selectedInvitation: mockInvitation2,
        ),
      ],
    );

    blocTest<AdminCubit, AdminState>(
      'emits AdminState in update invitation',
      build: () => adminCubit,
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenAnswer(
          (_) async => [mockInvitation1],
        );
      },
      act: (cubit) async {
        await cubit.getInvitations();
        cubit.updateInvitation(mockInvitation1.copyWith(note: 'TestNote'));
      },
      expect: () => [
        const AdminState(),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1],
        ),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1.copyWith(note: 'TestNote')],
        ),
      ],
    );

    blocTest<AdminCubit, AdminState>(
      'emits AdminState in select home',
      build: () => adminCubit,
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenAnswer(
          (_) async => [mockInvitation1],
        );
      },
      act: (cubit) async {
        await cubit.getInvitations();
        cubit
          ..selectInvitation(mockInvitation1)
          ..selectHome();
      },
      expect: () => [
        const AdminState(),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1],
        ),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1],
          selectedInvitation: mockInvitation1,
        ),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [mockInvitation1],
        ),
      ],
    );

    blocTest<AdminCubit, AdminState>(
      'emits AdminState in select by guest',
      build: () => adminCubit,
      setUp: () {
        when(() => mockAdminRepository.getInvitations()).thenAnswer(
          (_) async => [
            mockInvitation1.copyWith(guests: [const Guest(id: '1')]),
          ],
        );
      },
      act: (cubit) async {
        await cubit.getInvitations();
        cubit.selectByGuest(const Guest(id: '1'));
      },
      expect: () => [
        const AdminState(),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [
            mockInvitation1.copyWith(guests: [const Guest(id: '1')]),
          ],
        ),
        AdminState(
          status: AdminStatus.loaded,
          invitations: [
            mockInvitation1.copyWith(guests: [const Guest(id: '1')]),
          ],
          selectedInvitation:
              mockInvitation1.copyWith(guests: [const Guest(id: '1')]),
        ),
      ],
    );
  });
}
