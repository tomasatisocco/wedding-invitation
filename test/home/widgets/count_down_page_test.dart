import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_invitation/home/widgets/count_down_page.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CountDownPage', () {
    testWidgets('Finds count down', (tester) async {
      await tester.pumpApp(
        const CountDownPage(),
      );

      final targetDate = DateTime(2025, 03, 15, 19);
      var remainingTime = targetDate.difference(DateTime.now());
      var days = remainingTime.inDays;
      var hours = remainingTime.inHours % 24;
      var minutes = remainingTime.inMinutes % 60;
      var seconds = remainingTime.inSeconds % 60;

      expect(find.text('TOMI & EMI'), findsOneWidget);
      expect(find.text(days.toString()), findsOneWidget);
      expect(find.text(hours.toString()), findsOneWidget);
      expect(find.text(minutes.toString()), findsOneWidget);
      expect(find.text(seconds.toString()), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      remainingTime = targetDate.difference(DateTime.now());

      days = remainingTime.inDays;
      hours = remainingTime.inHours % 24;
      minutes = remainingTime.inMinutes % 60;
      seconds = remainingTime.inSeconds % 60;
      expect(find.text(days.toString()), findsOneWidget);
      expect(find.text(hours.toString()), findsOneWidget);
      expect(find.text(minutes.toString()), findsOneWidget);
      expect(find.text(seconds.toString()), findsOneWidget);
    });
  });
}
