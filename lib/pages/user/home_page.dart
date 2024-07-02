import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crescendo/components/custom_colored_label.dart';
import 'package:crescendo/components/custom_price.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';
import '../../models/product_multi_photos.dart';
import '../../services/store.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homepage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int _tabIndex = 0;
  void signOut() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
    Navigator.of(context).pushReplacementNamed("login");
  }

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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<List<MultiProduct>>(
        stream: productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MultiProduct> products = snapshot.data as List<MultiProduct>;
            return Container(
              color: Theme.of(context).colorScheme.background,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5 * width / height),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('product-info',
                                arguments: products[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius:
                                    BorderRadius.circular(KBorderRadius)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(KBorderRadius),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/holders/logo.jpg',
                                        image: products[index].imageUrls?[0]
                                            as String,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Text(
                                    products[index].name as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                CustomPrice(
                                  iDiscount: products[index].discount == null
                                      ? "null"
                                      : products[index].discount as String,
                                  initPrice: products[index].price as String,
                                  size: 12,
                                ),
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

/*final _store = Store();
    return StreamBuilder<QuerySnapshot>(
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
                location: doc[KProductLocation]));
          });
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
                        onTap: () {
                          Navigator.of(context).pushNamed('product-info',
                              arguments: products[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(KBorderRadius)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: products[index].id as String,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(KBorderRadius),
                                    child: Image.asset(
                                      products[index].location as String,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  color: Colors.grey,
                                  height: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  products[index].name as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "EGP ${products[index].price as String}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
    ); */
