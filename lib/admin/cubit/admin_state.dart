part of 'admin_cubit.dart';

enum AdminStatus {
  loading,
  loaded,
  error,
}

class AdminState extends Equatable {
  const AdminState({
    this.status = AdminStatus.loading,
    this.invitations = const [],
    this.selectedInvitation,
  });

  bool get isLoading => status == AdminStatus.loading;
  bool get isLoaded => status == AdminStatus.loaded;
  bool get isError => status == AdminStatus.error;

  final AdminStatus status;
  final List<Invitation>? invitations;
  final Invitation? selectedInvitation;

  @override
  List<Object?> get props => [
        status,
        invitations,
        selectedInvitation,
      ];
}
