import 'dart:convert';

import '../../models/get_user_data.dart';
import 'secure_storage_keys.dart';
import 'shared_prefs.dart';

class StorageManager {
  static final instance = StorageManager._();

  StorageManager._();

  SharedPrefs preferences = SharedPrefs();

  String? get cacheUser => preferences.getData<String>(SecureStorageKeys.user);

  Future<void> setCacheUser(String val) async {
    return await preferences.saveData<String>(
      SecureStorageKeys.user,
      val,
    );
  }

  UserData? _user;

  UserData? get userCurrent => _user;

  set setUserCurrent(UserData? user) {
    _user = user?.copyWith();
    setCacheUser(user == null ? '' : jsonEncode(user.toJson()));
  }
}
