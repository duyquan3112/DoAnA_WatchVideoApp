import 'package:shared_preferences/shared_preferences.dart';

/// This generic SharedPreferences does not test yet. It might not works
class SharedPrefs {
  SharedPreferences? _prefs;

  Future<SharedPrefs> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveData<T>(String key, T value) async {
    switch (T) {
      case String:
        _prefs?.setString(key, value as String);
        break;
      case int:
        _prefs?.setInt(key, value as int);
        break;
      case bool:
        _prefs?.setBool(key, value as bool);
        break;
      case double:
        _prefs?.setDouble(key, value as double);
        break;
    }
  }

  T? getData<T>(String key) {
    T? res;
    switch (T) {
      case String:
        res = _prefs?.getString(key) as T?;
        break;
      case int:
        res = _prefs?.getInt(key) as T?;
        break;
      case bool:
        res = _prefs?.getBool(key) as T?;
        break;
      case double:
        res = _prefs?.getDouble(key) as T?;
        break;
    }
    return res;
  }
}
