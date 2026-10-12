import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:visit_egypt/Models/all_places_model.dart';
import 'package:visit_egypt/Models/search_autocomplete_model.dart';
import 'package:visit_egypt/Models/search_details_model.dart';
import 'package:visit_egypt/Screens/map/cubit/states.dart';
import 'package:visit_egypt/shared/components/api_constants.dart';
import 'package:visit_egypt/shared/network/remote/dio_helper.dart';

import '../mapTrack_screen.dart';

class MapCubit extends Cubit<MapStates> {
  MapCubit() : super(MapInitialState());
 static MapCubit get(context) => BlocProvider.of(context);
  Marker myMark(lt,lg)=> Marker(markerId: MarkerId("Me"),icon: BitmapDescriptor.defaultMarker,position: LatLng(lt,lg));
  Marker PlaceMark(lt,lg)=> Marker(markerId: MarkerId("Place"),icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),position: LatLng(lt,lg));

  Completer<GoogleMapController> mapController = Completer();

  bool? isMe;
  Position? currentPosition;
  getCurrentLocation() async {
    isMe = true;
    markers = [];
    emit(getLocationLoadingState());
    currentPosition =  await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = await Geolocator.getLastKnownPosition();
    emit(getLocationState());
    GoogleMapController controller =  await mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng((currentPosition!.latitude),(currentPosition!.longitude)),zoom: 16)
        ));

    markers!.add(myMark(currentPosition!.latitude,currentPosition!.longitude));
    emit(getLocationState());
  }

  List<AutoCompleteSearchModel> searchAuto = [];
  getAutoSearch({input}){
    searchAuto = [];
    DioHelper.getData(path: AutoSearch,data: {
      'key':key,
      'input':input,
    }).then((value) {
      value.data['predictions'].forEach((e){
        searchAuto.add(AutoCompleteSearchModel.fromJson(e));
      });
      emit(getAutoSearchSuccesshState());
    }).catchError((error){

      print(error.toString());
      emit(getAutoSearchErrorState());
    });
  }


  SearchDetailsModel? searchDetailsModel;
  getSearchDetails({place_id}) {
    searchAuto = [];
    DioHelper.getData(path: searchDetails,data: {
      'key':key,
      'place_id':place_id,
    }).then((value) async{
      isMe = false;
      emit(changeMe());
      searchDetailsModel = SearchDetailsModel.fromJson(value.data);
      emit(changeMe());
      GoogleMapController controller =  await mapController.future;
      // controller.animateCamera(
      //     CameraUpdate.newCameraPosition(
      //         CameraPosition(target: LatLng((searchDetailsModel!.result!.geometry!.location!.lat??0),(searchDetailsModel!.result!.geometry!.location!.lng??0)),zoom: 14)
      //     )
      // );
      emit(getSearchDetailsAndWentToNewLocationSuccesshState());

    }).catchError((error){
      print(error.toString());
      emit(getSearchDetailsAndWentToNewLocationErrorState());
    }).whenComplete((){
      emit(getSearchDetailsModel());
      Get.to(()=> MapTrackScreen((searchDetailsModel!.result!.geometry!.location!.lat??0),(searchDetailsModel!.result!.geometry!.location!.lng??0))
      );
    });
  }

  Marker mark(info,lt,lg)=> Marker(markerId: MarkerId(info),icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), infoWindow: InfoWindow(title: info),position: LatLng(lt,lg));
  List<Marker>? markers;

  //&location40.7128,-74.0060&key=<MAPS_API_KEY>
  AllPlacesModel? allPlacesModel;
  getPlaces({
    required String type,
    lat,lng
}) {
    if(isMe!)
      {
        lat = currentPosition!.latitude;
        lng = currentPosition!.longitude;
      }else{
      lat = searchDetailsModel!.result!.geometry!.location!.lat;
      lng = searchDetailsModel!.result!.geometry!.location!.lng;
    }
    DioHelper.getData(path: allPlaces,data: {
      'key':key,
      'location':'${lat},${lng}',
      'type':type
    }).then((value) async{
      allPlacesModel = AllPlacesModel.fromJson(value.data);
      markers = [];
      emit(getAllPlacesSuccesshState());
      for(var e in allPlacesModel!.results){
        markers!.add(mark(e.name,e.geometry!.location!.lat,e.geometry!.location!.lng));
        print(e.name);
      }
      emit(getAllPlacesSuccesshState());
    }).catchError((error){
      print(error.toString());
      emit(getAllPlacesErrorState());
    });
  }

  GoogleMapController? googleMapController;
  Marker? origin;
  Marker? destination;

  Directions? info;
  void addMarker(LatLng pos) async {
    // Origin is not set OR Origin/Destination are both set
      // Set origin
      // Origin is already set
      // Set destination
        destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        ); // Get dire
        // ctions
        // googleMapController!.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       target: pos,
        //       zoom: 14.5,
        //       tilt: 50.0,
        //     ),
        //   ),
        // );
      final directions = await DirectionsRepository()
          .getDirections(origin: origin!.position, destination: pos);
      info = directions;
      emit(testTracker());
  }
  }
