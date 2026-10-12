// import 'package:firebase_chat_example/model/user.dart';
// import 'profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_egypt/constants/constants.dart';

import '../Widgets/messages_widget.dart';
import '../Widgets/new_message_widget.dart';
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:Theme.of(context).brightness == Brightness.dark ?Colors.grey[900] :primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(

              height: 80,
              padding: EdgeInsets.all(16).copyWith(left: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BackButton(color: Colors.white),
                      Expanded(
                        child: Text(
                          "Chat".tr,
                          style: GoogleFonts.cairo(
                              color:  Theme.of(context).brightness == Brightness.dark ?primaryColor:Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4),
                    ],
                  )
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/blackLogo.png"),
                    colorFilter: Theme.of(context).brightness == Brightness.dark ? ColorFilter.mode(Colors.grey.shade800.withOpacity(0.2), BlendMode.dstATop)
                    :  ColorFilter.mode(Colors.grey.shade100.withOpacity(0.2), BlendMode.dstATop),
                  ),
                  color: Theme.of(context).brightness == Brightness.dark ?Colors.grey[800] :Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: MessagesWidget(idUser: "9OkAwTgpsAeLishqCuk6TSJWigD2"),
              ),
            ),
            NewMessageWidget(idUser: "9OkAwTgpsAeLishqCuk6TSJWigD2")
          ],
        ),
      ),
    );

  }
}
