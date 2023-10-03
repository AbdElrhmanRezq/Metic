import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crescendo/components/custom_cart_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
import '../../models/product.dart';
import '../../services/auth.dart';
import '../../services/store.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homepage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;
  void signOut() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
    Navigator.of(context).pushReplacementNamed("login");
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final _store = Store();
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
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'images/holders/holder1.jpeg',
                                        image:
                                            products[index].imageUrl as String,
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
                                  child: Text(
                                    "EGP ${products[index].price as String}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
