part of 'auth_cubit.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
  error;

  bool get isAuthenticated => this == authenticated;
  bool get isUnauthenticated => this == unauthenticated;
  bool get isLoading => this == loading;
  bool get isError => this == error;
}
