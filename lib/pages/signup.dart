import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts.dart';
import '../services/auth.dart';
import '../components/custom_logo.dart';
import '../components/custom_textfield.dart';
import '../services/store.dart';

class Signup extends StatelessWidget {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  static const String id = "signup";

  @override
  Widget build(BuildContext context) {
    Store _store = Store();
    Auth _auth = Auth();
    String _email = '';
    String _userName = '';
    String _password = '';
    String _address = '';
    String _phone = '';
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ProgressHUD(
        child: Form(
          key: _key,
          child: SafeArea(
              child: Container(
            color: Colors.white,
            child: ListView(children: [
              SizedBox(height: height * 0.17),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter your details below",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              CustomTextField(
                hint: "Email",
                onClick: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: height * 0.01),
              CustomTextField(
                hint: "Username",
                onClick: (value) {
                  _userName = value!;
                },
              ),
              SizedBox(height: height * 0.01),
              CustomTextField(
                hint: "Phone Number",
                onClick: (value) {
                  _phone = value!;
                },
              ),
              SizedBox(height: height * 0.01),
              CustomTextField(
                hint: "Password",
                onClick: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: height * 0.01),
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () async {
                      if (_key.currentState?.validate() ?? true) {
                        final progress = ProgressHUD.of(context);
                        progress?.show();
                        _key.currentState?.save();
                        try {
                          SharedPreferences _pref =
                              await SharedPreferences.getInstance();
                          _pref.setString(KUserEmail, _email);
                          _pref.setBool(KUserLoggedIn, true);
                          await _auth.signUp(_email, _password);
                          await _store.storeUser(
                              _email, _userName, _phone, _address);
                          await Navigator.of(context)
                              .pushReplacementNamed('hidden-drawer');
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message as String)));
                        }
                        progress?.dismiss();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          "Signup",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already a member? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('login');
                    },
                    child: Text(
                      "Login Now",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              )
            ]),
          )),
        ),
      ),
    );
  }
}
