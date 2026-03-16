
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession extends ChangeNotifier {
  String? _userId;
  String? _token;
  bool _isInitialized = false;

  String? get userId => _userId;
  String? get token => _token;
  bool get isLoggedIn => _userId != null && _token != null;
  bool get isInitialized => _isInitialized;

  void Function(String userId)? onUserIdChanged;

  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    _token = prefs.getString('token');
    _isInitialized = true;

    if (_userId != null && onUserIdChanged != null) {
      onUserIdChanged!(_userId!);
    }

    notifyListeners();
  }

  Future<void> login(String userId, String token) async {
    _userId = userId;
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('token', token);

    if (onUserIdChanged != null) {
      onUserIdChanged!(userId);
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('token');
    notifyListeners();
  }
}
