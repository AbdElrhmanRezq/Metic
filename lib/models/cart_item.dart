import 'package:crescendo/models/product.dart';

class CartItem {
  late Product product;
  late int quantity;

  CartItem({required this.product, required this.quantity});
}
