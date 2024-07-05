import 'package:crescendo/components/custom_logo.dart';
import 'package:crescendo/pages/user/about_products.dart';
import 'package:crescendo/pages/user/about_us.dart';
import 'package:crescendo/pages/user/home_page.dart';
import 'package:crescendo/pages/user/profile.dart';
import 'package:crescendo/pages/user/user_orders.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import '../../components/custom_cart_button.dart';
import '../../consts.dart';

class MyHiddenDrawer extends StatefulWidget {
  static final String id = 'hidden-drawer';

  @override
  State<MyHiddenDrawer> createState() => _MyHiddenDrawerState();
}

class _MyHiddenDrawerState extends State<MyHiddenDrawer> {
  final selectedText = TextStyle(
      color: Color.fromARGB(255, 48, 48, 48), fontWeight: FontWeight.bold);
  final baseText = TextStyle(color: Colors.grey, fontWeight: FontWeight.normal);
  List<ScreenHiddenDrawer> _pages = [];
  @override
  void initState() {
    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "Home",
              baseStyle: baseText,
              selectedStyle: selectedText,
              colorLineSelected: KMetic),
          const HomePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "Profile",
              baseStyle: baseText,
              selectedStyle: selectedText,
              colorLineSelected: KMetic),
          const Profile()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "My orders",
              baseStyle: baseText,
              selectedStyle: selectedText,
              colorLineSelected: KMetic),
          const UserOrders()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "About us",
              baseStyle: baseText,
              selectedStyle: selectedText,
              colorLineSelected: KMetic),
          const AboutUs()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: _pages,
      backgroundColorMenu: Theme.of(context).colorScheme.background,
      elevationAppBar: 0,
      initPositionSelected: 0,
      slidePercent: 50,
      actionsAppBar: [const CustomCartButton()],
      tittleAppBar: Container(
          height: 120, child: Image.asset("images/logo/metic_red_p.png")),
      leadingAppBar: Icon(
        Icons.menu,
        color: KMetic,
      ),
    );
  }
}
