import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  String _userIdKey = 'user_id_key';
  SharedPreferences _prefs;

  SharedPrefsService() {
    _initSharedPreferences();
  }

  _initSharedPreferences() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<bool> saveLoggedInUserId(String userId) async {
    await _initSharedPreferences();
    return await _prefs.setString(_userIdKey, userId);
  }

  Future<String> getLoggedInUserId() async {
    await _initSharedPreferences();

    return _prefs.get(_userIdKey);
  }

  deleteLoggedInUserId() async {
    await _initSharedPreferences();
    return await _prefs.remove(_userIdKey);
  }
}
