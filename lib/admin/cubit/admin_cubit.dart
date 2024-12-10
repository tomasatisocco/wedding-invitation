import 'package:admin_repository/admin_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit({
    required AdminRepository adminRepository,
    bool? testing,
  })  : _adminRepository = adminRepository,
        super(const AdminState()) {
    if (testing ?? false) return;
    getInvitations();
  }

  Future<void> getInvitations({Invitation? selected}) async {
    try {
      emit(const AdminState());
      final invitations = await _adminRepository.getInvitations();
      _originalList = invitations;

      emit(
        AdminState(
          status: AdminStatus.loaded,
          invitations: _originalList,
          selectedInvitation: selected,
        ),
      );
    } catch (e) {
      emit(const AdminState(status: AdminStatus.error));
    }
  }

  void search(String query) {
    final invitations =
        _originalList?.where((e) => e.id?.contains(query) ?? false).toList();
    emit(
      AdminState(
        status: AdminStatus.loaded,
        selectedInvitation: state.selectedInvitation,
        invitations: invitations,
      ),
    );
  }

  void selectInvitation(Invitation? invitation) {
    emit(
      AdminState(
        status: AdminStatus.loaded,
        selectedInvitation: invitation,
        invitations: _originalList,
      ),
    );
  }

  Future<void> addInvitation(Invitation invitation) async {
    try {
      await _adminRepository.addInvitation(invitation);
      await getInvitations(selected: invitation);
    } catch (_) {}
  }

  void updateInvitation(Invitation invitation) {
    try {
      _originalList = _originalList?.map((e) {
        if (e.id == invitation.id) return invitation;
        return e;
      }).toList();
      emit(
        AdminState(
          status: AdminStatus.loaded,
          selectedInvitation: state.selectedInvitation,
          invitations: _originalList,
        ),
      );
    } catch (_) {}
  }

  void selectHome() {
    emit(
      AdminState(
        status: AdminStatus.loaded,
        invitations: _originalList,
      ),
    );
  }

  void selectByGuest(Guest guest) {
    final invitation =
        _originalList?.firstWhere((e) => e.guests?.contains(guest) ?? false);
    emit(
      AdminState(
        status: AdminStatus.loaded,
        selectedInvitation: invitation,
        invitations: state.invitations,
      ),
    );
  }

  final AdminRepository _adminRepository;
  List<Invitation>? _originalList;
}
