import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/shared/network/local/cache_helper.dart';

import 'noInternet.dart';

// import 'package:intl/intl.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({ this.title = "Splash"});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State  with TickerProviderStateMixin{

  AnimationController? animationController;


  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    CacheHelper.saveData(key: "firstOpen", value: true);

    check().then((intenet) {
      if (intenet != null && intenet) {
        Timer(Duration(seconds: 4),
                ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation()))
        );
      }
      else {
        Timer(Duration(seconds: 4),
                ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ErrorPage()))
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    animationController!.repeat();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/egyptNight.jpg"),
          fit: BoxFit.fill,
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child:Image.asset("assets/blackLogo.png",width: 150,),
              ),
            ),
           Column(
             children: [
               RotationTransition(
                 turns: Tween(begin: 0.0, end: 1.0).animate(animationController!),
                 child: Image.asset('assets/keyLife.png', height: 50,width: 50,color: Colors.white,),
               ),
               Text("Visit Egypt",style: GoogleFonts.lobster(
                   color: Colors.white,
                   fontSize: 28,
                   fontWeight: FontWeight.bold),),
               SizedBox(height: 50,),
             ],
           )
          ],
        )
      )
    );
  }
}