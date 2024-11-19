import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/widgets/gifht_page.dart';

void main() {
  testWidgets('GiftPage renders correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SingleChildScrollView(
          child: GiftPage(),
        ),
      ),
    );

    expect(
      find.text('Cuenta Bancaria'),
      findsOneWidget,
    );
  });

  testWidgets('GiftPage opens bank information', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SingleChildScrollView(
          child: GiftPage(),
        ),
      ),
    );

    await tester.tap(find.text('Cuenta Bancaria'));
    await tester.pumpAndSettle();

    expect(find.text('0000003100052554102251'), findsOneWidget);
  });
}
