import 'package:flutter/material.dart';

class LoginInfo with ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  void userLoggedIn() {
    _loggedIn = true;
    notifyListeners();
  }
}
