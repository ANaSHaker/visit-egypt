import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../constants/constants.dart';


class DefaultButton extends StatelessWidget {
  final String text;
  final Callback press;

  const DefaultButton({
    required this.text,
    required this.press,


  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: const BoxDecoration(
          gradient: kPrimaryGradientColor,
          borderRadius: BorderRadius.all(Radius.circular(20))

        ),
        child: FlatButton(

          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
