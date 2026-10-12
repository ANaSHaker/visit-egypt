import 'package:visit_egypt/config/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Screens/CurrencyConverter/CurrencyMainPage.dart';
import 'package:visit_egypt/Screens/EmbassyPhonesScreen.dart';
import 'package:visit_egypt/Screens/SignUpScreens/LoginPage.dart';
import 'package:visit_egypt/Screens/Weather/weather_Screen.dart';
import 'package:visit_egypt/Screens/arPlaces.dart';
import 'package:visit_egypt/Screens/companies/transportation.dart';
import 'package:visit_egypt/Screens/egypt_phone_numper_screen.dart';
import 'package:visit_egypt/Screens/favourites/FavouriteScreen.dart';
import 'package:visit_egypt/Screens/map/map_screen.dart';
import 'package:visit_egypt/Screens/qrCodeScreen.dart';
import 'package:visit_egypt/shared/network/local/cache_helper.dart';

import '../Screens/chatAdmin/chatadmin_screen.dart';
import '../constants/constants.dart';

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

class HomeScreenDrawer extends StatefulWidget {
  @override
  _HomeScreenDrawerState createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "";

  Future<User?> getUser() async {
    return await _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        setState(() {
          uid = user.uid;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage(  Theme.of(context).brightness == Brightness.dark ? "assets/blackLogo.png":"assets/whiteLogo.png"), fit: BoxFit.fill)),
            child: Container(),
          ),
        /*  ListDrawer(Icons.camera_alt_sharp, "arCamera".tr, () {
            if(CacheHelper.getData(key: "isAr") == true)
              Get.to(() =>ArPlaces());
            if(CacheHelper.getData(key: "isAr") == null)
              ShowDialog(context: context,gif: "ar",title: "arCamera",description: "Here you can find different things for egypt yoy can choose any of it and see in front of you easily",NavTo: ArPlaces(),sharedKey: "isAr");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),*/
          ListDrawer(Icons.emoji_transportation, "transportation".tr, () {
            if(CacheHelper.getData(key: "isTrans") == true)
              Get.to(() =>TransportationScreen());
            if(CacheHelper.getData(key: "isTrans") == null)
              ShowDialog(context: context,gif: "transport",title: "transportation",description: "transportationDes",NavTo: TransportationScreen(),sharedKey: "isTrans");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),

          ListDrawer(Icons.wrong_location_rounded, "searchForPlace".tr, ()
          {
            if(CacheHelper.getData(key: "isMap") == true)
              Get.to(() =>MapScreen());
            if(CacheHelper.getData(key: "isMap") == null)
            ShowDialog(context: context,gif: "map",title: "Map",description: "mapDes",NavTo: MapScreen(),sharedKey: "isMap");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
          ListDrawer(Icons.wb_sunny, "egyptWeather".tr, ()
          {
            if(CacheHelper.getData(key: "isWeat") == true)
              Get.to(() =>WeatherScreen());
            if(CacheHelper.getData(key: "isWeat") == null)
              ShowDialog(context: context,gif: "weather",title: "egyptWeather",description: "weatherDes",NavTo: WeatherScreen(),sharedKey: "isWeat");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
          ListDrawer(Icons.favorite, "favourite".tr, ()
          {
            if(CacheHelper.getData(key: "isfav") == true)
              Get.to(() =>FavouriteScreen());
            if(CacheHelper.getData(key: "isfav") == null)
              ShowDialog(context: context,gif: "fav",title: "favourite",description: "favDes",NavTo: FavouriteScreen(),sharedKey: "isfav");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
          ListDrawer(Icons.phone_iphone, "emergencyNumbers".tr, () {
            if(CacheHelper.getData(key: "isPhone") == true)
              Get.to(() =>EgyptPhoneNumpers());
            if(CacheHelper.getData(key: "isPhone") == null)
              ShowDialog(context: context,gif: "callPhone",title: "emergencyNumbers",description: "emergencyNumbersDes",NavTo: EgyptPhoneNumpers(),sharedKey: "isPhone");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
          ListDrawer(Icons.phone_android_sharp, "embassyPhones".tr, () {
            if(CacheHelper.getData(key: "isEmbacy") == true)
              Get.to(() =>EmbassyPhoneScreen());
            if(CacheHelper.getData(key: "isEmbacy") == null)
              ShowDialog(context: context,gif: "callPhone",title: "embassyPhones",description: "embassyPhonesDes",NavTo: EmbassyPhoneScreen(),sharedKey: "isEmbacy");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
          ListDrawer(FontAwesomeIcons.calculator, "currencyConvertor".tr, () {
            if(CacheHelper.getData(key: "isCurrency") == true)
              Get.to(() =>CurrencyConvertor());
            if(CacheHelper.getData(key: "isCurrency") == null)
              ShowDialog(context: context,gif: "money",title: "currencyConvertor",description: "currencyConvertorDes",NavTo: CurrencyConvertor(),sharedKey: "isCurrency");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
          ListDrawer(Icons.qr_code, "qrScan".tr, () {
            if(CacheHelper.getData(key: "isQr") == true)
              Get.to(() =>qrScreen());
            if(CacheHelper.getData(key: "isQr") == null)
              ShowDialog(context: context,gif: "qr",title: "Qr reader",description: "QrreaderDes",NavTo: qrScreen(),sharedKey: "isQr");
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
          ListDrawer(Icons.chat, "ContactAdmin".tr, () {
            // if(CacheHelper.getData(key: "isQr") == true)
              Get.to(() =>ChatAdminScreen());
            // if(CacheHelper.getData(key: "isQr") == null)
            //   ShowDialog(context: context,gif: "qr",title: "Qr reader",description: "QrreaderDes",NavTo: qrScreen(),sharedKey: "isQr");
            //
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
          ListDrawer(Icons.exit_to_app, uid == "" ? "SIGNIN".tr : "logout".tr,
              () {
            _auth.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginPage()));
          }),
          Divider(
            height: 10,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget ListDrawer(IconData iconData, String title, VoidCallback? press) {
    return ListTile(
        leading: Icon(iconData),
        title: Text(
          title,
          style: GoogleFonts.cairo(
              textStyle: TextStyle(
            fontSize: 17,
            wordSpacing: 2,
            fontWeight: FontWeight.bold,
          )),
        ),
        onTap: press);
  }
}


 ShowDialog({context,required gif,required title,required  description,required  NavTo,required  sharedKey}){ return showDialog(
     context: context,
     builder: (_) => AssetGiffyDialog(
       image: Image.asset('assets/gifs/${gif}.gif',alignment: Alignment.center,fit: BoxFit.cover,),
       title: Text("${title}".tr,style: GoogleFonts.cairo(
           fontSize: 25,
           fontWeight: FontWeight.w600,
           height: 1
       ),),
       description: Text(
         "${description}".tr,style: GoogleFonts.cairo(
           height: 1.2
       )
         ,),
       buttonCancelColor: Colors.grey,
       buttonOkColor: primaryColor,
       buttonOkText: Text("ok".tr,style: GoogleFonts.cairo(
           fontWeight: FontWeight.w600,
           height: 1
       ),),
       buttonRadius: 5,
       cornerRadius: 25,
       onOkButtonPressed: () {
         Get.back();
         CacheHelper.saveData(key: sharedKey, value: true);
         Navigator.push(context, MaterialPageRoute(builder: (context)=>NavTo));
       },
       entryAnimation: EntryAnimation.BOTTOM_RIGHT,
       onlyOkButton: true,
     ),
   );
}