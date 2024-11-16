import 'package:bloc/bloc.dart';
import 'package:unlock_repository/unlock_repository.dart';

part 'unlock_state.dart';

class UnlockCubit extends Cubit<UnlockStatus> {
  UnlockCubit({required UnlockRepository unlockRepository})
      : _unlockRepository = unlockRepository,
        super(UnlockStatus.locked);

  Future<void> unlock(String password) async {
    try {
      emit(UnlockStatus.unlocking);
      final unlocked = await _unlockRepository.unlock(password);
      if (unlocked) return emit(UnlockStatus.unlocked);
      emit(UnlockStatus.error);
    } catch (e) {
      emit(UnlockStatus.error);
    }
  }

  final UnlockRepository _unlockRepository;
}
