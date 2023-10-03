import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crescendo/components/custom_back_icon.dart';
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
  TextEditingController _controller = TextEditingController();
  void order(String totalPrice, List<CartItem> cart) async {
    String additional;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Any additional requests?"),
          content: TextField(
            controller: _controller,
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  additional = _controller.text.trim();
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
                      totalPrice,
                      additional,
                      cart,
                      'Active');
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order sent")));
                  Navigator.of(context).pop();
                  Provider.of<Cart>(context, listen: false).clearCart();
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
                child: const Text("Empty")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String sumTotalAmount(List<CartItem> cart) {
      double totalAmount = 0;
      for (var item in cart) {
        totalAmount +=
            item.quantity * (int.parse(item.product.price as String));
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
                            leading: Container(
                              child: Image.network(
                                  fit: BoxFit.cover,
                                  _cartItems[index].product.imageUrl as String),
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
                                  Text(
                                      "Price: ${(_cartItems[index].quantity * (int.parse(_cartItems[index].product.price as String))).toString()}")
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
                    color: Colors.deepPurple[500],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Total Amount: ${sumTotalAmount(_cartItems)} EGP",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          order(sumTotalAmount(_cartItems), _cartItems);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
