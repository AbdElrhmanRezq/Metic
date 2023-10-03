import 'package:crescendo/consts.dart';
import 'package:crescendo/models/cart.dart';
import 'package:crescendo/pages/admin/add_product.dart';
import 'package:crescendo/pages/admin/admin_page.dart';
import 'package:crescendo/pages/admin/manage_product.dart';
import 'package:crescendo/pages/admin/order_details.dart';
import 'package:crescendo/pages/admin/view_orders.dart';
import 'package:crescendo/pages/user/cart_page.dart';
import 'package:crescendo/pages/user/edit_user.dart';
import 'package:crescendo/pages/user/hidden_drawer.dart';
import 'package:crescendo/pages/user/home_page.dart';
import 'package:crescendo/pages/login.dart';
import 'package:crescendo/pages/reset_password.dart';
import 'package:crescendo/pages/signup.dart';
import 'package:crescendo/pages/user/product_info.dart';
import 'package:crescendo/provider/admin_mode.dart';
import 'package:crescendo/themes/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/admin/edit_products.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          isUserLoggedIn = snapshot.data?.getBool(KUserLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AdminMode>(
                  create: (context) => AdminMode()),
              ChangeNotifierProvider<Cart>(create: (context) => Cart()),
            ],
            child: MaterialApp(
              initialRoute: isUserLoggedIn ? MyHiddenDrawer.id : Login.id,
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              routes: {
                Login.id: (context) => Login(),
                Signup.id: (context) => Signup(),
                HomePage.id: (context) => HomePage(),
                ResetPassword.id: (context) => ResetPassword(),
                AdminPage.id: (context) => AdminPage(),
                AddProduct.id: (context) => AddProduct(),
                EditProduct.id: (context) => EditProduct(),
                ManageProduct.id: (context) => ManageProduct(),
                ProductInfo.id: (context) => ProductInfo(),
                CartPage.id: (context) => CartPage(),
                ViewOrders.id: (context) => ViewOrders(),
                MyHiddenDrawer.id: (context) => MyHiddenDrawer(),
                OrderDetails.id: (context) => OrderDetails(),
                EditUser.id: (context) => EditUser(),
              },
            ),
          );
        }
      },
    );
  }
}

//isUserLoggedIn ? MyHiddenDrawer.id : Login.id