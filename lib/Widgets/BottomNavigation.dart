
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_egypt/Screens/Culture/CultureMainScreen.dart';
import 'package:visit_egypt/Screens/chat_screen.dart';
import 'package:visit_egypt/Screens/events/EventsScreen.dart';
import 'package:visit_egypt/Screens/inEgypt/EgyptCitiesScreen.dart';
import 'package:visit_egypt/Screens/settingScreen.dart';

import '../constants/constants.dart';
import 'home_screen_drawer.dart';

String uid = "";
String userName = "";

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  String? name,photourl,email;
  Map<String,dynamic>? map;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> getUser() async
  {
    return await _auth.currentUser;
  }
  @override
  void initState()
  {
    super.initState();
    getUser().then((user)
    {
      if (user != null)
      {
        setState(()
        {
          uid = user.uid;
          userName = user.displayName!;
        });
      }
    });

  }
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    EventsScreen(),
    CultureMainScreen(),
    CitiesScreen(),
    SettingScreen(),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title:Text("Visit Egypt",  style: GoogleFonts.cairo(
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold),),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(onPressed:uid != "" ? ()=> Get.to(()=>ChatPage())
       : (){
        showToast(
          "سجل الدخول اولا",
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 250),
        );
      },
                child: Image.asset("assets/chatIcon.png",width: 27,color: primaryColor,),),
          ],
          leading:IconButton(onPressed: ()=>_scaffoldKey.currentState!.openDrawer(),
              icon: Icon(Icons.menu ,size: 28,color: primaryColor,)
          )
      ),

      drawer: HomeScreenDrawer(),
      // floatingActionButton: _selectedIndex != 3? FloatingActionButton(
      //   onPressed: uid != "" ?(){
      //     Get.to(()=>ChatPage());
      //   } : (){
      //     showToast(
      //       "سجل الدخول اولا",
      //       borderRadius: BorderRadius.circular(5),
      //       context: context,
      //       animation: StyledToastAnimation.scale,
      //       reverseAnimation: StyledToastAnimation.fade,
      //       animDuration: Duration(milliseconds: 250),
      //     );
      //   },
      //   child: Icon(Icons.chat_rounded ),
      //   backgroundColor: primaryColor,
      // ) : Container(),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:  BottomNavigationBar(
        elevation: 10,
        selectedLabelStyle: TextStyle( fontSize: Get.locale == Locale('en', 'US') ? 10 : 12),
        unselectedLabelStyle: TextStyle(fontFamily: "Soleil"),
        currentIndex: _selectedIndex,

        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.event),
            ),
            label: "explore".tr,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(FontAwesomeIcons.book,size: 17,),
            ),
            label: "egyptCulture".tr,

          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.location_city),
            ),
            label: "inEgypt".tr,
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.settings),
              ),
              label: "setting".tr),
        ],
      ),

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}