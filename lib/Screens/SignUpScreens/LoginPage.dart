import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'SignUpPage.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'forgetPasswordPage.dart';
const kKeepMeLoggedIn = 'KeepMeLoggedIn';

class LoginPage extends StatefulWidget
{

  @override
  _LoginPageState createState() => _LoginPageState();

}
int check= 0;

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin
{
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  bool islogged = false;
  late SharedPreferences sharedPreferences;

  bool keepMeLoggedIn =false;
  void init()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    check = (await prefs.getInt("initScreen"))!;
    await prefs.setInt("initScreen", 1);
    print('initScreen ${check}');

  }
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
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
  void initState()
  {
    super.initState();
    // isSigned();

  }

  @override
  Widget build(BuildContext context)
  {
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
              return  Scaffold(
      resizeToAvoidBottomInset: true,
      body:loading? LoadingScreen() :
      Stack(
          children: [
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
              child: ListView(
                children: [
                  SizedBox(
                    height: 110,
                  ),
                  Text(
                    'WelcomeBack'.tr,
                    style:GoogleFonts.cairo(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text("Egypt is not a country we live in but a country that lives within us".tr,  style:GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white),
                  ),
                  SizedBox(height: 62),


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
                        hintStyle:GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.grey),
                        suffixIcon:  Icon( Icons.email_outlined ,color: Colors.grey,),

                      ),
                      validator: (value)
                      {
                        return value!.isEmpty ? "Enteryouremail".tr : null;
                      },
                      onSaved: (val)
                      {
                        email = val!;
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(color: Colors.black54),
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: _obscureText,
                      style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),

                      decoration: InputDecoration(
                        border: InputBorder.none,

                        hintText: "Password".tr,
                        hintStyle:GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.grey),
                        suffixIcon: IconButton(icon: Icon(_obscureText == true ? Icons.visibility : Icons.visibility_off,color: Colors.grey,),
                          onPressed: _toggle,
                        ),
                      ),
                      validator: (value)
                      {
                        return value!.isEmpty ? "EnterNewPassword".tr : null;
                      },
                      onSaved: (val)
                      {
                        pass = val!;
                      },
                    ),
                  ),


                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: (){
                        Get.to(()=>ResetScreen());
                      },
                      child: Text(
                        'ForgotPassword'.tr,
                        style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),

                  MaterialButton(
                      onPressed: () {
                        login();
                      },
                      minWidth: double.maxFinite,
                      color: primaryColor,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'SIGNIN'.tr,
                          style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      )),


                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            handlesigning(context);
                          },
                          child: Container(
                            height: 50,
                            width: 160,

                            decoration:
                            BoxDecoration(border: Border.all(color: Colors.white)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.google, color: Colors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    'loginGmail'.tr,
                                    style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)
                                ),
                              ],
                            ),
                          ),
                        ),
                        //////////////////////////////////////////////////////////////////////////
                        InkWell(
                          onTap: (){
                            loginWithFacebook(context);

                          },
                          child: Container(
                            height: 50,
                            width: 160,
                            decoration:
                            BoxDecoration(border: Border.all(color: Colors.white)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.facebookF, color: Colors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    'loginFacebook'.tr,
                                    style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                            } ,
                            child: Text(
                              "don'thaveaccount?SignUp".tr,
                              style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ))),

                ],
              ),
            ),
          ),
        ),
      ]),
    );}));

  }
  //*******************************************************************
  void isSigned() async
  {
    setState(()
    {
      loading = true;
    });
    islogged = await googleSignIn.isSignedIn();

    sharedPreferences = await SharedPreferences.getInstance();
    if (islogged)
    {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavigation()),
              (Route<dynamic> route) => false);}
    setState(()
    {
      loading = false;
    });
  }
  Future<void> login() async
  {
    final formstate = formkey.currentState;
    if (formstate!.validate())
    {
      formstate.save();
      try
      {
        sharedPreferences = await SharedPreferences.getInstance();
        setState(()
        {
          loading = true;
        });
        final User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
        )).user!;
        user!.updateDisplayName(name);
        if (user != null)
        {
          FirebaseFirestore.instance.collection('users')
              .doc('${user.uid}')
              .get()
              .then((DocumentSnapshot ds) {
            if(!ds.exists)
            {
              FirebaseFirestore.instance.collection("users").doc(user.uid).update({
                "id": user.uid,
                "display_picture": user.photoURL,
                "email":user.email,
                "name":user.displayName,
                "phone":user.phoneNumber,
              });

              sharedPreferences.setString("id", user.uid);
            }
            else{
              sharedPreferences.setString("id", ds["id"]);
            }
          });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavigation()),
                  (Route<dynamic> route) => false);setState(()
          {
            loading = false;
          });
        }
      }
      catch(PlatformException)
      {
        setState(() {
          showToast(
            PlatformException.toString().contains("ERROR_USER_NOT_FOUND")
                ? "ERROR_USER_NOT_FOUND"
                : PlatformException.toString(),
            borderRadius: BorderRadius.circular(5),
            context: context,
            animation: StyledToastAnimation.scale,
            reverseAnimation: StyledToastAnimation.fade,
            animDuration: Duration(milliseconds: 250),
          );
        });

        setState(()
        {
          loading = false;
        });
      }
    }
  }
  Future handlesigning(context) async
  {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(()
    {
      loading = true;
    });
    try
    {
      GoogleSignInAccount? googleaccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleautha = await googleaccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleautha.accessToken,
        idToken: googleautha.idToken,
      );
      final User? user = (await auth.signInWithCredential(credential)).user;
      if (user != null)
      {
        FirebaseFirestore.instance.collection('users').doc('${user.uid}')
            .get()
            .then((DocumentSnapshot ds) {
          if(!ds.exists)
          {
            FirebaseFirestore.instance.collection("users").doc(user.uid).set({
              "id": user.uid,
              "display_picture": user.photoURL,
              "email":user.email,
              "name":user.displayName,
              "phone":user.phoneNumber,

            });
            setState(() {
              print("FromAPii");
              userCubit.get(context).postUser(
                  firebase_id: user.uid,
                  name: name,
                  email: user.email
              );
            });
            sharedPreferences.setString("id", user.uid);
          }
          else
          {
            sharedPreferences.setString("id", ds["id"]);
          }
        });

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavigation()),
                (Route<dynamic> route) => false);
        setState(()
        {
          loading = false;
        });
      }
      else
      {
        setState(()
        {
          showToast(
            "فشل تسجيل الدخول",
            borderRadius: BorderRadius.circular(5),
            context: context,
            animation: StyledToastAnimation.scale,
            reverseAnimation: StyledToastAnimation.fade,
            animDuration: Duration(milliseconds: 250),
          );

          loading = false;
        });
      }
    }
    catch(e)
    {
      showToast(
        e.toString(),
        borderRadius: BorderRadius.circular(5),
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );      setState(()
      {
        loading=false;
      });
    }
  }

  Future loginWithFacebook(context) async{
    FacebookLogin log = FacebookLogin();
    var result = await log.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email]);
    var accessToken = result.accessToken!.token;
    if(result.status == FacebookLoginStatus.success){
      var token = FacebookAuthProvider.credential(accessToken);
      (auth.signInWithCredential(token)).then((value) {
        if (value.user != null)
        {
          FirebaseFirestore.instance.collection('users').doc('${value.user!.uid}')
              .get()
              .then((DocumentSnapshot ds) {
            if(!ds.exists)
            {
              FirebaseFirestore.instance.collection("users").doc(value.user!.uid).set({
                "id": value.user!.uid,
                "display_picture": value.user!.photoURL,
                "email":value.user!.email,
                "name":value.user!.displayName,
                "phone":value.user!.phoneNumber,

              });
              setState(() {
                print("FromAPii");
                userCubit.get(context).postUser(
                    firebase_id: value.user!.uid,
                    name: name,
                    email: value.user!.email
                );
              });
              sharedPreferences.setString("id", value.user!.uid);
            }
            else
            {
              sharedPreferences.setString("id", ds["id"]);
            }
          });

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavigation()),
                  (Route<dynamic> route) => false);
          setState(()
          {
            loading = false;
          });
        }
        else
        {
          setState(()
          {
            showToast(
              "فشل تسجيل الدخول",
              borderRadius: BorderRadius.circular(5),
              context: context,
              animation: StyledToastAnimation.scale,
              reverseAnimation: StyledToastAnimation.fade,
              animDuration: Duration(milliseconds: 250),
            );

            loading = false;
          });
        }
      });
    }
  }

}