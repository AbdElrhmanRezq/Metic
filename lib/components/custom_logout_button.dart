import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomLogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void signOut() async {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.clear();
      Navigator.of(context).pushReplacementNamed("login");
    }

    return IconButton(
        onPressed: () {
          signOut();
        },
        icon: Icon(Icons.logout));
  }
}
