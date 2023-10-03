import 'package:crescendo/components/custom_textfield_new.dart';
import 'package:crescendo/consts.dart';
import 'package:crescendo/services/store.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class EditUser extends StatefulWidget {
  static final String id = 'edit-user';

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  void editUserDetails(email) async {
    Store _store = Store();
    _store.editUser({
      KUserName: _nameController.text,
      KUserAddress: _addressController.text,
      KUserPhone: _phoneController.text,
    }, email);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    MyUser _user = ModalRoute.of(context)?.settings.arguments as MyUser;
    _nameController.text = _user.name;
    _addressController.text = _user.address;
    _phoneController.text = _user.phone;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(KBorderRadiusPages)),
          child: ListView(
            children: [
              CustomTextFieldNew(hint: "Name", controller: _nameController),
              CustomTextFieldNew(
                  hint: "Address", controller: _addressController),
              CustomTextFieldNew(hint: "Phone", controller: _phoneController),
              GestureDetector(
                onTap: () {
                  editUserDetails(_user.email);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(KBorderRadius)),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
