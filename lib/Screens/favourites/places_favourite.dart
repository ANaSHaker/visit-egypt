import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:visit_egypt/Screens/inEgypt/DetailsScreen.dart';
import 'package:visit_egypt/Screens/inEgypt/cubit/cubit.dart';
import 'package:visit_egypt/Screens/inEgypt/cubit/states.dart';
import 'package:visit_egypt/Screens/inEgypt/noSqlHelper/favourite_place_model.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';

Widget favouritePlaces()=> BlocProvider(
  create: (context)=>inEgyptCubit(),

  child:BlocConsumer<inEgyptCubit,inEgyptStates>(
    listener: (context,state){},
    builder: (context,state){

      return ValueListenableBuilder(
          valueListenable: Hive.box<DataFavPlaces>('favPlacesBox').listenable(),
          builder: (context, Box<DataFavPlaces> box, _) {
            if(box.values.length == 0)
              return Center(child:Icon(Icons.event),);
            else
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:  ListView.separated(
                  itemCount: box.values.length,
                  itemBuilder: (context,index){
                    DataFavPlaces? favItem = box.getAt(index);

                    Box favouriteFavBox = Hive.box<DataFavPlaces>('favPlacesBox');

                    return AnimatedWidgets(
                      child: Hero(
                        tag: "placeImage",
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => PlacesDetails(
                                  null,
                                favItem!.id,
                                favItem.image,
                                  favItem.rate,
                                  favItem.location,
                                  favItem.phone,
                                  favItem.website,
                                  favItem.name,
                                  favItem.description,

                              ));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(25),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              favItem!.image ??
                                                  ""),
                                          fit: BoxFit.cover)),
                                  height: 180,
                                  width: double.infinity,
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: 15,
                                  child: Column(
                                    crossAxisAlignment:
                                    Get.locale == Locale('en', 'US')
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        favItem.name ?? "",
                                        style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                      Text(
                                          favItem
                                              .description ??
                                              "",
                                          style: GoogleFonts.cairo(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: InkWell(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(10.0),
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: Colors.redAccent,
                                        ),
                                        backgroundColor:
                                        favouriteFavBox.containsKey(
                                            favItem.id)
                                            ? Colors.red
                                            : Colors.grey.shade800
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    onTap: () {
                                      inEgyptCubit
                                          .get(context)
                                          .onPressFav(
                                        id: favItem.id,
                                        image: favItem.image,
                                        rate: favItem.rate,
                                        description: favItem.description,
                                        location: favItem.location,
                                        title: favItem.name,
                                        websiteLink: favItem.website,
                                        phone: favItem.phone,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      delay: 300,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 5,),
                ),
              );
          }
      );
    },
  ),
);