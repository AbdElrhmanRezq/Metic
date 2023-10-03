import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crescendo/components/custom_list_tile.dart';
import 'package:crescendo/components/custom_logout_button.dart';
import 'package:crescendo/consts.dart';
import 'package:crescendo/services/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Store _store = Store();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<MyUser> getUserData() async {
    DocumentSnapshot userDoc =
        await _store.getUserByEmail(_auth.currentUser?.email as String);

    Map<String, dynamic> userDetails = userDoc.data() as Map<String, dynamic>;
    MyUser user = MyUser(
        name: userDetails[KUserName],
        email: userDetails[KUserEmail],
        address: userDetails[KUserAddress],
        phone: userDetails[KUserPhone]);
    return user;
  }

  void editUserDetails(name, email, phone, address) {
    MyUser user =
        MyUser(name: name, email: email, address: address, phone: phone);
    Navigator.of(context).pushNamed('edit-user', arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  color: Theme.of(context).colorScheme.background,
                  width: double.infinity,
                  child: ListView(
                    children: [
                      CustomListTile(
                          description: snapshot.data?.email as String,
                          title: "Email"),
                      CustomListTile(
                          description: snapshot.data?.name as String,
                          title: "Name"),
                      CustomListTile(
                          description: snapshot.data?.address as String,
                          title: "Address"),
                      CustomListTile(
                          description: snapshot.data?.phone as String,
                          title: "Phone"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomLogoutButton(),
                          IconButton(
                              onPressed: () {
                                editUserDetails(
                                  snapshot.data?.name as String,
                                  snapshot.data?.email as String,
                                  snapshot.data?.phone as String,
                                  snapshot.data?.address as String,
                                );
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      )
                    ],
                  ));
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
