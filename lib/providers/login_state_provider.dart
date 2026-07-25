import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eluthozhi_v3/services/firebase_auth_service.dart';

class LoginStateProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  final FirebaseAuthService _authService = FirebaseAuthService();

  LoginStateProvider() {
    _initAuthListener();
  }

  bool get isLoggedIn => _user != null;
  User? get user => _user;
  bool get isLoading => _isLoading;

  void _initAuthListener() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      _isLoading = false;
      await _updatePrefs(user != null);
      notifyListeners();
    });
  }

  Future<void> _updatePrefs(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', loggedIn);
  }

  Future<void> logIn(User user) async {
    _user = user;
    await _updatePrefs(true);
    notifyListeners();
  }

  Future<void> logOut() async {
    await _authService.signOut();
    _user = null;
    await _updatePrefs(false);
    notifyListeners();
  }
}
