import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Models/Events_model.dart';
import 'package:visit_egypt/Screens/events/all_comments_screen.dart';
import 'package:visit_egypt/Utils/dateTime_utils.dart';
import 'package:visit_egypt/constants/constants.dart';


class EventDetailPage extends StatefulWidget {
  final Data? event;
  int? id;
  int? user_id;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? phone;
  String? websiteLink;
  String? email;
  int? payment;
  String? catergory;
  String? image;
  String? location;
  int? price;
  EventDetailPage([this.event,  this.id, this.user_id, this.title, this.description,
    this.startDate, this.endDate, this.phone, this.websiteLink, this.email,
     this.catergory, this.image, this.location, this.price,this.payment,]);
  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with TickerProviderStateMixin {
  Data? event;
   AnimationController? controller ;
   AnimationController? bodyScrollAnimationController ;
   ScrollController? scrollController ;
   late Animation<double>? scale ;
    Animation<double>? appBarSlide;
  double headerImageSize = 0;
  bool isFavorite = false;
  bool payment = false;
  @override
  void initState() {
    event = widget.event;

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    bodyScrollAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController!.offset >= headerImageSize / 2) {
          if (!bodyScrollAnimationController!.isCompleted)
            bodyScrollAnimationController!.forward();
        } else {
          if (bodyScrollAnimationController!.isCompleted)
            bodyScrollAnimationController!.reverse();
        }
      });

    appBarSlide = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: bodyScrollAnimationController!,
    ));

    scale = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: controller!,
    ));
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    bodyScrollAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

 
    headerImageSize = MediaQuery.of(context).size.height / 2.5;
    return ScaleTransition(
      scale: scale!,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  height: 725,
                  child: ListView(
                    children: <Widget>[
                      buildHeaderImage(),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildEventTitle(),
                            SizedBox(height: 16),
                            buildEventDate(),
                            SizedBox(height:24),
                            buildAboutEvent(),
                            SizedBox(height:24),
                            buildOrganizeInfo(),
                            SizedBox(height:34),
                           event !=null ? Center(child: buildCommentsInfo()):Container(),
                            SizedBox(height:24),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                child: buildPriceInfo(),
                alignment: Alignment.bottomCenter,
              ),
              AnimatedBuilder(
                animation: appBarSlide!,
                builder: (context, snapshot) {
                  return Transform.translate(
                    offset: Offset(0.0, -1000 * (1 - appBarSlide!.value)),
                    child: Material(
                      elevation: 2,
                      color: Theme.of(context).primaryColor,
                      child: buildHeaderButton(hasTitle: true),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderImage() {
    double maxHeight = MediaQuery.of(context).size.height;
    double minimumScale = 0.8;
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        controller!.value += detail.primaryDelta! / maxHeight * 2;
      },
      onVerticalDragEnd: (detail) {
        if (scale!.value > minimumScale) {
          controller!.reverse();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: headerImageSize,
            child:  Hero(
              tag:"eventHero",
              child: ClipRRect(
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(32)),
                child:   event !=null ?
                Image.network(
                  event!.image!,
                  fit: BoxFit.cover,
                ): Image.network(
                  widget.image!,
                fit: BoxFit.cover,
              ),
              ),
            ),
          ),
          Positioned(child: buildHeaderButton(),top: 15,left: 15,right: 15,),
        ],
      ),
    );
  }

  Widget buildHeaderButton({bool hasTitle = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            if (bodyScrollAnimationController!.isCompleted)
              bodyScrollAnimationController!.reverse();
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white ,
            ),
          ),
        ),
        if (hasTitle)
          Text(event !=null?event!.title! :widget.title!,style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ), ),
        Row(
          children: [
            Card(
              shape: CircleBorder(),
              elevation: 0,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: () {
                  Share.share(
                      "${event !=null?event!.title! :widget.title!} \n \n ${event!.description !=null?event!.description! :widget.description!} ");

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                      Icons.share,
                      color: Colors.white),
                ),
              ),
              color: Theme.of(context).primaryColor,
            ),
            Card(
              shape: CircleBorder(),
              elevation: 0,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: () {
                  launch("mailto:${event !=null?event!.email! :widget.email!}");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                       Icons.email_outlined,
                      color: Colors.white),
                ),
              ),
              color: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }

  Widget buildEventTitle() {
    return Container(
      child: Text(
        event !=null?event!.title! :widget.title!,style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize: 20
      ),

      ),
    );
  }

  Widget buildEventDate() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("${DateTimeUtils.getMonth(event != null?event!.startDate! :widget.startDate!)}",
                  style: TextStyle(color: Colors.white),
                     ),
                // ignore: deprecated_member_use
                Text("${DateTimeUtils.getDayOfMonth(event != null ?event!.startDate! :widget.startDate!)}",
                  style: TextStyle(color: Colors.white),
                    ),
              ],
            ),
          ),
          SizedBox(width: 10,),
          Text("To".tr,style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(width: 10,),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("${DateTimeUtils.getMonth(event !=null?event!.endDate! :widget.endDate!)}",
                  style: TextStyle(color: Colors.white),
                ),
                Text("${DateTimeUtils.getDayOfMonth(event !=null?event!.endDate! :widget.endDate!) }",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(width: 10,),

          Spacer(),
          InkWell(
            onTap: (){
              launch('tel:${event !=null?event!.phone! :widget.phone!}');

            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration:
              ShapeDecoration(shape: StadiumBorder(side: BorderSide(width: 5 ,color: Theme.of(context).primaryColor,)), color: Theme.of(context).primaryColor,),
              child: CircleAvatar(
                backgroundColor: Colors.cyanAccent,

                child: Icon(Icons.phone,color: Theme.of(context).primaryColor,),
              ),
            ),
          ),
          SizedBox(width: 15,),
          InkWell(
            onTap: (){
              launch('${event !=null?event!.location! :widget.location!}');

            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration:
              ShapeDecoration(shape: StadiumBorder(), color: Theme.of(context).primaryColor,),
              child: FloatingActionButton(
                backgroundColor: Colors.cyanAccent,
                mini: true,
                onPressed: () {
                  launch('${event !=null?event!.location! :widget.location!}');
                },
                child: Icon(Icons.location_on_rounded,color: Theme.of(context).primaryColor,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAboutEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("About".tr,style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,

            fontSize: 24
        ),),
        Text(event !=null?event!.description! :widget.description!,),

      ],
    );
  }

  Widget buildOrganizeInfo() {
    return Row(
      children: <Widget>[
        Row(
          children: [
            Text("Start Date : ".tr,style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(" ${DateTimeUtils.getTime(event != null?event!.startDate! :widget.startDate!)}",style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                    fontSize: 18,


                ), ),
              ],
            ),

          ],
        ),
        Spacer(),
      /*  FlatButton(
          child: Text(event !=null?event!.catergory! :widget.catergory!,
              style: TextStyle(color: Colors.grey[300])),
          onPressed: () {},
          shape: StadiumBorder(),
          color: primaryColor,
        )*/
      ],
    );
  }

  Widget buildCommentsInfo(){
    return  InkWell(
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 45,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "Show All comments".tr,style: GoogleFonts.cairo(fontSize: 16,fontWeight: FontWeight.bold,                color: Colors.white
          ),
            textAlign: TextAlign.center,),
        ),
      ),
      onTap: (){
        Get.to(AllComments(event!));
      },
    );
  }

  Widget buildPriceInfo() {
    return Container(
      height: 100,
      padding: EdgeInsets.all(16),
      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]:Colors.grey[50],
      width: MediaQuery.of(context).size.width,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Price".tr,style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),),
              event != null?
              Text(event!.payment == 0 ?"free".tr : "${event!.price!.toString()} L.E",style: GoogleFonts.cairo(
                  fontSize: 16
              ),textAlign: TextAlign.center,)
                  :
              Text(widget.payment == 0 ?"free".tr : "${widget.price!.toString()} L.E",style: GoogleFonts.cairo(
                  fontSize: 16
              ),textAlign: TextAlign.center,)
            ],
          ),


          RaisedButton(
            onPressed: () {
              launch('${event !=null?event!.websiteLink! :widget.websiteLink!}');

            },
            shape: StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Theme.of(context).primaryColor,
            child: Text(
              "Get a Ticket".tr,
              style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }
}