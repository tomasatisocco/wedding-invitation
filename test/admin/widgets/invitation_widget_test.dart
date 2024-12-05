import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/widgets/invitation_widget.dart';

import '../../helpers/helpers.dart';
import '../../mocks.dart';

void main() {
  late AdminRepository mockAdminRepository;
  late Invitation mockInvitation;

  setUpAll(() {
    registerFallbackValue(const Invitation(id: '1'));
    mockAdminRepository = MockAdminRepository();
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
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: Material(
            child: InvitationWidget(invitation: mockInvitation),
          ),
        ),
      );
      expect(find.text('Guest 1'), findsOneWidget);
      expect(find.text('Guest 2'), findsOneWidget);
    },
  );

  testWidgets(
    'InvitationWidget Add note correctly',
    (tester) async {
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: Material(
            child: InvitationWidget(invitation: mockInvitation),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Test note');

      await tester.pumpAndSettle();

      expect(find.text('Test note'), findsOneWidget);
    },
  );

  testWidgets(
    'InvitationWidget reset note correctly',
    (tester) async {
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: Material(
            child: InvitationWidget(invitation: mockInvitation),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Test note');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset').first);
      await tester.pumpAndSettle();

      expect(find.text('Test note'), findsNothing);
    },
  );

  testWidgets(
    'InvitationWidget Save note correctly',
    (tester) async {
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: Material(
            child: InvitationWidget(
              invitation: mockInvitation,
            ),
          ),
        ),
      );

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
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: Material(
            child: SingleChildScrollView(
              child: InvitationWidget(
                invitation: mockInvitation,
              ),
            ),
          ),
        ),
      );
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
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: Material(
            child: InvitationWidget(
              invitation: mockInvitation,
            ),
          ),
        ),
      );

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
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: Material(
            child: SingleChildScrollView(
              child: InvitationWidget(
                invitation: mockInvitation,
              ),
            ),
          ),
        ),
      );
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
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: Material(
            child: SingleChildScrollView(
              child: InvitationWidget(
                invitation: mockInvitation,
              ),
            ),
          ),
        ),
      );
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
