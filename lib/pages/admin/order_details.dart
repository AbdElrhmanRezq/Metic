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
            final docData = doc.data() as Map<String, dynamic>;
            items.add(OrderItem(
              name: doc[KProductName],
              price: doc[KProductPrice],
              quantity: doc[KProductQuantity],
              discount: docData.containsKey(KProductDiscount)
                  ? doc[KProductDiscount]
                  : null,
            ));
          });
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              color: Theme.of(context).colorScheme.background,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(KBorderRadius),
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Product: ${items[index].name}"),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Builder(builder: (context) {
                                String text;
                                if (items[index].discount == null) {
                                  text =
                                      "Price: ${(items[index].quantity * (double.parse(items[index].price as String)))}";
                                } else {
                                  text =
                                      "Price: ${(items[index].quantity * (double.parse(items[index].price as String) - double.parse(items[index].discount as String))).toString()}";
                                }
                                return Text(text);
                              }),
                              Text("Quantity: ${items[index].quantity}")
                            ],
                          ),
                        ),
                      ),
                    ),
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
