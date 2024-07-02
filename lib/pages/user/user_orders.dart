import 'package:crescendo/components/custom_progress_indicator.dart';
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
            title: Text("Cancel Order?"),
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
                    email: doc[KUserEmail],
                    deliveryAddress: doc[KOrderDeliveryAddress]),
              );
            });
            return Container(
              color: Theme.of(context).colorScheme.background,
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(KBorderRadius),
                          color: Theme.of(context).colorScheme.primary),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('order-details',
                              arguments: orders[index].docId);
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Delivery Address: ${orders[index].deliveryAddress}"),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Additional: ${orders[index].additional}'),
                              Text('Total Price: ${orders[index].totalPrice}')
                            ],
                          ),
                        ),
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
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const CustomProgressIndicator();
          }
        },
      ),
    );
  }
}
