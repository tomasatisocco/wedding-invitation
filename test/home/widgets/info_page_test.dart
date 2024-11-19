import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/widgets/info_page.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';

void main() {
  testWidgets('Finds asset image', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: InfoPage(),
      ),
    );
    expect(
      find.image(const AssetImage('assets/images/wedding_rings.png')),
      findsOneWidget,
    );
  });

  testWidgets('Finds wedding buttons', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: InfoPage(),
      ),
    );

    expect(find.byType(WeddingButton), findsNWidgets(2));
  });
}
