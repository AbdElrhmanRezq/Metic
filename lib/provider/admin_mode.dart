import 'package:flutter/material.dart';

class AdminMode extends ChangeNotifier {
  bool isAdmin = false;
  void changeIsAdmin() {
    if (isAdmin == true) {
      isAdmin = false;
    } else {
      isAdmin = true;
    }
    notifyListeners();
  }
}
