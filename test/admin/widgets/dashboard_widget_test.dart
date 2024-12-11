import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';
import 'package:wedding_invitation/admin/widgets/dashboard_widget.dart';

import '../../mocks.dart';

void main() {
  late AdminCubit mockAdminCubit;
  late List<Guest> mockGuests;

  setUp(() {
    mockAdminCubit = MockAdminCubit();
    mockGuests = List.generate(
      3,
      (index) => Guest(
        id: index.toString(),
        name: 'Guest $index',
        isAttending: index.isEven,
      ),
    );

    when(() => mockAdminCubit.state).thenReturn(
      AdminState(
        status: AdminStatus.loaded,
        invitations: [
          Invitation(
            guests: mockGuests,
          ),
        ],
      ),
    );
  });

  Widget buildWidget() {
    return BlocProvider(
      create: (context) => mockAdminCubit,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return const DashboardWidget();
            },
          ),
        ),
      ),
    );
  }

  testWidgets('DashboardWidget renders TotalInvitations', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.byType(TotalInvitations), findsOneWidget);
  });

  testWidgets('TotalInvitations displays correct indicators', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Guests'), findsOneWidget);
    expect(find.text('Invites'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
    expect(find.text('Missing'), findsOneWidget);

    expect(find.text('3'), findsOneWidget); // Total guests
    expect(find.text('1'), findsNWidgets(2)); // Confirmed guests
  });

  testWidgets('Indicator onTap opens guest dialog when guests are available',
      (tester) async {
    await tester.pumpWidget(buildWidget());

    // Find and tap the "Guests" Indicator
    final guestsIndicator = find.widgetWithText(Indicator, 'Guests');
    expect(guestsIndicator, findsOneWidget);
    await tester.tap(guestsIndicator);
    await tester.pumpAndSettle();

    // Verify the dialog appears
    expect(find.byType(AlertDialog), findsOneWidget);

    // Verify guest names in the dialog
    for (final guest in mockGuests) {
      expect(find.text(guest.name ?? ''), findsOneWidget);
    }
  });

  testWidgets('GuestWidget calls onSelect and closes dialog on tap',
      (tester) async {
    var wasSelected = false;

    final widget = MaterialApp(
      home: Scaffold(
        body: GuestWidget(
          guest: mockGuests.first,
          onSelect: (guest) {
            wasSelected = true;
          },
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // Tap the GuestWidget
    await tester.tap(find.byType(GuestWidget));
    await tester.pumpAndSettle();

    // Verify onSelect was called
    expect(wasSelected, isTrue);
  });
}
