import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:home_repository/src/firebase_options.dart';
import 'package:home_repository/src/invitation_model.dart';

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

  /// Get an invitation
  Future<Invitation?> getInvitation(String? id) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('invitations')
          .doc(id)
          .get();

      if (!doc.exists) return null;
      return Invitation.fromMap(doc.data()!);
    } catch (_) {
      return null;
    }
  }

  /// Update an invitation
  Future<bool> updateInvitation(Invitation invitation) async {
    try {
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(invitation.id)
          .update(invitation.toMap());
      return true;
    } catch (_) {
      return false;
    }
  }
}
