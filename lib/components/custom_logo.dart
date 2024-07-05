import 'package:flutter/material.dart';

class CutsomLogo extends StatelessWidget {
  double percent;
  CutsomLogo({required this.percent});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.18,
      child: Image(
        image: AssetImage('images/logo/metic_red_p.png'),
      ),
    );
  }
}
