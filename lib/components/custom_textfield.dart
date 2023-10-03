import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String?)? onClick;
  final String hint;
  const CustomTextField({super.key, required this.hint, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            obscureText: hint == 'Password' ? true : false,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return '$hint is empty';
              }
            },
            onSaved: onClick,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hint),
          ),
        ),
      ),
    );
  }
}
