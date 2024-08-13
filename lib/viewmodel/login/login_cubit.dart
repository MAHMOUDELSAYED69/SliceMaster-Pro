import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../database/sql.dart';
import '../../utils/helpers/shared_pref.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final SqlDb _sqlDb = SqlDb();

  Future<void> login(
      {required String username, required String password}) async {
    try {
      final user = await _sqlDb.getUser(username, password);
      if (user != null) {
        await CacheData.setData(key: 'isUserLogin', value: true);
        await CacheData.setData(key: 'currentUser', value: username);
        emit(LoginSuccess());
      } else {
        emit(LoginFailure());
      }
    } catch (e) {
      emit(LoginFailure());
    }
  }
}
