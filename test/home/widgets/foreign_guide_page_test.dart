import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/widgets/foreign_guide_page.dart';

void main() {
  testWidgets('ForeignGuidePage renders correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SingleChildScrollView(
          child: ForeignGuidePage(),
        ),
      ),
    );

    expect(
      find.text('Guía para los amigos que vienen de lejos'),
      findsOneWidget,
    );
  });

  testWidgets('ForeignGuidePage renders first info code image', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SingleChildScrollView(
          child: ForeignGuidePage(),
        ),
      ),
    );

    expect(find.text('Hathor Hotel'), findsOneWidget);
  });

  testWidgets('DressCodePage change dress information successfully',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SingleChildScrollView(
          child: ForeignGuidePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_forward_ios_rounded));
    await tester.pumpAndSettle();
    expect(find.text('La orilla'), findsOneWidget);
  });

  testWidgets('DressCodePage change back dress information successfully',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SingleChildScrollView(
          child: ForeignGuidePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_forward_ios_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Hathor Hotel'), findsOneWidget);
  });
}
