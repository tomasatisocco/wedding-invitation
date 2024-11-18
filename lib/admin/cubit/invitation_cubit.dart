import 'package:admin_repository/admin_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  InvitationCubit({
    required AdminRepository adminRepository,
    required Invitation invitation,
  })  : _adminRepository = adminRepository,
        super(
          InvitationState(
            originalInvitation: invitation,
            actualInvitation: invitation,
          ),
        );

  void updateInvitation(Invitation invitation) {
    emit(
      InvitationState(
        originalInvitation: state.originalInvitation,
        actualInvitation: invitation,
      ),
    );
  }

  void updateGuest(Guest guest) {
    final newInvitation = state.actualInvitation.copyWith(
      guests: state.actualInvitation.guests
          ?.map((e) => e.id == guest.id ? guest : e)
          .toList(),
    );
    updateInvitation(newInvitation);
  }

  void deleteGuest(Guest guest) {
    final newInvitation = state.actualInvitation.copyWith(
      guests: state.actualInvitation.guests
          ?.where((e) => e.id != guest.id)
          .toList(),
    );
    updateInvitation(newInvitation);
  }

  void addGuest(Guest guest) {
    final newInvitation = state.actualInvitation.copyWith(
      guests: [...state.actualInvitation.guests ?? [], guest],
    );
    updateInvitation(newInvitation);
  }

  Future<void> saveInvitation() async {
    try {
      emit(
        InvitationState(
          originalInvitation: state.originalInvitation,
          actualInvitation: state.actualInvitation,
          status: InvitationStatus.loading,
        ),
      );
      final updated = await _adminRepository.updateInvitation(
        state.actualInvitation,
      );
      if (!updated) return;
      emit(
        InvitationState(
          originalInvitation: state.actualInvitation,
          actualInvitation: state.actualInvitation,
        ),
      );
    } catch (_) {
      emit(
        InvitationState(
          originalInvitation: state.originalInvitation,
          actualInvitation: state.actualInvitation,
          status: InvitationStatus.error,
        ),
      );
    }
  }

  final AdminRepository _adminRepository;
}
