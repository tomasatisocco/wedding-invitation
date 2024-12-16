import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_repository/home_repository.dart';
import 'package:unlock_repository/unlock_repository.dart';
import 'package:wedding_invitation/admin/view/admin_page.dart';
import 'package:wedding_invitation/home/view/home_page.dart';
import 'package:wedding_invitation/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final uri = Uri.base;
    final id = uri.pathSegments.isEmpty ? null : uri.pathSegments[0];
    final isAdmin = id == 'admin';
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        useMaterial3: true,
        textTheme: GoogleFonts.loraTextTheme(textTheme),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => const HomeRepository()),
          RepositoryProvider(create: (context) => const UnlockRepository()),
          RepositoryProvider(create: (context) => const AdminRepository()),
        ],
        child: isAdmin ? const AdminPage() : HomePage(id: id),
      ),
    );
  }
}
