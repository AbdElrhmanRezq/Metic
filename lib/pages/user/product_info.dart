import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_appbar.dart';
import '../../models/cart.dart';
import '../../models/product.dart';

class ProductInfo extends StatefulWidget {
  static final String id = 'product-info';

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    Product _product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15)),
          child: ListView(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Hero(
                  tag: '${_product.id}',
                  child: Image.network(
                    _product.imageUrl as String,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    quantity++;
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.add)),
                              Text((quantity.toString())),
                              IconButton(
                                  onPressed: () {
                                    if (quantity >= 1) quantity--;
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.remove)),
                            ],
                          ),
                          Builder(
                            builder: (context) => GestureDetector(
                              onTap: () {
                                String response =
                                    Provider.of<Cart>(context, listen: false)
                                        .addItem(_product, quantity, context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(response),
                                  duration: Duration(milliseconds: 500),
                                ));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 15),
                                    child: Text(
                                      "Add to cart",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  _product.name as String,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  'Product Info',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(_product.description as String,
                    style: TextStyle(fontSize: 12)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
