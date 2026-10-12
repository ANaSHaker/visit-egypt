import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() press;

  CustomListTile({
    this.text = "",
    required this.icon,
    required this.press,

  });

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title: Text(
        text,
        style: GoogleFonts.cairo(
            textStyle: TextStyle(
                fontSize:Get.locale == Locale('en', 'US')? 18 : 15,
                wordSpacing: 2,
                fontWeight: FontWeight.bold
            )),
      ),
      leading: Icon(
        icon,

      ),
      trailing: Icon(
        Icons.arrow_right,

      ),
      onTap:press,
    );
  }
}
