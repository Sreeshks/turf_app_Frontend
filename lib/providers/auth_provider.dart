import 'package:flutter/material.dart';
import 'package:turf2/Api/repo/login_api.dart';

class AuthProvider with ChangeNotifier {
  final LoginApi _loginApi = LoginApi();
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final message = await _loginApi.login(email: email, password: password);

      _successMessage = message;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }
}
