import 'package:crescendo/models/cart_item.dart';
import 'package:crescendo/models/product.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  late List<CartItem> items = [];

  String addItem(Product product, int quantity, BuildContext context) {
    bool inCartAlready = false;

    for (var item in items) {
      if (item.product.id == product.id) {
        inCartAlready = true;
        break;
      }
    }
    if (inCartAlready) {
      return "Item is alreadt in cart";
    } else {
      items.add(CartItem(product: product, quantity: quantity));
      notifyListeners();
      return "Added to cart";
    }
  }

  void clearCart() {
    items = [];
    notifyListeners();
  }

  void removeItem(CartItem item) {
    items.remove(item);
    notifyListeners();
  }
}
