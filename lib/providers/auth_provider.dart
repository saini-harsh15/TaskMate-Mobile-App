import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  final ApiService _api = ApiService();
  bool loading = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;


  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');
    final username = prefs.getString('username');
    final email = prefs.getString('email');

    if (id != null && username != null && email != null) {
      _user = UserModel(id: id, username: username, email: email);
      notifyListeners();
    }
  }


  Future<void> signup(String username, String email, String password) async {
    loading = true;
    notifyListeners();
    try {
      final u = await _api.signup(username, email, password);
      _user = u;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', u.id);
      await prefs.setString('username', u.username);
      await prefs.setString('email', u.email);
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  Future<void> login(String email, String password) async {
    loading = true;
    notifyListeners();
    try {
      final u = await _api.login(email, password);
      _user = u;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', u.id);
      await prefs.setString('username', u.username);
      await prefs.setString('email', u.email);
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('email');
    notifyListeners();
  }


  Future<void> setUser(UserModel updatedUser) async {
    _user = updatedUser;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', updatedUser.id);
    await prefs.setString('username', updatedUser.username);
    await prefs.setString('email', updatedUser.email);
    notifyListeners();
  }
}
