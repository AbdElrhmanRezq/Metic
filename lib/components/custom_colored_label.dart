import 'package:flutter/material.dart';

class CustomColoredLabel extends StatelessWidget {
  final Color color;
  final String text;
  CustomColoredLabel({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: this.color, borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          "EGP ${text}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.lineThrough),
        ),
      ),
    );
    ;
  }
}
