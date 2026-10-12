import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'SignUpPage.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String? _email;
  final auth = FirebaseAuth.instance;
  bool loading = false;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        Positioned.fill(
            child: Image.asset(
              'assets/images/egypt1.jpg',
              fit: BoxFit.cover,
              color: Colors.black38,
              colorBlendMode: BlendMode.darken,
            )),
        Positioned(
            top: 50,
            left: 20,
            child: Image.asset("assets/keyLife.png",height: 40,color: Colors.white,)),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text(
                    'ForgotPassword'.tr,
                    style: GoogleFonts.cairo(
                        fontSize: 32,
                        color: Colors.white,
                    fontWeight: FontWeight.bold),
                  ),

                  SizedBox(
                    height: 100,
                  ),

                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.black54),

                    child: TextFormField(
                      style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email".tr,
                        hintStyle: GoogleFonts.cairo(
                            fontSize: 16,
                          color: Colors.grey,
                        ),
                        suffixIcon:  Icon( Icons.email_outlined ,color: Colors.grey,),

                      ),
                      validator: (value)
                      {
                        return value!.isEmpty ? "Enteryouremail".tr : null;
                      },
                      onSaved: (val)
                      {
                        _email = val!;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  MaterialButton(
                      onPressed: () {
                        auth.sendPasswordResetEmail(email: _email!);
                        setState(() {
                          showToast(
                            "تم ارسال كود استعادة الباسورد الي حسابك",
                            borderRadius: BorderRadius.circular(5),
                            context: context,
                            animation: StyledToastAnimation.scale,
                            reverseAnimation: StyledToastAnimation.fade,
                            animDuration: Duration(milliseconds: 250),
                          );
                        });
                        Navigator.of(context).pop();
                      },
                      minWidth: double.maxFinite,
                      color: primaryColor,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          "Send".tr,
                          style: GoogleFonts.cairo(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpPage()));

                            } ,
                            child: Text(
                              "createAccount".tr,
                              style: GoogleFonts.cairo(
                                  fontSize: 17,
                                  color: Colors.white,

                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ))),
                ],
              ),
            ),
          )),






                ],
              ),

    );
    /*Scaffold(
      body: Column(
        children: [
          Container(
            height: 380,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill
                )
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 30,
                  width: 80,
                  height: 200,
                  child: FadeAnimation(1, Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/light-1.png')
                        )
                    ),
                  )),
                ),
                Positioned(
                  left: 140,
                  width: 80,
                  height: 150,
                  child: FadeAnimation(1.3, Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/light-2.png')
                        )
                    ),
                  )),
                ),
                Positioned(
                  right: 40,
                  top: 40,
                  width: 80,
                  height: 150,
                  child: FadeAnimation(1.5, Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/clock.png')
                        )
                    ),
                  )),
                ),
                Positioned(
                  child: FadeAnimation(1.6, Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text("ForgotPassword".tr, style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                    ),
                  )),
                )
              ],
            ),
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
            ),
            visible: loading,
          ),
          Padding(
            padding: EdgeInsets.only(right:30.0,left:30),
            child: Column(
              children: <Widget>[
                FadeAnimation(1.8, Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Get.isDarkMode? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10)
                        )
                      ]
                  ),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: <Widget>[

                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5)))
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "email".tr,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              suffixIcon:  Icon( Icons.email_outlined ,color: Colors.grey,),

                            ),
                            validator: (value)
                            {
                              return value!.isEmpty ? "enterYourEmail".tr : null;
                            },
                            onSaved: (val)
                            {
                              _email = val!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                SizedBox(height: 30,),
                FadeAnimation(2, InkWell(
                  onTap: (){
                    auth.sendPasswordResetEmail(email: _email!);
                    Fluttertoast.showToast(msg: "تم ارسال كود استعادة الباسورد الي حسابك", toastLength: Toast.LENGTH_LONG);
                    Navigator.of(context).pop();                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ]
                        )
                    ),
                    child: Visibility(
                      child: Center(
                        child: Text("Send".tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                )),

                SizedBox(height: 15,),
                InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpPage()));

                    },
                    child: FadeAnimation(1.5, Text("createAccount".tr, style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),))),
              ],
            ),
          ),


        ],),
    );*/
  }

}