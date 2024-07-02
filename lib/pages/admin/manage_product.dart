import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crescendo/components/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../components/custom_back_icon.dart';
import '../../consts.dart';
import '../../models/product.dart';
import '../../models/product_multi_photos.dart';
import '../../services/store.dart';

class ManageProduct extends StatefulWidget {
  static final String id = "manage-product";

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final _store = Store();

  Stream<List<MultiProduct>>? productsStream;

  Future<MultiProduct> generateMultiProduct(DocumentSnapshot doc) async {
    List<String> images = [];
    String docId = doc.id;
    List<DocumentSnapshot> imagesDocs = await _store.loadProcutImages(docId);

    imagesDocs.forEach((imageDoc) {
      images.add(imageDoc[KProductImageUrl]);
    });
    final docData = doc.data() as Map<String, dynamic>;

    return MultiProduct(
        id: doc.id,
        name: doc[KProductName],
        price: doc[KProductPrice],
        description: doc[KProductDescription],
        discount: docData.containsKey(KProductDiscount)
            ? doc[KProductDiscount]
            : null,
        imageUrls: images);
  }

  @override
  void initState() {
    super.initState();
    productsStream = _store.loadProcuts().asyncMap((snapshot) => Future.wait(
        [for (var doc in snapshot.docs) generateMultiProduct(doc)]));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _discountController = TextEditingController();
    TextEditingController _priceController = TextEditingController();

    final double height = MediaQuery.of(context).size.height;
    void applyDiscount(String docId) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter the amount"),
            content: TextField(
              controller: _discountController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _store.editProduct(
                        {KProductDiscount: _discountController.text.trim()},
                        docId);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        },
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter the amount"),
            content: TextField(
              controller: _discountController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _store.editProduct(
                        {KProductDiscount: _discountController.text.trim()},
                        docId);
                  },
                  child: Text("Confirm"))
            ],
          );
        },
      );
    }

    void changePrice(String docId) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter the new Price"),
            content: TextField(
              controller: _priceController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _store.editProduct(
                        {KProductPrice: _priceController.text.trim()}, docId);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        },
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter the new Price"),
            content: TextField(
              controller: _priceController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _store.editProduct(
                        {KProductPrice: _priceController.text.trim()}, docId);
                    Navigator.of(context).pop();
                    setState(() {});
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: CustomBackIcon(),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('add-product-editted');
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KBorderRadius)),
      ),
      body: StreamBuilder<List<MultiProduct>>(
        stream: productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MultiProduct> products = snapshot.data as List<MultiProduct>;
            return Container(
              color: Theme.of(context).colorScheme.background,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.65),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                          onTapUp: (detail) {
                            double dx = detail.globalPosition.dx;
                            double dy = detail.globalPosition.dy;
                            double dx2 = MediaQuery.of(context).size.width - dx;
                            double dy2 =
                                MediaQuery.of(context).size.height - dy;
                            showMenu(
                                context: context,
                                position:
                                    RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                                items: [
                                  PopupMenuItem(
                                    child: const Text("Change Price"),
                                    onTap: () {
                                      changePrice(products[index].id as String);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text("Apply discount"),
                                    onTap: () {
                                      applyDiscount(
                                          products[index].id as String);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text("Remove discount"),
                                    onTap: () {
                                      _store.removeDiscount(
                                          products[index].id as String);
                                      showBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return CustomButtomSheet(
                                              textMessage: "Discount Removerd",
                                              height: height);
                                        },
                                      );
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
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius:
                                    BorderRadius.circular(KBorderRadius)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1.3,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(KBorderRadius),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'images/holders/holder1.jpeg',
                                        image: products[index].imageUrls?[0]
                                            as String,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    products[index].name as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Builder(builder: (context) {
                                    if (products[index].discount != null) {
                                      double price = double.parse(
                                          products[index].price as String);
                                      double discount = double.parse(
                                          products[index].discount as String);
                                      double finalPrice = price - discount;
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "EGP ${price.toString()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                          Text(
                                            "EGP ${finalPrice}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Text(
                                        "EGP ${products[index].price as String}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  }),
                                )
                              ],
                            ),
                          )),
                    );
                  }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

/*

GestureDetector(
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
*/

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
