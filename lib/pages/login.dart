import 'package:crescendo/components/custom_logo.dart';
import 'package:crescendo/components/custom_textfield.dart';
import 'package:crescendo/consts.dart';
import 'package:crescendo/pages/reset_password.dart';
import 'package:crescendo/provider/admin_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth.dart';

class Login extends StatelessWidget {
  Auth _auth = Auth();
  String _email = '';
  String _password = '';
  String adminPassword = 'password12345678';
  String adminEmail = 'admin_crescendo@gmail.com';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  static const String id = 'login';

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<AdminMode>(context).isAdmin;

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
              CutsomLogo(percent: 0.25),
              CustomTextField(
                hint: "Email",
                onClick: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: height * 0.01),
              CustomTextField(
                hint: "Password",
                onClick: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: height * 0.005),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('reset-password');
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.005),
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      _validate(context, isAdmin);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      child: const Center(
                        child: Text(
                          "Login",
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
                  const Text("Not a member? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('signup');
                    },
                    child: const Text(
                      "Register Now",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<AdminMode>(context, listen: false)
                          .changeIsAdmin();
                    },
                    child: Icon(
                        isAdmin ? Icons.admin_panel_settings : Icons.person),
                  ),
                ),
              )
            ]),
          )),
        ),
      ),
    );
  }

  void _validate(BuildContext context, bool isAdmin) async {
    if (_key.currentState?.validate() ?? true) {
      final progress = ProgressHUD.of(context);
      progress?.show();
      _key.currentState?.save();
      if (isAdmin) {
        if (_password == adminPassword && _email == adminEmail) {
          try {
            await _auth.signIn(_email, _password);
            Navigator.of(context).pushReplacementNamed('adminpage');
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message as String)));
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: const Text("Not an admin")));
        }
      } else {
        try {
          SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setBool(KUserLoggedIn, true);
          _pref.setString(KUserEmail, _email);
          await _auth.signIn(_email, _password);
          Navigator.of(context).pushReplacementNamed('hidden-drawer');
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message as String)));
        }
      }
      progress?.dismiss();
    }
  }
}
