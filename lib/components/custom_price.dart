import 'package:flutter/material.dart';

class CustomPrice extends StatelessWidget {
  final String initPrice;
  final String iDiscount;
  final int size;

  const CustomPrice(
      {required this.initPrice, required this.iDiscount, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Row(
        children: [
          Text(
            "EGP",
            style: TextStyle(fontSize: size.toDouble(), color: Colors.grey),
          ),
          Builder(builder: (context) {
            if (iDiscount != "null") {
              double price = double.parse(initPrice as String);
              double discount = double.parse(iDiscount as String);
              double finalPrice = price - discount;
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " ${finalPrice}",
                    style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough),
                  ),
                  Text(
                    " ${finalPrice}",
                    style: TextStyle(color: Colors.white, fontSize: size * 1.5),
                  )
                ],
              );
            } else {
              return Text(
                " ${initPrice as String}",
                style: TextStyle(fontSize: size * 1.5),
              );
            }
          }),
        ],
      ),
    );
  }
}
