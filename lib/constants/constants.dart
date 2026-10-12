import 'package:flutter/material.dart';
import 'package:visit_egypt/constants/size_config.dart';

const primaryColor =   Color(0xFF1976D2);
const kPrimaryColor2 = Color(0xFF0D47A1);
const shadowColor =  Color(0xFF42A5F5);
const darkColor = Color(0xff212121);
const whiteColor = Colors.white;
const blackColor = Colors.black;
const greyColor = Colors.grey;
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

final headingStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  height: 1.5,
);
bool enableNotification = true;

const double screenPadding = 10;
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String FIELD_REQUIRED_MSG = "This field is required";
const kPrimaryGradientColor = LinearGradient(
  colors: [ Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5),],

);