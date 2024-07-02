import 'package:flutter/material.dart';

import '../consts.dart';

class CustomParagraph extends StatelessWidget {
  final String title;
  final String description;
  const CustomParagraph({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(description,
              style: TextStyle(fontSize: 12, color: KGreyText)),
        )
      ],
    );
  }
}
