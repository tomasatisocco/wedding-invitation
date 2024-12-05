import 'package:admin_repository/admin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/view/admin_page.dart';

import '../../helpers/helpers.dart';
import '../../mocks.dart';

void main() {
  late AdminRepository mockAdminRepository;

  setUpAll(() {
    mockAdminRepository = MockAdminRepository();

    when(() => mockAdminRepository.initFirebase()).thenAnswer((_) async {});
    when(() => mockAdminRepository.listenToAuthState()).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => mockAdminRepository.authenticateWithGoogle()).thenAnswer(
      (_) async => null,
    );
    when(() => mockAdminRepository.isAdminUser('')).thenAnswer(
      (_) async => true,
    );
  });

  group('AdminPage', () {
    testWidgets('AdminPage renders correctly', (tester) async {
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: RepositoryProvider(
            create: (context) => mockAdminRepository,
            child: const AdminPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('AdminPage logins successfully', (tester) async {
      await tester.pumpApp(
        RepositoryProvider(
          create: (context) => mockAdminRepository,
          child: RepositoryProvider(
            create: (context) => mockAdminRepository,
            child: const AdminPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
    });
  });
}
