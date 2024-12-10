import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/widgets/info_page.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('Finds asset image', (tester) async {
    await tester.pumpApp(const InfoPage());

    expect(
      find.image(const AssetImage('assets/images/tree.png')),
      findsOneWidget,
    );
  });

  testWidgets('Finds wedding buttons', (tester) async {
    await tester.pumpApp(const InfoPage());

    expect(find.byType(WeddingButton), findsNWidgets(2));
  });
}
