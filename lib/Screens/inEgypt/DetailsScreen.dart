import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Components/FadeAnimation.dart';
import 'package:visit_egypt/Models/all_categories_model.dart';
import 'package:get/get.dart';

import 'all_comments_screen.dart';

class PlacesDetails extends StatefulWidget {
  final Places? places;
  int? id;
  String? image;
  var rate;
  String? location;
  String? phone;
  String? website;
  String? name;
  String? description;
  PlacesDetails(
     [ this.places,
      this.id,
      this.image,
      this.rate,
      this.location,
      this.phone,
      this.website,

      this.name,
      this.description]);

  @override
  _PlacesDetailsState createState() => _PlacesDetailsState();
}

class _PlacesDetailsState extends State<PlacesDetails> with SingleTickerProviderStateMixin {
  Places? places;
  @override
  void initState() {
    places = widget.places;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(places !=null?places!.image! :widget.image!),
                fit: BoxFit.cover,
              colorFilter:  ColorFilter.mode(Colors.grey.shade800.withOpacity(0.7), BlendMode.dstATop)
            ),
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                stops: [0.3, 0.9],
                colors: [
                  Colors.black.withOpacity(.9),
                  Colors.black.withOpacity(.9),
                ]
            )
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[

                        FadeAnimation(2.2, IconButton(icon: Icon(Icons.share,color: Colors.white,),onPressed: (){
                          Share.share(
                              "${places !=null?places!.name! :widget.places!} \n \n ${places!.description !=null?places!.description! :widget.description!} ");

                        },)),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        FadeAnimation(2.4, IconButton(icon: Icon(Icons.location_on_rounded,color: Colors.white,),onPressed: (){
                          launch('${places !=null?places!.location! :widget.location!}');

                        },)),
                        FadeAnimation(2.2, IconButton(icon: Icon(Icons.public,color: Colors.white,),onPressed: (){
                          launch("mailto:${places !=null?places!.website! :widget.website!}");

                        },)),


                      ],
                    ),

                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(1,
                          Text(places !=null?places!.name! :widget.name!, style: TextStyle(color: Colors.white, fontSize: 40, height: 1.2, fontWeight: FontWeight.bold),)
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(1.5, Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [

                              Text(
                                "5/${places !=null ?places!.rate! :widget.rate!}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 15,),
                              RatingBarIndicator(
                                itemBuilder: (context, index) {
                                  return Icon(Icons.star_border, color: Colors.amber,);
                                },
                                rating: (( places !=null ?places!.rate! :widget.rate!)/1),
                                itemCount: 5,
                                itemSize: 15,
                                unratedColor: Colors.grey,
                              ),
                            ],
                          ),

                          FadeAnimation(2, IconButton(icon: Icon(Icons.phone,color: Colors.white,),onPressed: (){
                            launch('tel:${places !=null?places!.phone! :widget.phone!}');

                          },)),
                        ],
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(2, Text(places !=null?places!.description! :widget.description!, style: TextStyle(color: Colors.white.withOpacity(.7), height: 1.9, fontSize: 15),)),
                      SizedBox(height: 20,),
                      FadeAnimation(2.5, InkWell(
                        onTap: (){
                          Get.to(AllComments(places!));
                        },
                        child: Text('Show All comments'.tr, style: GoogleFonts.cairo(
                            color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                      )),
                      SizedBox(height: 30,),
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }


}