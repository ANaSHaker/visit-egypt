
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_egypt/Screens/UpdateProfile/change_display_name_form.dart';
import 'package:visit_egypt/Screens/UpdateProfile/change_display_picture.dart';
import 'package:visit_egypt/Screens/UpdateProfile/change_email_form.dart';
import 'package:visit_egypt/Screens/UpdateProfile/change_password_form.dart';
import 'package:visit_egypt/Screens/UpdateProfile/change_phone_number_form.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';

ExpansionTile buildProfileTile(BuildContext context) {
  return ExpansionTile(
    leading: Icon(Icons.person),
    title: Text(
      "myProfile".tr,
      style: GoogleFonts.cairo(
          textStyle: TextStyle(
              fontSize:Get.locale == Locale('en', 'US')? 16 : 15,
              wordSpacing: 2,
              fontWeight: FontWeight.bold
          )),
    ),
    children: [
      ListTile(
        title: Text(
          "updateName".tr,
          style: TextStyle(
              wordSpacing: 2,
              fontWeight: FontWeight.bold
          ),
        ),
        onTap: () {
          Get.to(()=>ChangeDisplayNameForm());

        },
      ),
      ListTile(
        title: Text(
          "updateEmail".tr,
          style: TextStyle(
              wordSpacing: 2,
              fontWeight: FontWeight.bold
          ),
        ),
        onTap: () {
          Get.to(()=>ChangeEmailForm());

        },
      ),
      ListTile(
        title: Text(
          "updatePassword".tr,
          style: TextStyle(
              fontSize:Get.locale == Locale('en', 'US')? 16 : 15,
              wordSpacing: 2,
              fontWeight: FontWeight.bold
          ),
        ),
        onTap: () {
          Get.to(()=>ChangePasswordForm());

        },
      ),
      ListTile(
        title: Text(
          "updatePicture".tr,
          style: TextStyle(
              fontSize:Get.locale == Locale('en', 'US')? 16 : 15,
              wordSpacing: 2,
              fontWeight: FontWeight.bold
          ),
        ),
        onTap: () {
          Get.to(()=>ChangeDisplayPicture());

        },
      ),
      ListTile(
        title: Text(
          "updatePhone".tr,
          style: TextStyle(
              fontSize:Get.locale == Locale('en', 'US')? 16 : 15,
              wordSpacing: 2,
              fontWeight: FontWeight.bold
          ),
        ),
        onTap: () {
          Get.to(()=>ChangePhoneNumberForm());

        },
      ),
      ListTile(
        title: Text(
          "deleteAccount".tr,
          style: TextStyle(
              fontSize:Get.locale == Locale('en', 'US')? 16 : 15,
              wordSpacing: 2,
              fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async{
          await FirebaseFirestore.instance.collection("users").doc(uid).delete().then((_) async {
            User user =  FirebaseAuth.instance.currentUser!;
            await user.delete();
            Get.off(()=>BottomNavigation());
          });



        },
      ),
    ],
  );
}