import 'package:visit_egypt/config/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';


class ProblemUsScreen extends StatefulWidget
{

  @override
  _ProblemUsScreenState createState() => _ProblemUsScreenState();
}

class _ProblemUsScreenState extends State<ProblemUsScreen>
{
  var _emailFormKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  @override
  // ignore: must_call_super
  void initState() {
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 10;
        print(controller.offset);
      });
    });
/*
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scaffoldKey.currentState.showSnackBar( SnackBar(content: Text("priceUpdated".tr,textAlign: TextAlign.center,),
      backgroundColor: Colors.red.shade800,)));*/
  }

  @override
  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: width,
              alignment: Alignment.topCenter,
              height: closeTopContainer ? 0 : 350,
              child: ListView(
                children: [
                  Container(
                    height: 100,
                    child: ListTile(
                        title: Text(
                          "problemForUs".tr,
                          style: GoogleFonts.cairo(
                              color: primaryColor,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(
                          "problemDes".tr,
                          style: GoogleFonts.cairo(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                          ],
                        )
                    ),
                  ),
                  Image.asset(
                    "assets/sendMessage.png",
                    height: 140,
                    alignment: Alignment.bottomLeft,
                  ),
                ],
              ),
            ),

            Container(
              width: 200,
              child: Form(
                key: _emailFormKey,
                child: Column(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                      child: TextFormField(
                        maxLines: 10,
                        controller: messageController,

                        validator: (value){
                          if(value!.isEmpty) {
                            return "enterProblem".tr;
                          }
                        },
                        decoration: InputDecoration(
                            fillColor:Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                            filled: true,

                            labelText: "sendMessage".tr,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: RaisedButton(
                          color: primaryColor,
                          child: Text("Send".tr,style: TextStyle(color: Colors.white),), onPressed: ()async {

                        if(_emailFormKey.currentState!.validate()){
                          sendMessage();
                        }
                      }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  void sendMessage(){
    String inputEmail = "" ;
    String inputMessage = "";
    Email email ;
    setState(() {
      inputEmail= Env.supportEmail;
      inputMessage = messageController.text;
      if(inputMessage.isNotEmpty&&inputEmail.isNotEmpty) {
        email = Email(
          body: inputMessage,
          subject: 'EmailSubject'.tr,
          recipients: [inputEmail],
        );
        send(email);
      }

    });
    debugPrint('email - > $inputEmail  message -> $inputMessage');

  }
  void send(Email email) async {
    await FlutterEmailSender.send(email);
  }
}
