import 'package:cloud_functions/cloud_functions.dart';

/// {@template unlock_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class UnlockRepository {
  /// {@macro unlock_repository}
  const UnlockRepository();

  /// Unlock page
  Future<bool> unlock(String password) async {
    try {
      final callable =
          FirebaseFunctions.instanceFor(region: 'southamerica-east1')
              .httpsCallable('validatePassword');
      // Call the Firebase Function to validate the password
      final response = await callable.call<Map<dynamic, dynamic>>(
        <String, dynamic>{
          'password': password,
        },
      );

      if (response.data['unlocked'] == true) return true;
      return false;
    } catch (e) {
      return false;
    }
  }
}
