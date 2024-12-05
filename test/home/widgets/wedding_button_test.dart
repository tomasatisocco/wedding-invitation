import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';

import '../../helpers/pump_app.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

MockUrlLauncher _setupMockUrlLauncher() {
  final mock = MockUrlLauncher();
  registerFallbackValue(const LaunchOptions());

  when(() => mock.launchUrl(any(), any()))
      .thenAnswer((_) async => Future<bool>.value(true));
  when(
    () => mock.canLaunch(
      any(),
    ),
  ).thenAnswer((_) async => Future<bool>.value(true));
  return mock;
}

void main() {
  setUpAll(() {
    UrlLauncherPlatform.instance = _setupMockUrlLauncher();
  });

  testWidgets('WeddingButton renders correctly', (tester) async {
    await tester.pumpApp(
      WeddingButton(
        onPressed: () {},
        title: 'Test Button',
        url: 'https://example.com',
      ),
    );

    expect(find.byType(WeddingButton), findsOneWidget);
    expect(find.text('Test Button'), findsOneWidget);
  });

  testWidgets('WeddingButton calls onPressed when tapped', (tester) async {
    var wasPressed = false;
    await tester.pumpApp(
      WeddingButton(
        onPressed: () {
          wasPressed = true;
        },
        title: 'Test Button',
        url: '',
      ),
    );

    await tester.tap(find.byType(WeddingButton));
    expect(wasPressed, true);
  });

  testWidgets('WeddingButton opens url when tapped', (tester) async {
    final mockLauncher = _setupMockUrlLauncher();
    UrlLauncherPlatform.instance = mockLauncher;

    await tester.pumpApp(
      WeddingButton(
        title: 'Test Button',
        url: 'https://example.com',
      ),
    );

    await tester.tap(find.byType(WeddingButton));
    await tester.pumpAndSettle();
    verify(() => mockLauncher.canLaunch('https://example.com')).called(1);
    verify(() => mockLauncher.launchUrl('https://example.com', any()))
        .called(1);
  });
}
