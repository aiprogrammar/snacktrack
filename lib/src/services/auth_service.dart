import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'user_data';
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Future<bool> login(String email, String pin) async {
    final user = User(email: email, pin: pin);
    final success = await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    return success;
  }

  Future<void> logout() async {
    await _prefs.remove(_userKey);
  }

  User? getCurrentUser() {
    final userData = _prefs.getString(_userKey);
    if (userData == null) return null;
    return User.fromJson(jsonDecode(userData));
  }

  bool isLoggedIn() {
    return _prefs.containsKey(_userKey);
  }
}
