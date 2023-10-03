import 'package:crescendo/components/custom_button.dart';
import 'package:crescendo/components/custom_logout_button.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class AdminPage extends StatelessWidget {
  static final String id = 'adminpage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        centerTitle: true,
        actions: [CustomLogoutButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(KBorderRadiusPages)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  callback: () {
                    Navigator.of(context).pushNamed('add-product');
                  },
                  text: "Add product",
                ),
                const SizedBox(height: 10),
                CustomButton(
                  callback: () {
                    Navigator.of(context).pushNamed('manage-product');
                  },
                  text: "Manage products",
                ),
                const SizedBox(height: 10),
                CustomButton(
                  callback: () {
                    Navigator.of(context).pushNamed('view-orders');
                  },
                  text: "View Orders",
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
