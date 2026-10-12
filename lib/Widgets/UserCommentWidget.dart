import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:visit_egypt/Screens/events/cubit/cubit.dart';
import 'package:visit_egypt/Services/database/user_database_helper.dart';
import 'package:visit_egypt/constants/constants.dart';
import 'package:get/get.dart';

import 'PopMenuItem.dart';
Widget buildDisplayPictureAvatar(BuildContext context,int? commentId,String? comment,Function(TapUpDetails) press) {
  return StreamBuilder<DocumentSnapshot>(
    stream: UserDatabaseHelper().currentUserDataStream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        /* final error = snapshot.error;
          Logger().w(error.toString());*/
      }
      ImageProvider? backImage;
      String url = "";
      String name = "";
      if (snapshot.hasData && snapshot.data != null) {
        url = snapshot.data![UserDatabaseHelper.DP_KEY].toString();
        name = snapshot.data![UserDatabaseHelper.Name_KEY].toString();

        if (url != "") backImage = NetworkImage(url);
      }
      return InkWell(
          onTap: (){

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      backImage != null ? CircleAvatar(
                        radius: 15,
                        backgroundColor: kTextColor.withOpacity(0.5),
                        backgroundImage: backImage ,
                      ): CircleAvatar(
                        radius: 15,
                        child:Icon(Icons.person_outlined,size: 20,),
                      ),
                      SizedBox(width: 8,),
                      Text(name != "" ? name : ""),
                    ],
                  ),

                  Row(
                    children: [
                      GestureDetector(child: Icon(Icons.more_vert),onTapUp: press,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Text(comment!,style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),)
            ],
          )
      );
    },
  );
}

Widget buildUnknownUser(name,BuildContext context,String? comment,Function(TapUpDetails) press) {

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 15,
              child:Icon(Icons.person,size: 20,),
            ),
            SizedBox(width: 10,),
            Text(name ??"username"),

          ],

        ),

      ],
    ),
      SizedBox(height: 5,),
      Text(comment!,style: GoogleFonts.cairo(
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.bold
      ),)
    ],
  );
}

void showPopup(Offset offset,Callback delete ,Callback update) {
  PopupMenu menu = PopupMenu(
    // backgroundColor: Colors.teal,
    // lineColor: Colors.tealAccent,
      maxColumn: 2,
      items: [
        MenuItem(title: 'Update'.tr, image: Icon(Icons.edit, color: Colors.white)),
        MenuItem(title: 'Delete'.tr,image: Icon(Icons.delete, color: Colors.white,)),
      ],
      onClickMenu: (MenuItemProvider item) {
    if(item.menuTitle == 'Update'.tr){
      update();
    }else if (item.menuTitle == 'Delete'.tr){
      delete();
    }
  },
      stateChanged: stateChanged,
      onDismiss: onDismiss);
  menu.show(rect: Rect.fromPoints(offset, offset));
}

void stateChanged(bool isShow) {
  print('menu is ${isShow ? 'showing' : 'closed'}');
}

void onClickMenu(MenuItemProvider item) {
  print('Click menu -> ${item.menuTitle}');
}

void onDismiss() {
  print('Menu is dismiss');
}