import 'package:flutter/material.dart';

class CustomTextFieldNew extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const CustomTextFieldNew(
      {super.key, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: controller,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hint),
          ),
        ),
      ),
    );
  }
}
