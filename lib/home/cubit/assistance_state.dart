part of 'assistance_cubit.dart';

enum AssistanceStatus {
  confirmed,
  confirming,
  unconfirmed,
  error;
}

class AssistanceState extends Equatable {
  const AssistanceState({
    required this.status,
    required this.invitation,
  });

  final AssistanceStatus status;
  final Invitation invitation;

  bool get isConfirmed => status == AssistanceStatus.confirmed;
  bool get isLoading => status == AssistanceStatus.confirming;
  bool get isError => status == AssistanceStatus.error;

  @override
  List<Object?> get props => [
        status,
        invitation,
      ];
}
