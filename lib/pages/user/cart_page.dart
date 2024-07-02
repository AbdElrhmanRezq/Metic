import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crescendo/components/custom_back_icon.dart';
import 'package:crescendo/components/custom_bottom_sheet.dart';
import 'package:crescendo/consts.dart';
import 'package:crescendo/models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/cart.dart';
import '../../services/store.dart';

class CartPage extends StatefulWidget {
  static final String id = 'cart-page';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController _additionalController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  Text alertMessage = const Text(
    "Please enter your delivery address",
    style: TextStyle(color: Colors.red),
  );
  Text normalMessage = const Text(
    "Please enter your delivery address",
    style: TextStyle(color: Colors.black),
  );

  void order(String totalPrice, List<CartItem> cart, double height) async {
    if (cart.isEmpty) {
      return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return CustomButtomSheet(
              textMessage: "Cart is Empty", height: height);
        },
      );
    } else {
      String additional;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: normalMessage,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _additionalController,
                  decoration: InputDecoration(
                      hintText: "Additional Requests (Optional)"),
                ),
                TextField(
                  controller: _addressController,
                  decoration:
                      InputDecoration(hintText: "Delivery Address in details"),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (!(_addressController.text.isEmpty)) {
                      additional = _additionalController.text.trim();
                      String deliveryAddress = _addressController.text.trim();
                      Store _store = Store();
                      final _user = FirebaseAuth.instance.currentUser;
                      DocumentSnapshot userDoc =
                          await _store.getUserByEmail(_user?.email as String);
                      Map<String, dynamic> userDetails =
                          userDoc.data() as Map<String, dynamic>;

                      _store.storeOrder(
                          userDetails[KUserAddress],
                          userDetails[KUserPhone],
                          userDetails[KUserName],
                          userDetails[KUserEmail],
                          deliveryAddress,
                          totalPrice,
                          additional,
                          cart,
                          'Active');
                      Navigator.of(context).pop();
                      Provider.of<Cart>(context, listen: false).clearCart();

                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return CustomButtomSheet(
                              textMessage: "Order sent", height: height);
                        },
                      );
                    } else {
                      normalMessage = alertMessage;
                      setState(() {});
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        },
      );
    }
  }

  void emptyCart() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to empty cart?"),
          actions: [
            TextButton(
                onPressed: () {
                  Provider.of<Cart>(context, listen: false).clearCart();
                  Navigator.of(context).pop();
                },
                child:
                    const Text("Empty", style: TextStyle(color: Colors.black))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.black)))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String sumTotalAmount(List<CartItem> cart) {
      double totalAmount = 0;
      for (var item in cart) {
        if (item.product.discount == null) {
          totalAmount +=
              item.quantity * (double.parse(item.product.price as String));
        } else {
          totalAmount += item.quantity *
              (double.parse(item.product.price as String) -
                  double.parse(item.product.discount as String));
        }
      }
      return totalAmount.toString();
    }

    List<CartItem> _cartItems = Provider.of<Cart>(context).items;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "My Cart",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: const CustomBackIcon(),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.remove_shopping_cart,
                color: Colors.black,
              ),
              onPressed: () {
                emptyCart();
              },
            )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(KBorderRadius),
                                child: Image.network(
                                    fit: BoxFit.cover,
                                    _cartItems[index].product.imageUrls?.first
                                        as String),
                              ),
                            ),
                            title:
                                Text(_cartItems[index].product.name as String),
                            subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _cartItems[index].quantity++;
                                            });
                                          },
                                          icon: const Icon(Icons.add)),
                                      Text(_cartItems[index]
                                          .quantity
                                          .toString()),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_cartItems[index].quantity >
                                                  1)
                                                _cartItems[index].quantity--;
                                            });
                                          },
                                          icon: const Icon(Icons.remove))
                                    ],
                                  )
                                ]),
                            trailing: FittedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Provider.of<Cart>(context, listen: false)
                                          .removeItem(_cartItems[index]);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                  Builder(builder: (context) {
                                    String text;
                                    if (_cartItems[index].product.discount ==
                                        null) {
                                      text =
                                          "Price: ${(_cartItems[index].quantity * (double.parse(_cartItems[index].product.price as String)))}";
                                    } else {
                                      text =
                                          "Price: ${(_cartItems[index].quantity * (double.parse(_cartItems[index].product.price as String) - double.parse(_cartItems[index].product.discount as String))).toString()}";
                                    }
                                    return Text(text);
                                  })
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total : ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${sumTotalAmount(_cartItems)} EGP",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          order(sumTotalAmount(_cartItems), _cartItems, height);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Text(
                              "Order now",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
