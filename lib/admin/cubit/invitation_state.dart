part of 'invitation_cubit.dart';

enum InvitationStatus {
  loading,
  loaded,
  error,
}

class InvitationState extends Equatable {
  const InvitationState({
    required this.actualInvitation,
    required this.originalInvitation,
    this.status = InvitationStatus.loaded,
  });

  bool get isLoading => status == InvitationStatus.loading;
  bool get isError => status == InvitationStatus.error;
  bool get isLoaded => status == InvitationStatus.loaded;

  bool get isUpToDate => actualInvitation == originalInvitation;

  final InvitationStatus status;
  final Invitation actualInvitation;
  final Invitation originalInvitation;

  @override
  List<Object?> get props => [
        status,
        actualInvitation,
        originalInvitation,
      ];
}
