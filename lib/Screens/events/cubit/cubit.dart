import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visit_egypt/Models/Events_model.dart';
import 'package:visit_egypt/Models/all_comments_model.dart';
import 'package:visit_egypt/Models/categories_culture_model.dart';
import 'package:visit_egypt/Screens/events/noSqlHelper/favourite_event_model.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/shared/components/api_constants.dart';
import 'package:visit_egypt/shared/network/remote/dio_helper.dart';
import 'states.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
class EventsCubit extends Cubit<EventsStates> {
  EventsCubit() : super(InitialEventsState());

  static EventsCubit get(context) => BlocProvider.of(context);

  EventModel? eventModel;

  getAllEvents() {
    emit(loadingEventsState());
    DioHelper.getData(
            path: Get.locale == Locale('en', 'US') ? eventsEn : eventsAr)
        .then((value) {
      eventModel = EventModel.fromJson(value.data);
      print(value.toString());
      emit(getEventSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getEventsErrorState());
    });
  }

  Data? data;

  getEvent() {
    DioHelper.getData(
            path: Get.locale == Locale('en', 'US') ? eventsEn : eventsAr)
        .then((value) {
      data = Data.fromJson(value.data);
      print(value.toString());
      emit(getEventSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getEventsErrorState());
    });
  }

  File? image;
  final picker = ImagePicker();
  List<int>? imageBytes;
  String? base64Image;
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageBytes = await pickedFile.readAsBytes();
      base64Image = base64Encode(imageBytes!);
      image = File(pickedFile.path);
      emit(getImageSuccessState());
    } else {
      print('No image selected.');
      emit(getImageErrorState());
    }
  }

  late bool value = false;

  void changeValue(val) {
    value = val;
    emit(chanegValue());
  }

  void onPressFav({
    required id,
    required user_id,
    required title,
    required description,
    required startDate,
    required endDate,
    required phone,
    required websiteLink,
    required email,
    required payment,
    required catergory,
    required image,
    required location,
    required price,
  }) {
    Box favouriteFavBox = Hive.box<EventFav>('favEventBox');
    if (favouriteFavBox.containsKey(id)) {
      favouriteFavBox.delete(id).then((value) {
        emit(removedFromFavSuccess());
      }).catchError((e) {
        emit(removedFromFavError());
      });
      emit(removedFromFavSuccess());
    } else {
      favouriteFavBox.put(
          id,
          EventFav(
            id: id,
            user_id: user_id,
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate,
            phone: phone,
            websiteLink: websiteLink,
            email: email,
            payment: payment,
            catergory: catergory,
            image: image,
            location: location,
            price: price,
          ));
      emit(addFavState());
    }
  }
  Future upLoadEvent(
      {required PlatformFile file,
        user_id,
        titleAr,
        titleEn,
        discAr,
        discEn,
        startDate,
        endDate,
        phone,
        websiteLink,
        email,
        catergory,
        location,
        price,}) async {
    emit(sendEventLoading());
    dio.FormData formData = dio.FormData.fromMap({
      "image": await dio.MultipartFile.fromFile(
        file.path!,
        filename: file.name,),
      'startDate':startDate,
      'endDate':endDate,
      'Price':price,
      'location':location,
      'phone':phone,
      'email':email,
      'website':websiteLink,
      'type':value?1:0,
      'firebase_id': uid,
      'category_id':int.parse(catergory),
      'en[description]':discEn,
      'ar[title]':titleAr,
      'ar[description]':discAr,
      'en[title]':titleEn,

    });
    try {
      final response = await DioHelper.postEvent(path: sendEvent,
          data: formData);
      print(response.statusCode);
      if (response.statusCode == 200) {
        emit(sendEventSuccess());
        print("${response.data}");
        print(response.statusMessage);
        print(response.statusCode);
        return response.data;
      }
    } catch (ex) {
      emit(sendEventError());
      print('there\'s an exception:$ex');
      return null;
    }
  }

  AllCommentsModel? allCommentsModel;
  void getAllComments({eventId}){
    emit(getAllComentsLoadingState());
    DioHelper.getData(path: companiesComments,data: {
      'event_id':eventId,
    }).then((value){
      print(eventId);
      allCommentsModel = AllCommentsModel.fromJson(value.data);
      print(value.data);
      emit(getAllComentsSuccessState());
    }).catchError((e){

      emit(getAllComentsErrorState());
    });
  }
  bool isLoad = false;
  void postcomment({required comment,required userId,required eventId}) {
    isLoad = true;
    emit(postCommentLoadingState());
    DioHelper.postData(path: postComment, data: {
      'body':comment,
      'firebase_id':userId,
      'event_id':eventId,
    }).then((value) {
      getAllComments(eventId: eventId);
      emit(postCommentSuccessState());
      isLoad = false;
    }).catchError((e) {
      print(e.toString());
      emit(postCommentErrorState());
    });
  }

  void deletecomment({required commentId,required eventId}) {
    emit(deleteCommentLoadingState());
    DioHelper.deletetData(path: "$postComment/${commentId.toString()}").then((value) {
      getAllComments(eventId: eventId);
      emit(deleteCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(deleteCommentErrorState());
    });
  }

  void putcomment({required commentId,required eventId,required body}) {
    emit(putCommentLoadingState());
    DioHelper.putData(path: "$postComment/${commentId.toString()}",
        data:{
          'body':body,

        } ).then((value) {
      getAllComments(eventId: eventId);
      emit(putCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(putCommentErrorState());
    });
  }
  DateTime? start;
  DateTime? end;
  saveStartDateTime(val){
    start = val;
    emit(saveStartState());
  }
  saveEndDateTime(val){
    end = val;
    emit(saveEndState());
  }

  int? valueeeeeee;
  changevalueeeeeee(val){
    valueeeeeee = val;
    print(valueeeeeee);
    emit(changeValSuccessState());
  }

  CategoriesCultureModel? categoriesEventModel;
   getCategoriesEvents() {
    emit(getCategorieEventsLoadingState());
    DioHelper.getData(path: categoriesEvents).then((value) {
      categoriesEventModel = CategoriesCultureModel.fromJson(value.data);
      emit(getCategorieEventsSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(getCategorieEventsErrorState());
    });
  }

  FilePickerResult? result;
  PlatformFile? file;
  Future<void> openFileExplorer() async {
    result = await FilePicker.platform.pickFiles();
    print(result!.files.single.path);
    file = result!.files.single;
    print(file!.path);
    emit(getImageStateS());
  }
}
