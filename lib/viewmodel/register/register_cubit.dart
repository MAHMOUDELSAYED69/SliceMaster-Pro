import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../database/sql.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  final SqlDb _sqlDb = SqlDb();

  Future<void> register(String username, String password) async {
    try {
      final existingUser = await _sqlDb.getUser(username, password);
      if (existingUser != null) {
        emit(UsernameTaken());
        return;
      }

      final userId = await _sqlDb.insertUser(username, password);
      if (userId != null) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure());
      }
    } catch (_) {
      emit(RegisterFailure());
    }
  }
}
