import 'package:flutter/material.dart';

import '../consts.dart';

class CustomButtomSheet extends StatelessWidget {
  String textMessage;
  double height;
  CustomButtomSheet({required this.textMessage, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height * 0.15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KBorderRadiusPages)),
        child: Center(
          child: Text(
            textMessage,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
