import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/constants/constants.dart';

class ItemPhoneData {
  late String name;
  late int phone;

  ItemPhoneData(this.name, this.phone);
}

List<ItemPhoneData> itemPhoneDataList = [
  ItemPhoneData("Police".tr, 122),
  ItemPhoneData("Ambulance".tr, 123),
  ItemPhoneData("TourismPolice".tr, 126),
  ItemPhoneData("Trafficpolice".tr, 128),
  ItemPhoneData("Firefighting".tr, 180),
  ItemPhoneData("Electricityemergency".tr, 121),
  ItemPhoneData("Naturalgasemergency".tr, 129),
  ItemPhoneData("Highwayrescue".tr, 01221110000),
  ItemPhoneData("Railroadtrains".tr, 25753555),
  ItemPhoneData("CairoAirportTerminal1".tr, 22653333),
  ItemPhoneData("CairoAirportTerminal2".tr, 22652222),
  ItemPhoneData("EgyptAir", 1717),
];

class EgyptPhoneNumpers extends StatefulWidget {
  const EgyptPhoneNumpers({Key? key}) : super(key: key);

  @override
  State<EgyptPhoneNumpers> createState() => _EgyptPhoneNumpersState();
}

class _EgyptPhoneNumpersState extends State<EgyptPhoneNumpers> {
  ScrollController? _controller;
  bool silverCollapsed = false;
  String myTitle = "emergencyNumbers".tr;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    _controller!.addListener(() {
      if (_controller!.offset >20 && !_controller!.position.outOfRange) {
        if(!silverCollapsed){

          // do what ever you want when silver is collapsing !

          myTitle = "usefulcontacts".tr;
          silverCollapsed = true;
          setState(() {});
        }
      }
      if (_controller!.offset <=20 && !_controller!.position.outOfRange) {
        if(silverCollapsed){

          // do what ever you want when silver is expanding !

          myTitle = "emergencyNumbers".tr;
          silverCollapsed = false;
          setState(() {});
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        new SliverAppBar(
          pinned: true,
          centerTitle: true,
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
          elevation: 10,
          expandedHeight: 120,
          floating: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: primaryColor,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),

          flexibleSpace: new FlexibleSpaceBar(
            centerTitle: true,
            title: Text( myTitle ,
              style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                color: primaryColor,
              ),

              textAlign: TextAlign.center,
            ),
          ),
          ),
      ];},
          body:Padding(
        padding: const EdgeInsets.all(8.0),
      child: ListView(

        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Container(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Usefulcontacts".tr, style: GoogleFonts.cairo(
                  color: primaryColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),),
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("clickOpenLongCopy".tr,
              style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      fontSize: 14,
                      wordSpacing: 2,
                      color: Colors.grey
                  )),
              textAlign: TextAlign.center,),
          ),
          Container(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("EmergencyNumbers".tr, style: GoogleFonts.cairo(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400)),
          ), color: Colors.grey[200],),

          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == 7) {
                  return Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("UsefulNumbers".tr, style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                  ), color: Colors.grey[200],);
                }
                return itemPhoneData(itemPhoneDataList[index], context);
              },
              separatorBuilder: (context, index) =>
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
              itemCount: itemPhoneDataList.length),
        ],
      ),
    ),
        ),
    );
  }
}

  Widget itemPhoneData(ItemPhoneData item, context) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 25),
        child: GestureDetector(
          onLongPress: () {
            FlutterClipboard.copy(item.phone.toString()).then((value) {
              showToast(
                "Copied".tr,
                borderRadius: BorderRadius.circular(5),
                context: context,
                animation: StyledToastAnimation.scale,
                reverseAnimation: StyledToastAnimation.fade,
                animDuration: Duration(milliseconds: 250),
              );
            });
          },
          onTap: () {
            launch('tel:${item.phone}');
          },
          child: Row(
            children: [
              Text(
                item.name,
                style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text("${item.phone}",
                style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      );