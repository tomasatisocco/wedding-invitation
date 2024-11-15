import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';

part 'unlock_state.dart';

class UnlockCubit extends Cubit<UnlockStatus> {
  UnlockCubit() : super(UnlockStatus.locked);

  Future<void> unlock(String password) async {
    try {
      emit(UnlockStatus.unlocking);
      final callable = FirebaseFunctions.instanceFor(
        region: 'southamerica-east1',
      ).httpsCallable(
        'validatePassword',
      );

      // Call the Firebase Function to validate the password
      final response = await callable.call<Map<dynamic, dynamic>>(
        <String, dynamic>{
          'password': password,
        },
      );

      if (response.data['unlocked'] == true) return emit(UnlockStatus.unlocked);
      emit(UnlockStatus.error);
    } catch (e) {
      emit(UnlockStatus.error);
    }
  }
}
