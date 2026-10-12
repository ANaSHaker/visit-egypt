import 'package:visit_egypt/config/env.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Components/ProfileTile.dart';
import 'package:visit_egypt/Components/custom_dialog.dart';
import 'package:visit_egypt/Components/custom_listTile.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/Widgets/tile_button.dart';
import 'package:visit_egypt/controller/app_theme.dart';
import 'package:visit_egypt/shared/network/local/cache_helper.dart';

import '../constants/constants.dart';
import 'SignUpScreens/LoginPage.dart';
import 'problemUsScreen.dart';




_launchWhatsApp() async {
  String phoneNumber = Env.supportWhatsApp;
  String message = 'السلام عليكم';
  var whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$message";
  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl);
  } else {
    throw 'Could not launch $whatsappUrl';
  }
}

Future launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: true, forceWebView: true);
  } else {
    print("Can't Launch $url");
  }
}
bool _notification = true;

class SettingScreen extends StatefulWidget {

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {



  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid="";



  checkNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = prefs.getInt(key) ?? 1;
    if (value == 1) {
      setState(() {
        _notification = true;
        enableNotification = true;
      });
    } else {
      setState(() {
        _notification = false;
        enableNotification = false;
      });
    }
  }
  saveLanguage(bool val) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isArabic", val);

  }

  saveNotificationSetting(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = val ? 1 : 0;
    prefs.setInt(key, value);
    if (value == 1) {
      setState(() {
        _notification = true;
        enableNotification =true;
      });
    } else {
      setState(() {
        _notification = false;
        enableNotification = false;
      });
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => BottomNavigation()));
    });
  }

  Future<User?> getUser() async
  {
    return  _auth.currentUser;
  }
  @override
  void initState()
  {
    super.initState();
    checkNotificationSetting();
    getUser().then((user)
    {
      if (user != null)
      {
        setState(()
        {
          uid = user.uid;
        });

      }
    });

  }
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);


    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          ringColor: shadowColor,
          fabColor: primaryColor,

          key: fabKey,
          // Cannot be `Alignment.center`
          alignment: Get.locale == Locale('en', 'US') ? Alignment.bottomRight:Alignment.bottomLeft,
          ringDiameter:400.0,
          ringWidth: 80.0,
          fabSize:60.0,
          fabElevation: 8.0,
          fabMargin: const EdgeInsets.all(32.0),
          animationDuration: const Duration(milliseconds: 400),
          animationCurve: Curves.easeInOutCirc,
          onDisplayChange: (isOpen) {},
          children: <Widget>[

            RawMaterialButton(
              onPressed: () {
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(
                FontAwesomeIcons.facebook,
                color: Colors.white,
              ),
            ),
            RawMaterialButton(
              onPressed: () {
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(
                FontAwesomeIcons.twitter,
                color: Colors.white,

              ),
            ),
            RawMaterialButton(
              onPressed: () {

              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(
                FontAwesomeIcons.instagram,
                color: Colors.white,

              ),
            ),
            RawMaterialButton(
              onPressed: () {
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(
                FontAwesomeIcons.tiktok,
                color: Colors.white,

              ),
            ),
            RawMaterialButton(
              onPressed: () {
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(
                FontAwesomeIcons.youtube,
                color: Colors.white,

              ),
            )
          ],
        ),
      ),
      body:NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 180,
              floating: false,
              pinned: true,
              flexibleSpace: new FlexibleSpaceBar(
                background:Image.asset(Theme.of(context).brightness == Brightness.dark ? "assets/blackLogo.png":"assets/whiteLogo.png",fit: BoxFit.fill,),

                /*  title: Text("setting".tr ,
                  style: GoogleFonts.cairo(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                  textAlign: TextAlign.center,

                ),*/
              ),
            )
          ];
        },

        body: SafeArea(
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                uid != "" ? buildProfileTile(context) : Container(),

                ListTile(
                  title: Text(
                    "enableNotification".tr,
                    style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            fontSize:Get.locale == Locale('en', 'US')? 18 : 15,
                            wordSpacing: 2,
                            fontWeight: FontWeight.bold
                        )),
                  ),
                  leading: Icon(
                    Icons.notifications,

                  ),
                  trailing: Switch(
                      onChanged: (val) async {
                        await saveNotificationSetting(val);
                      },
                      value: _notification
                  ),
                ),
                ListTile(
                    title: Text(
                      Theme.of(context).brightness == Brightness.dark ?  "lightMode".tr : "darkMode".tr,
                      style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              fontSize:Get.locale == Locale('en', 'US')? 18 : 15,
                              wordSpacing: 2,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                    leading: Icon(
                      Icons.color_lens,

                    ),
                    trailing: Switch(
                      value: themeChange.darkTheme,
                      onChanged: (value) {
                        setState(() {
                          themeChange.darkTheme = value;
                        });
                      },
                    )),
                CustomListTile(
                  text: "changeLanguage".tr,
                  icon: Icons.public,
                  press:() async {
                    return   showDialog(context: context,
                        builder: (_) =>Container(
                          child: AlertDialog(
                              title:  ListTile(
                                title:Text("changeLanguage".tr,textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      )),),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      child: Text("English",  style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: primaryColor
                                          )),),
                                      onPressed: ()async{
                                        Get.updateLocale(Locale('en','US'));
                                        saveLanguage(false);

                                      },
                                    ),
                                    TextButton(
                                      child: Text("Arabic",  style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: primaryColor
                                          )),),
                                      onPressed: ()async{
                                        Get.updateLocale(   Locale('ar','DZ'));
                                        saveLanguage(true);
                                      },
                                    ),
                                  ],
                                ),

                              )
                          ),
                        ));

                  },
                ),

                CustomListTile(
                  text: "aboutApp".tr,
                  icon: Icons.info,
                  press:()  async {
                    showDialog(context: context, builder: (BuildContext context) => CustomDialog(
                      title: 'aboutApp'.tr,
                      description: 'aboutUsDes'.tr,
                      icon: Icons.info,
                    ));

                  },
                ),
                CustomListTile(
                  text: "problemForUs".tr,
                  icon: Icons.report_problem_outlined,
                  press:()  async {
                    Get.to(()=>ProblemUsScreen());
                  },
                ),
                CustomListTile(
                  text: "rateApp".tr,
                  icon: Icons.stars,
                  press:()  {
                    LaunchReview.launch(androidAppId: "com.visit_egypt",
                        iOSAppId: "1568670214");

                  },
                ),
                CustomListTile(
                  text: "shareApp".tr,
                  icon: Icons.share,
                  press:()  {
                    Share.share(
                        " If you love the app please review the app on playstore and share it with your friends. https://play.google.com/store/apps/details?id=com.visit_egypt");

                  },
                ),
                CustomListTile(
                  text:uid == "" ? "SIGNIN".tr :"logout".tr,
                  icon: Icons.exit_to_app,
                  press:()  {
                    _auth.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                  },
                ),

              ],
            ),
          ),
        ),
      )
    );
  }


}
