import 'package:visit_egypt/config/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:visit_egypt/Models/all_places_model.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';



class MapTrackScreen extends StatelessWidget {
  final double? lat, lng;

  MapTrackScreen(this.lat, this.lng);

  GoogleMapController? _googleMapController;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
        MapCubit()
          ..getCurrentLocation(),
        child: BlocConsumer<MapCubit, MapStates>(
            listener: (context, state) {
              MapCubit.get(context).origin = MapCubit.get(context).myMark(MapCubit
                  .get(context)
                  .currentPosition!
                  .latitude,
                  MapCubit
                      .get(context)
                      .currentPosition!
                      .longitude);
            },
            builder: (context, state) {
              if(state is getLocationLoadingState){
                LatLng l = LatLng(lat??0, lng??0);
                MapCubit.get(context).addMarker(l);
              }
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  centerTitle: true,
                  title: Text(
                    "Map".tr,
                    style: GoogleFonts.cairo(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back,color: primaryColor,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    // if (MapCubit.get(context).origin != null)
                    //   TextButton(
                    //     onPressed: () =>
                    //         _googleMapController!.animateCamera(
                    //           CameraUpdate.newCameraPosition(
                    //             CameraPosition(
                    //               target: MapCubit.get(context).origin!.position,
                    //               zoom: 14.5,
                    //               tilt: 50.0,
                    //             ),
                    //           ),
                    //         ),
                    //     style: TextButton.styleFrom(
                    //       primary: Colors.green,
                    //       textStyle: const TextStyle(
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //     child: const Text('ORIGIN'),
                    //   ),
                    // if (MapCubit.get(context).destination != null)
                    //   TextButton(
                    //     onPressed: () =>
                    //         _googleMapController!.animateCamera(
                    //           CameraUpdate.newCameraPosition(
                    //             CameraPosition(
                    //               target: MapCubit.get(context).destination!.position,
                    //               zoom: 14.5,
                    //               tilt: 50.0,
                    //             ),
                    //           ),
                    //         ),
                    //     style: TextButton.styleFrom(
                    //       primary: Colors.blue,
                    //       textStyle: const TextStyle(
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //     child: const Text('DEST'),
                    //   )
                  ],
                ),
                body:MapCubit
                    .get(context)
                    .currentPosition != null ? Stack(
                  alignment: Alignment.center,
                  children: [
                    GoogleMap(
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,

                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              lat??0,
                              lng??0),
                          zoom: 15),
                      // onMapCreated: (GoogleMapController controller) {
                      //   MapCubit
                      //       .get(context)
                      //       .mapController
                      //       .complete(controller);
                      // },
                      markers: {
                        MapCubit.get(context).origin!,
                        if(MapCubit.get(context).destination != null)MapCubit.get(context).destination!
                      },
                      polylines: {
                        if (MapCubit.get(context).info != null)
                          Polyline(
                            polylineId: const PolylineId('overview_polyline'),
                            color: Colors.red,
                            width: 5,
                            points: MapCubit.get(context).info!.polylinePoints
                                .map((e) => LatLng(e.latitude, e.longitude))
                                .toList(),
                          ),
                      },
                        onLongPress: MapCubit.get(context).addMarker,
                    ),
                    if (MapCubit.get(context).info != null)
                      Positioned(
                        top: 20.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              )
                            ],
                          ),
                          child: Text(
                            '${MapCubit.get(context).info!.totalDistance}, ${MapCubit.get(context).info!.totalDuration}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ) : LoadingScreen(),

              );
            }));
  }
}


class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': Env.mapsApiKey,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}