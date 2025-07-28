import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _userNameKey = 'userName';
  static const _emailKey = 'email';
  static const _phoneKey = 'phone';
  static const _ageKey = 'age';
  static const _genderKey = 'gender';

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> saveUserDetails({
    required String name,
    required String email,
    required String phone,
    required String age,
    required String gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_phoneKey, phone);
    await prefs.setString(_ageKey, age);
    await prefs.setString(_genderKey, gender);
  }

  Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_userNameKey) ?? '',
      'email': prefs.getString(_emailKey) ?? '',
      'phone': prefs.getString(_phoneKey) ?? '',
      'age': prefs.getString(_ageKey) ?? '',
      'gender': prefs.getString(_genderKey) ?? '',
    };
  }

  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  init() {}
}
