import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visit_egypt/Models/EgyptCities_model.dart';
import 'package:visit_egypt/Models/all_categories_model.dart';
import 'package:visit_egypt/Models/all_comments_model.dart';
import 'package:visit_egypt/Screens/inEgypt/noSqlHelper/favourite_place_model.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/shared/components/api_constants.dart';
import 'package:visit_egypt/shared/network/remote/dio_helper.dart';

import 'states.dart';
import 'package:dio/dio.dart' as dio;

class inEgyptCubit extends Cubit<inEgyptStates> {
  inEgyptCubit() : super(InitialinEgyptesState());

  static inEgyptCubit get(context) => BlocProvider.of(context);

  EgyptCities? egyptCities;

  getAllCities() {
    emit(loadinginEgyptesState());
    DioHelper.getData(
        path: Get.locale == Locale('en', 'US') ? cityEn : cityeAr)
        .then((value) {
      egyptCities = EgyptCities.fromJson(value.data);
      print(value.toString());
      emit(getinEgypteSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getinEgyptesErrorState());
    });
  }

  File? image;
  final picker = ImagePicker();
  List<int>? imageBytes;
  String? base64Image;
  FilePickerResult? result;
  PlatformFile? file;
  Future<void> openFileExplorer() async {
    result = await FilePicker.platform.pickFiles();
    file = result!.files.single;
    emit(getImageStateS());
  }
  AllCategoriesCity? allCategoriesCity;

  getAllCategoriesCities(String id) {
    emit(loadinginAllCategoriesCityesState());
    DioHelper.getData(
        path:Get.locale == Locale('en', 'US') ? "${categoriesCity+id}/en": "${categoriesCity+id}/ar")
        .then((value) {
      allCategoriesCity = AllCategoriesCity.fromJson(value.data);
      emit(loadinginAllCategoriesCityesState());
      print(value.toString());
      emit(getinAllCategoriesCityeSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getinAllCategoriesCityesErrorState());
    });
  }


  AllCategoriesCity? allCategoriesAddPlaces;
  getAllCategoriesAddPlaces() {
    emit(loadinginAllCategoriesCityesState());
    DioHelper.getData(
        path:allCategories
    )
        .then((value) {
      allCategoriesAddPlaces = AllCategoriesCity.fromJson(value.data);
      emit(loadinginAllCategoriesAddPlacesState());
      print(value.toString());
      emit(getinAllCategoriesAddPlacesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getinAllCategoriesAddPlacesErrorState());
    });
  }

  AllCommentsModel? allCommentsModel;

  void getAllComments({placeId}) {
    emit(getAllComentsLoadingState());
    DioHelper.getData(path: companiesComments, data: {
      'place_id': placeId,
    }).then((value) {
      allCommentsModel = AllCommentsModel.fromJson(value.data);
      print(value.data);
      emit(getAllComentsSuccessState());
    }).catchError((e) {
      emit(getAllComentsErrorState());
    });
  }

  void postcomment({required comment, required userId, required placeId}) {
    emit(postCommentLoadingState());
    DioHelper.postData(path: postComment, data: {
      'body': comment,
      'firebase_id': userId,
      'place_id': placeId,
    }).then((value) {
      getAllComments(placeId: placeId);
      emit(postCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(postCommentErrorState());
    });
  }

  void deletecomment({required commentId, required placeId}) {
    emit(deleteCommentLoadingState());
    DioHelper.deletetData(path: "$postComment/${commentId.toString()}").then((
        value) {
      getAllComments(placeId: placeId);
      emit(deleteCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(deleteCommentErrorState());
    });
  }

  void putcomment({required commentId, required placeId, required body}) {
    emit(putCommentLoadingState());
    DioHelper.putData(path: "$postComment/${commentId.toString()}",
        data: {
          'body': body,

        }).then((value) {
      getAllComments(placeId: placeId);
      emit(putCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(putCommentErrorState());
    });
  }

  void onPressFav({
    required id,
    required title,
    required description,
    required rate,
    required websiteLink,
    required image,
    required location,
    required phone,
  }) {
    Box favouriteFavBox = Hive.box<DataFavPlaces>('favPlacesBox');
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
          DataFavPlaces(
            id: id,
            name: title,
            description: description,
           rate:rate ,
            website: websiteLink,
            image: image,
            location: location,
            phone: phone,
          ));
      emit(addFavState());
    }
  }

  int? currentIndex;
  changeIndexTab(int i){
    currentIndex = i;
    print(currentIndex);
    emit(ChangedState());
  }
  animate(TabController tabController,i){
    changeIndexTab(i);
    tabController.animateTo((currentIndex??0), duration: Duration(milliseconds: 100), curve: Curves.elasticInOut);
    emit(ChangedState());
  }

  int? valueCategory;
  changevalueCat(val){
    valueCategory = val;
    print(valueCategory);
    emit(changeValSuccessState());
  }


  int? valueCity;
  changevalueCity(val){
    valueCity = val;
    print(valueCity);
    emit(changeValSuccessState());
  }

  Future upLoadPlace(
      {required PlatformFile file,
        user_id,
        titleAr,
        titleEn,
        discAr,
        discEn,
        phone,
        websiteLink,
        catergory,
        rate,
        city,
        location,
        price,}) async {
    emit(sendinEgypteLoading());
    dio.FormData formData = dio.FormData.fromMap({
      "image": await dio.MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      ),
      'Price':price,
      'location':location,
      'phone':phone,
      'website':websiteLink,
      'firebase_id': uid,
      'category_id':int.parse(catergory),
      'en[description]':discEn,
      'ar[name]':titleAr,
      'ar[description]':discAr,
      'en[name]':titleEn,
      'rate':double.parse(rate),
      'city_id':int.parse(city),
    });
    try {
      final response = await DioHelper.postEvent(path: postPlaces,
          data: formData);
      print(response.statusCode);
      if (response.statusCode == 200) {
        emit(sendinEgypteSuccess());
        print("${response.data}");
        print(response.statusMessage);
        print(response.statusCode);
        return response.data;
      }
    } catch (ex) {
      emit(sendinEgypteError());
      print('there\'s an exception:$ex');
      return null;
    }
  }
  int tabIndex =0 ;
}
