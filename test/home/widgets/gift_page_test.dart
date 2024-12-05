import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/widgets/gift_page.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('GiftPage renders correctly', (tester) async {
    await tester.pumpApp(
      const SingleChildScrollView(
        child: GiftPage(),
      ),
    );

    expect(
      find.text('Bank Information'),
      findsOneWidget,
    );
  });

  testWidgets('GiftPage opens bank information', (tester) async {
    await tester.pumpApp(
      const SingleChildScrollView(
        child: GiftPage(),
      ),
    );

    await tester.tap(find.text('Bank Information'));
    await tester.pumpAndSettle();

    expect(find.text('0000003100052554102251'), findsOneWidget);
  });
}
