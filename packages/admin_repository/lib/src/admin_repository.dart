import 'package:admin_repository/src/firebase_options.dart';
import 'package:admin_repository/src/invitation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// {@template admin_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class AdminRepository {
  /// {@macro admin_repository}
  const AdminRepository();

  /// Initialize Firebase
  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Listen to auth state
  Stream<User?> listenToAuthState() => FirebaseAuth.instance.authStateChanges();

  /// Authenticate with Google
  Future<UserCredential?> authenticateWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider()
        ..addScope('email')
        ..addScope('profile');

      final googleUser = await FirebaseAuth.instanceFor(app: Firebase.app())
          .signInWithPopup(googleProvider);
      return googleUser;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is an admin
  Future<bool> isAdminUser(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('admins').doc(uid).get();
      if (!doc.exists) {
        await signOut();
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Get invitations
  Future<List<Invitation>> getInvitations() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('invitations').get();
    return snapshot.docs.map((e) => Invitation.fromMap(e.data())).toList();
  }

  /// Add an invitation
  Future<bool> addInvitation(Invitation invitation) async {
    try {
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(invitation.id)
          .set(invitation.toMap());
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Delete an invitation
  Future<bool> deleteInvitation(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(id)
          .delete();
      return true;
    } catch (_) {
      return false;
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
