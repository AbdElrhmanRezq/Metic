import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crescendo/models/order_item.dart';
import 'package:crescendo/services/store.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class OrderDetails extends StatefulWidget {
  static final String id = 'order-details';

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    String docId = ModalRoute.of(context)?.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadOrderDetails(docId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OrderItem> items = [];
          snapshot.data?.docs.forEach((doc) {
            items.add(OrderItem(
                name: doc[KProductName],
                price: doc[KProductPrice],
                quantity: doc[KProductQuantity]));
          });
          return Scaffold(
            body: Container(
              color: Theme.of(context).colorScheme.background,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].name),
                    subtitle: Text(
                        '${items[index].price} , ${items[index].quantity.toString()}'),
                  );
                },
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
