class OrderItem {
  late String price;
  late String name;
  late int quantity;
  String? discount;
  OrderItem(
      {required this.name,
      required this.price,
      required this.quantity,
      this.discount});
}
