import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../consts.dart';
import '../../models/order.dart';
import '../../services/store.dart';

class ViewOrders extends StatefulWidget {
  static final String id = 'view-orders';

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  Store _store = Store();
  changeState(docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change to finished?"),
          actions: [
            TextButton(
                onPressed: () {
                  _store.editOrderState(docId, KOrderStateFinished);
                  Navigator.of(context).pop();
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

  Widget orderView(BuildContext context, String state) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MyOrder> orders = [];
          snapshot.data?.docs.forEach((doc) {
            if (doc[KOrderState] == state) {
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
                  deliveryAddress: doc[KOrderDeliveryAddress],
                ),
              );
            }
          });
          return Scaffold(
            body: Container(
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
                        if (orders[index].state == 'Active') {
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
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Orders"),
          ),
          body: Column(
            children: [
              const TabBar(tabs: [
                Tab(
                  child: Text(
                    "Active",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "Finished",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "Cancelled",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ]),
              Expanded(
                child: TabBarView(children: [
                  orderView(context, 'Active'),
                  orderView(context, 'Finished'),
                  orderView(context, 'Cancelled'),
                ]),
              )
            ],
          )),
    );
  }
}
/*
StreamBuilder<QuerySnapshot>(
          stream: _store.loadOrders(),
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
                      docId: doc.id),
                );
              });
              return Scaffold(
                body: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(orders[index].name),
                        subtitle: Text(
                            '${orders[index].phone} , ${orders[index].totalPrice}'),
                        trailing: TextButton(
                          onPressed: () => changeState(orders[index].docId),
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
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),

*/
