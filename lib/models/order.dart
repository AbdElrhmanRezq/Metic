class MyOrder {
  late String address;
  late String phone;
  late String name;
  late String additional;
  late String totalPrice;
  late String state;
  late String docId;
  late String email;
  late String deliveryAddress;

  MyOrder(
      {required this.address,
      required this.phone,
      required this.totalPrice,
      required this.state,
      required this.name,
      required this.additional,
      required this.docId,
      required this.email,
      required this.deliveryAddress});
}
