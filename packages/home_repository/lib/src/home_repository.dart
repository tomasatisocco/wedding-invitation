import 'package:firebase_core/firebase_core.dart';
import 'package:home_repository/src/firebase_options.dart';

/// {@template home_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class HomeRepository {
  /// {@macro home_repository}
  const HomeRepository();

  /// Initialize Firebase
  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
