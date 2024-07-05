import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../consts.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          children: [
            Container(
                height: height * 0.3,
                child: Image.asset("images/logo/metic_red_p.png")),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height * 0.5,
                    width: 0.88 * width,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 34, 34, 34),
                        borderRadius:
                            BorderRadius.circular(KBorderRadiusPages)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            "Metic is an idea of an E-Commerce app initially intended for selling cosmetics.\n\nThis application has gone through development from the UI to integration with Firebase, ready to host any local business.",
                            style: TextStyle(fontSize: height * 0.022),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  final Uri url = Uri.parse(
                                      'https://github.com/AbdElrhmanRezq/crescendo');
                                  if (!await launchUrl(url)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Couldn't Open link")));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        height: height * 0.02,
                                        child:
                                            Image.asset("images/github.png")),
                                    Text("See the code in github")
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
