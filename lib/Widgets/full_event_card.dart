import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FullEventCard extends StatelessWidget {
  final String imageLocation;
  final String eventName;
  final String eventDetails;
  final String category;
  final String payment;
  final Color favColor;
  final Function() fav;
  const FullEventCard({
    Key? key,
     required this.imageLocation,
     required this.eventName,
     required this.eventDetails,
     required this.category,
    required this.payment,
    required this.favColor,
    required this.fav
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        //* Event image
        Container(
          width: double.infinity,
          height: 190,
          margin: EdgeInsets.only(top: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Hero(
              tag:"eventHero",
              child: Image.network(
                this.imageLocation,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget? child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child!;
                  return Center(
                    child:Icon(Icons.image,size: 60,),
                  );
                },
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          width: double.infinity,
          height: 190,
          padding: EdgeInsets.fromLTRB(10, 0, 0, 10),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(child: CircleAvatar(
                                child: Icon(Icons.favorite_border,color: Colors.redAccent.shade100,),
                                backgroundColor: this.favColor),
                              onTap: this.fav,
                            ),
                          ],
                        ),
                      ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Container(
                           width: 90,
                           margin: EdgeInsets.fromLTRB(0, 0, 15, 4),
                           padding: EdgeInsets.all(5),
                           decoration: BoxDecoration(
                             color: Colors.white60,
                             borderRadius: BorderRadius.circular(15),
                           ),
                           child: Text(
                             this.category,
                             style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                             textAlign: TextAlign.center,

                           ),
                         ),
                         Container(
                           width: 65,
                           margin: EdgeInsets.fromLTRB(0, 0, 15, 4),
                           padding: EdgeInsets.all(5),
                           decoration: BoxDecoration(
                             color: Colors.white60,
                             borderRadius: BorderRadius.circular(15),
                           ),
                           child: Text(
                             this.payment,
                             style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                             textAlign: TextAlign.center,
                           ),
                         ),
                       ],
                     ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0,left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* Event Name
                          Text(
                            this.eventName.length > 30 ? "${this.eventName.substring(0,30)}...": this.eventName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          //* Event Details
                          Text(
                            this.eventDetails.length > 30 ? "${this.eventDetails.substring(0,30)}...": this.eventDetails ,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            )
          ),
        )
      ],
    );
  }
}