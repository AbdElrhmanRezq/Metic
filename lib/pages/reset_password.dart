import 'package:crescendo/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-password';
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();

  void resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Check your email address for a reset email"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("An error occured"),
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: KMetic),
        elevation: double.minPositive,
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your email below",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Email address"),
                    controller: _emailController,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    resetPassword();
                  },
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Reset password",
                      style: TextStyle(
                          color: KMetic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ))),
            )
          ],
        )),
      )),
    );
  }
}
