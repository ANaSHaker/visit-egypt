import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'SplashScreen.dart';
class ErrorPage extends StatefulWidget {

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       body: Container(
         margin: EdgeInsets.all(10),
         padding: EdgeInsets.all(20),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Center(
               child: Container(
                 height: 150,
                 width:150,
                 child: Icon(Icons.wifi_off,size: 150,),
               ),
             ),
             SizedBox(height: 100,),
             Text(
               "NoInternetConnection".tr,
               style: TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
               ),
             ),
             Padding(
               padding: EdgeInsets.all(15),
               child: Text(
                 "Youarenotconnectedtotheinternet".tr,
                 style: TextStyle(
                   fontSize: 16,
                 ),
               ),
             ),
             SizedBox(height: 30,),
             Container(
                 height: 40,
                 width: 130,
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey)
                 ),
                 child: TextButton(onPressed: (){
                   Navigator.pushReplacement(
                       context, MaterialPageRoute(builder: (context) => SplashPage()));
                 }, child: Text("reconnect".tr,style: TextStyle(fontWeight: FontWeight.bold),)))
           ],
         ),
       ),
     );
  }
}
