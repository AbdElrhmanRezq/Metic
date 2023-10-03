import 'package:crescendo/consts.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  late String title;
  late String description;
  CustomListTile({required this.description, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(KBorderRadius)),
          child: ListTile(
            title: Text(title),
            subtitle: Text(description),
          )),
    );
  }
}
