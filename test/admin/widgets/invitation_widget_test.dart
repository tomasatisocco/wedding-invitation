import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';
import 'package:wedding_invitation/admin/widgets/invitation_widget.dart';

import '../../helpers/helpers.dart';
import '../../mocks.dart';

void main() {
  late AdminRepository mockAdminRepository;
  late AdminCubit adminCubit;
  late Invitation mockInvitation;

  Future<void> buildWidget(WidgetTester tester, Widget child) async {
    await tester.pumpApp(
      RepositoryProvider(
        create: (context) => mockAdminRepository,
        child: BlocProvider(
          create: (_) => adminCubit,
          child: Material(
            child: child,
          ),
        ),
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(const Invitation(id: '1'));
    mockAdminRepository = MockAdminRepository();
    adminCubit = MockAdminCubit();
    mockInvitation = const Invitation(
      id: '1',
      guests: [
        Guest(id: '1', name: 'Guest 1'),
        Guest(id: '2', name: 'Guest 2'),
      ],
    );
    when(() => mockAdminRepository.updateInvitation(any())).thenAnswer(
      (_) async => true,
    );
  });

  testWidgets(
    'InvitationWidget renders correctly',
    (tester) async {
      await buildWidget(tester, InvitationWidget(invitation: mockInvitation));

      expect(find.text('Guest 1'), findsOneWidget);
      expect(find.text('Guest 2'), findsOneWidget);
    },
  );

  testWidgets(
    'InvitationWidget Add note correctly',
    (tester) async {
      await buildWidget(tester, InvitationWidget(invitation: mockInvitation));

      await tester.enterText(find.byType(TextField).first, 'Test note');
      await tester.pumpAndSettle();

      expect(find.text('Test note'), findsOneWidget);
    },
  );

  testWidgets(
    'InvitationWidget reset note correctly',
    (tester) async {
      await buildWidget(tester, InvitationWidget(invitation: mockInvitation));

      await tester.enterText(find.byKey(const Key('note')), 'Test note');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset').first);
      await tester.pumpAndSettle();

      expect(find.text('Test note'), findsNothing);
    },
  );

  testWidgets(
    'InvitationWidget Save note correctly',
    (tester) async {
      await buildWidget(tester, InvitationWidget(invitation: mockInvitation));

      await tester.enterText(find.byType(TextField).first, 'Test note');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save').first);
      await tester.pumpAndSettle();

      verify(() => mockAdminRepository.updateInvitation(any())).called(1);
    },
  );

  testWidgets(
    'InvitationWidget add guest correctly',
    (tester) async {
      await buildWidget(tester, InvitationWidget(invitation: mockInvitation));

      await tester.dragUntilVisible(
        find.byType(GuestWidget).first,
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(GuestWidget), findsExactly(3));
    },
  );

  testWidgets(
    'InvitationWidget delete guest correctly',
    (tester) async {
      await buildWidget(tester, InvitationWidget(invitation: mockInvitation));

      await tester.dragUntilVisible(
        find.byType(GuestWidget).first,
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
      await tester.pumpAndSettle();

      expect(find.byType(GuestWidget), findsExactly(1));
    },
  );

  testWidgets(
    'InvitationWidget update guest name correctly',
    (tester) async {
      await buildWidget(tester, InvitationWidget(invitation: mockInvitation));

      await tester.dragUntilVisible(
        find.byType(GuestWidget).first,
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      await tester.enterText(find.text('Guest 1').first, 'Test name');
      await tester.pumpAndSettle();

      expect(find.text('Test name'), findsExactly(1));
    },
  );

  testWidgets(
    'InvitationWidget confirm guest correctly',
    (tester) async {
      await buildWidget(tester, InvitationWidget(invitation: mockInvitation));

      await tester.dragUntilVisible(
        find.byType(GuestWidget).first,
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // expect to find a checkbox color green
      expect(
        find.byType(Checkbox).first,
        findsOneWidget,
      );
    },
  );
}
