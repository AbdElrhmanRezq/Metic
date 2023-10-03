import 'package:flutter/material.dart';

class CustomBackIcon extends StatelessWidget {
  const CustomBackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.black,
      icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
