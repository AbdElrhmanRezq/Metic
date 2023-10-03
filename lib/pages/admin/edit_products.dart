import 'package:crescendo/consts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../components/custom_textfield.dart';
import '../../models/product.dart';
import '../../services/store.dart';

class EditProduct extends StatelessWidget {
  static final String id = 'edit-product';
  late String _name, _price, _location, _description;
  var path, name;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    selectPhoto() async {
      final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          allowedExtensions: ['png', 'jpg', 'jpeg'],
          type: FileType.custom);
      if (result == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No file selected")));
      }
      path = result?.files.single.path;
      name = result?.files.single.name;
    }

    Product _product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      body: Form(
        key: _key,
        child: SafeArea(
            child: Center(
          child: ListView(
            children: [
              SizedBox(height: 90),
              CustomTextField(
                hint: "Name",
                onClick: (value) {
                  _name = value as String;
                },
              ),
              SizedBox(height: 10),
              CustomTextField(
                hint: "Price",
                onClick: (value) {
                  _price = value as String;
                },
              ),
              SizedBox(height: 10),
              CustomTextField(
                hint: "Description",
                onClick: (value) {
                  _description = value as String;
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    print("Tab");
                    selectPhoto();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(KBorderRadius)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          "Select Photo",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () async {
                    if (_key.currentState?.validate() ?? true) {
                      String imageUrl = await _store.uploadPhoto(name, path);
                      _key.currentState?.save();
                      _store.editProduct(
                          ({
                            KProductName: _name,
                            KProductPrice: _price,
                            KProductDescription: _description,
                            KProductImageUrl: imageUrl,
                          }),
                          _product.id);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        "Edit product",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
