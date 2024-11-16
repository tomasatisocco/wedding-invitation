import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_repository/home_repository.dart';
import 'package:unlock_repository/unlock_repository.dart';
import 'package:wedding_invitation/home/view/home_page.dart';
import 'package:wedding_invitation/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.prataTextTheme(textTheme),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => const HomeRepository()),
          RepositoryProvider(create: (context) => const UnlockRepository()),
        ],
        child: const HomePage(),
      ),
    );
  }
}
