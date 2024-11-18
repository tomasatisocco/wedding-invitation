import 'dart:async';

import 'package:admin_repository/admin_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit({
    required AdminRepository adminRepository,
    bool testing = false,
  })  : _adminRepository = adminRepository,
        super(AuthStatus.unauthenticated) {
    if (!testing) initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await _adminRepository.initFirebase();
    await listenToUserChanges();
  }

  Future<void> listenToUserChanges() async {
    _authSubscription =
        _adminRepository.listenToAuthState().listen((user) async {
      final isAdmin = await _adminRepository.isAdminUser(user?.uid ?? '');
      if (!isAdmin) return emit(AuthStatus.unauthenticated);
      emit(AuthStatus.authenticated);
    });
  }

  Future<void> authenticateWithGoogle() async {
    try {
      emit(AuthStatus.loading);
      final user = await _adminRepository.authenticateWithGoogle();
      final isAdmin = await _adminRepository.isAdminUser(user?.user?.uid ?? '');
      if (!isAdmin) return emit(AuthStatus.unauthenticated);
      emit(AuthStatus.authenticated);
    } catch (e) {
      emit(AuthStatus.error);
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  final AdminRepository _adminRepository;
  late StreamSubscription<User?> _authSubscription;
}
