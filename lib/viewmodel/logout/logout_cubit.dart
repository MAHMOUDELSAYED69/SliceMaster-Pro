import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../utils/helpers/shared_pref.dart';

part 'logout_state.dart';

class AuthStatus extends Cubit<AuthStatusState> {
  AuthStatus() : super(LogoutInitial());

  void checkLoginStatus() {
    try {
      bool isUserLogin = CacheData.getData(key: 'isUserLogin') ?? false;
      if (isUserLogin) {
        emit(Login());
      } else {
        emit(Logout());
      }
    } catch (_) {
      emit(LogoutFailure());
    }
  }

  Future<void> logout() async {
    try {
      await CacheData.setData(key: 'isUserLogin', value: false);
      CacheData.deleteData(key: 'currentUser');
      emit(Logout());
    } catch (e) {
      emit(LogoutFailure());
    }
  }

  deactivate() {}
}
