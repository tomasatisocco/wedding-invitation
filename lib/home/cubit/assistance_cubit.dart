import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_repository/home_repository.dart';

part 'assistance_state.dart';

class AssistanceCubit extends Cubit<AssistanceState> {
  AssistanceCubit({
    required Invitation originalInvitation,
    required HomeRepository homeRepository,
  })  : _originalInvitation = originalInvitation,
        _homeRepository = homeRepository,
        super(
          AssistanceState(
            invitation: originalInvitation,
            status: originalInvitation.confirmed
                ? AssistanceStatus.confirmed
                : AssistanceStatus.unconfirmed,
          ),
        );

  void updateInvitation(Guest? guest) {
    final newInvitation = state.invitation.copyWith(
      guests: state.invitation.guests
          ?.map((e) => e.name == guest!.name ? guest : e)
          .toList(),
    );
    emit(
      AssistanceState(
        invitation: newInvitation,
        status: newInvitation == _originalInvitation
            ? AssistanceStatus.confirmed
            : AssistanceStatus.unconfirmed,
      ),
    );
  }

  Future<void> confirmInvitation() async {
    try {
      emit(
        AssistanceState(
          invitation: state.invitation,
          status: AssistanceStatus.confirming,
        ),
      );
      final confirmed =
          await _homeRepository.updateInvitation(state.invitation);
      if (confirmed) {
        _originalInvitation = state.invitation;
        emit(
          AssistanceState(
            invitation: state.invitation,
            status: AssistanceStatus.confirmed,
          ),
        );
        return;
      }
      emit(
        AssistanceState(
          invitation: state.invitation,
          status: AssistanceStatus.error,
        ),
      );
    } catch (_) {}
  }

  bool get confirmEnabled => _originalInvitation != state.invitation;

  Invitation _originalInvitation;
  final HomeRepository _homeRepository;
}

extension on Invitation {
  bool get confirmed {
    return guests?.every((e) => e.isAttending != null) ?? false;
  }
}
