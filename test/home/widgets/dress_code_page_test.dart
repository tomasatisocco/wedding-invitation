import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/widgets/dress_code_page.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DressCodePage', () {
    testWidgets('DressCodePage renders correctly', (tester) async {
      await tester.pumpApp(
        const SingleChildScrollView(
          child: DressCodePage(),
        ),
      );

      expect(find.text('DRESS CODE'), findsOneWidget);
    });

    testWidgets('DressCodePage renders first dress code image', (tester) async {
      await tester.pumpApp(
        const SingleChildScrollView(
          child: DressCodePage(),
        ),
      );

      expect(
        find.image(const AssetImage('assets/images/dress_code_1.png')),
        findsOneWidget,
      );
    });

    testWidgets('DressCodePage change dress information successfully',
        (tester) async {
      await tester.pumpApp(
        const SingleChildScrollView(
          child: DressCodePage(),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward_ios_rounded));
      await tester.pumpAndSettle();
      expect(
        find.image(const AssetImage('assets/images/dress_code_2.png')),
        findsOneWidget,
      );
    });

    testWidgets('DressCodePage change back dress information successfully',
        (tester) async {
      await tester.pumpApp(
        const SingleChildScrollView(
          child: DressCodePage(),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward_ios_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
      await tester.pumpAndSettle();
      expect(
        find.image(const AssetImage('assets/images/dress_code_1.png')),
        findsOneWidget,
      );
    });
  });
}
