import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:bloc/bloc.dart';

import 'mapTrack_screen.dart';
class MapScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>MapCubit()..getCurrentLocation(),
      child: BlocConsumer<MapCubit, MapStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "searchForPlace".tr,
                style: GoogleFonts.cairo(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,

            ),
            body: MapCubit.get(context).currentPosition == null
                ? Center(
              child: LoadingScreen(),
            )
                : ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5),
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "SearchPlaces".tr,
                        ),
                        onChanged: (val) {
                          MapCubit.get(context).getAutoSearch(input: val);
                        },


                      ),
                    ),
                  ),
                ),

                Stack(
                  children: [
                    Container(
                      height: 300,
                      child: GoogleMap(
                        markers: MapCubit.get(context).markers!.toSet(),
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          MapCubit.get(context)
                              .mapController
                              .complete(controller);
                        },
                        myLocationButtonEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                MapCubit.get(context)
                                    .currentPosition!
                                    .latitude,
                                MapCubit.get(context)
                                    .currentPosition!
                                    .longitude),
                            zoom: 15),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 9,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: Offset(0, 0)),
                            ]),
                        child: IconButton(
                          onPressed: () {
                            MapCubit.get(context).getCurrentLocation();
                          },
                          icon: Icon(
                            Icons.location_on_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (textController.text != "")
                      Container(
                        color: Colors.black26,
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Text(
                                    (MapCubit.get(context)
                                        .searchAuto[index]
                                        .description ??
                                        ""),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                ),
                                onTap: () {

                                  MapCubit.get(context).getSearchDetails(
                                      place_id: MapCubit.get(context)
                                          .searchAuto[index]
                                          .placeId);
                                  textController.text = "";
                                },
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(
                                  height: 3,
                                ),
                            itemCount:
                            MapCubit.get(context).searchAuto.length),
                      ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    primary: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      ListTags(context, "Cafe", "cafe"),
                      ListTags(context, "Mosque", "mosque"),
                      ListTags(context, "Library", "library"),
                      ListTags(context, "Bank", "bank"),
                      ListTags(context, "Book Store", "book_store"),
                      ListTags(context, "Bus Station", "bus_station"),
                      ListTags(context, "Pharmacy", "pharmacy"),
                      ListTags(context, "Police", "police"),
                      ListTags(context, "Restaurant", "restaurant"),
                      ListTags(context, "School", "school"),
                      ListTags(context, "Gym", "Gym"),
                      ListTags(context, "Tourist Attraction", "tourist_attraction"),
                      ListTags(context, "Train Station", "train_station"),
                      ListTags(context, "University", "university"),
                      ListTags(context, "Hospital", "hospital"),
                      ListTags(context, "Gas Station", "gas_station"),
                      ListTags(context, "Fire Station", "fire_station"),
                      ListTags(context, "Dentist", "dentist"),
                      ListTags(context, "Parking", "Parking"),
                      ListTags(context,"Museum","museum"),

                    ],),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
  Widget ListTags(BuildContext context,String title , String type){
    return InkWell(
      onTap: (){
        MapCubit.get(context)
            .getPlaces(type: type);
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor,width: 2,)
        ),
        alignment: Alignment.center,
        child: Text(title,style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize:title.length > 15  ? 15:18,
        ),),
      ),
    );
  }
}
