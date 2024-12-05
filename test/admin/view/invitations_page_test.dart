import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';
import 'package:wedding_invitation/admin/cubit/auth_cubit.dart';
import 'package:wedding_invitation/admin/view/invitations_page.dart';

import '../../helpers/helpers.dart';
import '../../mocks.dart';

void main() {
  late AdminRepository mockAdminRepository;

  setUpAll(() {
    mockAdminRepository = MockAdminRepository();

    when(() => mockAdminRepository.initFirebase()).thenAnswer((_) async {});
    when(() => mockAdminRepository.listenToAuthState()).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => mockAdminRepository.authenticateWithGoogle()).thenAnswer(
      (_) async => null,
    );
    when(() => mockAdminRepository.isAdminUser('')).thenAnswer(
      (_) async => true,
    );
    when(() => mockAdminRepository.addInvitation(const Invitation(id: '1')))
        .thenAnswer(
      (_) async => true,
    );
  });

  testWidgets('Invitations renders correctly', (tester) async {
    when(() => mockAdminRepository.getInvitations()).thenAnswer(
      (_) async => [
        const Invitation(id: '1'),
      ],
    );
    final adminCubit = AdminCubit(adminRepository: mockAdminRepository);
    final authCubit = AuthCubit(adminRepository: mockAdminRepository);

    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: adminCubit),
          BlocProvider.value(value: authCubit),
        ],
        child: RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: const InvitationsPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Invitations shows error correctly', (tester) async {
    when(() => mockAdminRepository.getInvitations()).thenThrow(Exception);
    final adminCubit = AdminCubit(adminRepository: mockAdminRepository);
    final authCubit = AuthCubit(adminRepository: mockAdminRepository);

    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: adminCubit),
          BlocProvider.value(value: authCubit),
        ],
        child: RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: const InvitationsPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Add invitation', (tester) async {
    when(() => mockAdminRepository.getInvitations()).thenAnswer(
      (_) async => [
        const Invitation(id: '1'),
      ],
    );
    final adminCubit = AdminCubit(adminRepository: mockAdminRepository);
    final authCubit = AuthCubit(adminRepository: mockAdminRepository);

    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: adminCubit),
          BlocProvider.value(value: authCubit),
        ],
        child: RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: const InvitationsPage(),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    // find and write in a text field
    await tester.enterText(
      find.byType(TextField),
      '1',
    );
    await tester.pumpAndSettle();
    expect(find.text('Add'), findsOneWidget);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Notes'), findsOneWidget);
  });

  testWidgets('Select invitation', (tester) async {
    when(() => mockAdminRepository.getInvitations()).thenAnswer(
      (_) async => [
        const Invitation(id: '1'),
      ],
    );
    final adminCubit = AdminCubit(adminRepository: mockAdminRepository);
    final authCubit = AuthCubit(adminRepository: mockAdminRepository);

    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: adminCubit),
          BlocProvider.value(value: authCubit),
        ],
        child: RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: const InvitationsPage(),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
    expect(find.text('Notes'), findsOneWidget);
  });
}
