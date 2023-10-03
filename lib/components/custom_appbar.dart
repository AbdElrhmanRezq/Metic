import 'package:crescendo/components/custom_cart_button.dart';
import 'package:flutter/material.dart';

import 'custom_back_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return AppBar(
      backgroundColor: Colors.white,
      leading: CustomBackIcon(),
      title: Image.asset(
        'images/logo.png',
        height: height * 0.18,
      ),
      centerTitle: true,
      elevation: 0,
      actions: const [CustomCartButton()],
    );
  }

  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
