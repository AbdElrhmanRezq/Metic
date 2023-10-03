import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';
import '../../models/product.dart';
import '../../services/store.dart';

class ManageProduct extends StatefulWidget {
  static final String id = "manage-product";

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  Store _store = Store();
  void deleteItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this item?"),
          actions: [Text("Go"), Text("Cancel")],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProcuts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            snapshot.data?.docs.forEach((doc) {
              products.add(Product(
                  id: doc.id,
                  name: doc[KProductName],
                  price: doc[KProductPrice],
                  description: doc[KProductDescription],
                  imageUrl: doc[KProductImageUrl]));
            });
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.85),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTapUp: (detail) {
                      double dx = detail.globalPosition.dx;
                      double dy = detail.globalPosition.dy;
                      double dx2 = MediaQuery.of(context).size.width - dx;
                      double dy2 = MediaQuery.of(context).size.height - dy;
                      showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                          items: [
                            PopupMenuItem(
                              child: const Text("Edit"),
                              onTap: () {
                                Navigator.of(context).pushNamed('edit-product',
                                    arguments: products[index]);
                                Navigator.of(context).pushNamed('edit-product',
                                    arguments: products[index]);
                              },
                            ),
                            PopupMenuItem(
                              child: const Text("Delete"),
                              onTap: () {
                                _store.deleteProduct(products[index].id);
                              },
                            )
                          ]);
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.network(
                          products[index].imageUrl as String,
                          fit: BoxFit.fill,
                        )),
                        Positioned(
                            bottom: 0,
                            child: Opacity(
                              opacity: 0.6,
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child:
                                          Text(products[index].name as String),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                          '\$ ${products[index].price as String}'),
                                    )
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
