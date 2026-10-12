import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visit_egypt/Screens/SignUpScreens/cubit/cubit.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';
import 'cubit/states.dart';
import 'LoginPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {

  bool islogged = false;
  late SharedPreferences sharedPreferences;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String name = "";
  String pass = "";
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<userCubit>(
        create: (context) => userCubit(),
        child: BlocConsumer<userCubit,UserSignStates>(
          listener: (context, state) {
            if(state is postUserSuccessState)
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (BuildContext context) => BottomNavigation()),
                      (Route<dynamic> route) => false);
            setState(() {
              loading = false;
            });
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body:loading?LoadingScreen(): Stack(children: [
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
                    child: Image.asset(
                      "assets/keyLife.png", height: 40, color: Colors.white,)),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Form(
                      key: formkey,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 90,
                          ),
                          Text(
                            'registerNow'.tr,
                            style: GoogleFonts.cairo(
                                fontSize: 32,
                                color: Colors.white,

                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'SignuptoContinue'.tr,
                            style: GoogleFonts.cairo(
                              fontSize: 23,
                              color: Colors.white,

                            ),
                          ),
                          SizedBox(
                            height: 50,
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
                                  hintText: "name".tr,

                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Icon(
                                    Icons.person_outline, color: Colors.grey,),

                                ),
                                validator: (value) {
                                  return value!.isEmpty
                                      ? "EnterYourName".tr
                                      : null;
                                },
                                onSaved: (val) {
                                  name = val!;

                                }
                            ),
                          ),
                          SizedBox(height: 20,),
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
                                suffixIcon: Icon(
                                  Icons.email_outlined, color: Colors.grey,),

                              ),
                              validator: (value) {
                                return value!.isEmpty
                                    ? "Enteryouremail".tr
                                    : null;
                              },
                              onSaved: (val) {
                                email = val!;
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            decoration: BoxDecoration(color: Colors.black54),
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                border: InputBorder.none,

                                hintText: "Password".tr,
                                hintStyle: GoogleFonts.cairo(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(icon: Icon(
                                  _obscureText == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,),
                                  onPressed: _toggle,
                                ),
                              ),
                              validator: (value) {
                                return value!.isEmpty
                                    ? "EnterNewPassword".tr
                                    : null;
                              },
                              onSaved: (val) {
                                pass = val!;
                              },
                            ),
                          ),


                          SizedBox(
                            height: 20,
                          ),

                          MaterialButton(
                              onPressed: () {
                                register(context);
                              },
                              minWidth: double.maxFinite,
                              color: primaryColor,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0),
                                child: Text(
                                  'SIGNUp'.tr,
                                  style: GoogleFonts.cairo(
                                      fontSize: 18,
                                      color: Colors.white,

                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(height: 50,),
                          Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    },
                                    child: Text(
                                      "backToLogin".tr,
                                      style: GoogleFonts.cairo(
                                          fontSize: 16,
                                          color: Colors.white,

                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            );
          },
        ));
  }

  register(context) async
  {
    final formstate = formkey.currentState;
    if (formstate!.validate()) {
      formstate.save();
      try {
        sharedPreferences = await SharedPreferences.getInstance();
        setState(() {
          loading = true;
        });
        User? user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass))
            .user!;
        user.updateDisplayName(name);

        if (user != null) {
          FirebaseFirestore.instance.collection('users')
              .doc('${user.uid}')
              .get()
              .then((DocumentSnapshot ds) {
            if (!ds.exists) {
              FirebaseFirestore.instance.collection("users").doc(user.uid).set({
                "id": user.uid,
                "display_picture": user.photoURL,
                "email": user.email,
                "name": name,
                "phone": user.phoneNumber,
              });
                userCubit.get(context).postUser(
                    firebase_id: user.uid,
                    name: name,
                    email: user.email
                );
              /*  Firestore.instance.collection("users").document(user.uid).collection("Status").document().setData({
                "status" : null
              });*/

              sharedPreferences.setString("id", user.uid);

            }
            else {
              showToast(
                "You already have account enter email and password to sign in",
                borderRadius: BorderRadius.circular(5),
                context: context,
                animation: StyledToastAnimation.scale,
                reverseAnimation: StyledToastAnimation.fade,
                animDuration: Duration(milliseconds: 250),
              );
            }
          });
        }
      }
      catch (PlatformException) {
        showToast(
          PlatformException.toString(),
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 250),
        );
        setState(() {
          loading = false;
        });
      }
    }
  }
}