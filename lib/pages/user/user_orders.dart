import 'package:crescendo/services/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';
import '../../models/order.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  @override
  Widget build(BuildContext context) {
    Store _store = Store();
    final _user = FirebaseAuth.instance;

    changeState(docId) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Change the order state?"),
            actions: [
              TextButton(
                  onPressed: () {
                    _store.editOrderState(docId, KOrderStateCancelled);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        },
      );
    }

    return Scaffold(
      body: StreamBuilder(
        stream: _store.loadUserOrders(_user.currentUser?.email as String),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MyOrder> orders = [];
            snapshot.data?.docs.forEach((doc) {
              orders.add(
                MyOrder(
                    address: doc[KAddress],
                    name: doc[KUserName],
                    additional: doc[KOrderAdditional],
                    phone: doc[KPhone],
                    totalPrice: doc[KTotalPrice],
                    state: doc[KOrderState],
                    docId: doc.id,
                    email: doc[KUserEmail]),
              );
            });
            return Container(
              color: Theme.of(context).colorScheme.background,
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed('order-details',
                          arguments: orders[index].docId);
                    },
                    title: Text(orders[index].name),
                    subtitle: Text(
                        '${orders[index].phone} , ${orders[index].totalPrice}'),
                    trailing: TextButton(
                      onPressed: () {
                        if (orders[index].state == KOrderStateActive) {
                          changeState(orders[index].docId);
                        }
                      },
                      child: Text(
                        orders[index].state,
                        style: TextStyle(
                            color: orders[index].state == 'Active'
                                ? Colors.green
                                : Colors.red),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
