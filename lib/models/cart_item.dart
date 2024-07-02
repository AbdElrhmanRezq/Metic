import 'package:crescendo/models/product.dart';
import 'package:crescendo/models/product_multi_photos.dart';

class CartItem {
  late MultiProduct product;
  late int quantity;

  CartItem({required this.product, required this.quantity});
}
