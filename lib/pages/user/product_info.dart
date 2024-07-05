import 'package:crescendo/components/custom_bottom_sheet.dart';
import 'package:crescendo/components/custom_para.dart';
import 'package:crescendo/components/custom_price.dart';
import 'package:crescendo/consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../components/custom_appbar.dart';
import '../../components/custom_colored_label.dart';
import '../../models/cart.dart';
import '../../models/product.dart';
import '../../models/product_multi_photos.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductInfo extends StatefulWidget {
  static final String id = 'product-info';
  int currentImage = 0;
  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    MultiProduct _product =
        ModalRoute.of(context)!.settings.arguments as MultiProduct;

    void showMySheet(String text) {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return CustomButtomSheet(textMessage: text, height: height);
        },
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text(_product.name as String)),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(KBorderRadiusPages)),
        child: Stack(children: [
          ListView(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: FadeInImage.assetNetwork(
                  placeholder: 'images/holders/logo.jpg',
                  image: _product.imageUrls?[widget.currentImage] as String,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: height * 0.1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _product.imageUrls?.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.currentImage = index;
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(KBorderRadius),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'images/logo/metic_red_p.png',
                            image: _product.imageUrls?[index] as String,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _product.name as String,
                        style: TextStyle(fontSize: 20),
                      ),
                      CustomPrice(
                        initPrice: _product.price as String,
                        iDiscount: _product.discount == null
                            ? "null"
                            : _product.discount as String,
                        size: 18,
                      )
                    ]),
              ),
              CustomParagraph(
                  title: "Describtion",
                  description: _product.description as String),
              SizedBox(
                height: height * 0.2,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: height * 0.05),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)),
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
                              showMySheet(response);
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
          ),
        ]),
      ),
    );
  }
}


/*
CarouselSlider.builder(
                        itemCount: _product.imageUrls?.length,
                        itemBuilder: (context, index, realIndex) {
                          final imageUrl = _product.imageUrls?[index];
                          return buildImage(imageUrl, index);
                        },
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          },
                        ),
                      )
*/ 