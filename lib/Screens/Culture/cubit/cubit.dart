import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visit_egypt/Models/all_comments_model.dart';

import 'package:visit_egypt/Models/all_culture_model.dart';
import 'package:visit_egypt/Models/categories_culture_model.dart';
import 'package:visit_egypt/Models/specific_culture.dart';
import 'package:visit_egypt/Screens/Culture/noSqlHelper/favourite_culture_model.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/shared/components/api_constants.dart';
import 'package:visit_egypt/shared/network/remote/dio_helper.dart';
import 'states.dart';

class CultureCubit extends Cubit<CultureStates> {
  CultureCubit() : super(InitialCulturesState());

  static CultureCubit get(context) => BlocProvider.of(context);

  ClutureModel? clutureModel;
  List<Data>? cultureModelSearch = [];

  getAllCultures() {
    emit(loadingCulturesState());
    DioHelper.getData(
        path: Get.locale == Locale('en', 'US') ? cultureEn : cultureAr)
        .then((value) {
      clutureModel = ClutureModel.fromJson(value.data);
      print(value.data.toString());
      emit(getCultureSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getCulturesErrorState());
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

  SpecificCultureModel? specificCultureModel;

  getSpecificCulture(eventId) {
    print(eventId);
    emit(loadingSpecificCulturesState());
    cultureModelSearch = [];

    DioHelper.getData(
        path:Get.locale == Locale('en', 'US') ? "${specificCultureEn + eventId}" : "${specificCultureAr + eventId}")
        .then((value) {
      specificCultureModel = SpecificCultureModel.fromJson(value.data);

      specificCultureModel!.data!.forEach((element) {
        cultureModelSearch!.add(element);
        print(element.categoryId);
      });
      print(value.data['category_id']);
      print(value.data);
      print(value.toString());
      emit(getSpecificCultureSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getSpecificCulturesErrorState());
    });
  }

  late bool value = true;

  void changeValue(val) {
    value = val;
    emit(chanegValue());
  }


  var ImageUploaded;
  bool isUploaded = false;

  DateTime? start;
  DateTime? end;

  saveStartDateTime(val) {
    start = val;
    emit(saveStartState());
  }

  saveEndDateTime(val) {
    end = val;
    emit(saveEndState());
  }


  getSearch(String val) {
    cultureModelSearch = [];
    if (val.isEmpty) {
      specificCultureModel!.data!.forEach((element) {
        cultureModelSearch!.add(element);
      });
      emit(AllState());
    }
    val = val.toLowerCase();
    specificCultureModel!.data!.forEach((e) {
      var name = e.title!.toLowerCase();
      if (name.contains(val)) {
        cultureModelSearch!.add(e);
      }
    });
    emit(getSearchState());
  }

  Titlesearch(BuildContext context,
      TextEditingController textEditingController,id) {
    return Container(
      height: 39,
      margin: EdgeInsets.only(left: 25, right: 25, top: 18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme
              .of(context)
              .brightness == Brightness.dark ? Colors.grey[800] : Colors
              .grey[300]),
      child: Stack(
        children: <Widget>[
          TextFormField(
            controller: textEditingController,
            style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                contentPadding:
                EdgeInsets.only(left: 19, right: 50, bottom: 8),
                border: InputBorder.none,
                hintText: 'search'.tr,
                hintStyle: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            onChanged: (val) {
              if(textEditingController.text == ""){
                CultureCubit.get(context).getSpecificCulture(id);
              }
              else
              CultureCubit.get(context).getSearch(val);
            },
          ),

          Positioned(
            top: 8,
            right: 9,
            child:
            Icon(Icons.search_rounded,),
          )
        ],
      ),
    );
  }

  void onPressFav({
    required title,
    required description,
    required image,
    required id,
    required link,
    required double? rate,
    required mainCharacter,

  }) {
    Box favouriteFavBox = Hive.box<DataFavCuluture>('favCultureBox');
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
          DataFavCuluture(
            title: title,
            description: description,
            image: image,
            id: id,
            link: link,
            rate: rate,
            mainCharacter: mainCharacter,

          )
      );
      emit(addFavState());
    }
  }

  AllCommentsModel? allCommentsModel;

  void getAllComments({cultureId}) {
    emit(getAllComentsLoadingState());
    DioHelper.getData(path: companiesComments, data: {
      'culture_id': cultureId,
    }).then((value) {
      allCommentsModel = AllCommentsModel.fromJson(value.data);
      print(value.data);
      emit(getAllComentsSuccessState());
    }).catchError((e) {
      emit(getAllComentsErrorState());
    });
  }

  void postcomment({required comment, required userId, required cultureId}) {
    emit(postCommentLoadingState());
    DioHelper.postData(path: postComment, data: {
      'body': comment,
      'firebase_id': userId,
      'culture_id': cultureId,
    }).then((value) {
      getAllComments(cultureId: cultureId);
      emit(postCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(postCommentErrorState());
    });
  }

  void deletecomment({required commentId, required cultureId}) {
    emit(deleteCommentLoadingState());
    DioHelper.deletetData(path: "$postComment/${commentId.toString()}").then((
        value) {
      getAllComments(cultureId: cultureId);
      emit(deleteCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(deleteCommentErrorState());
    });
  }

  void putcomment({required commentId, required cultureId, required body}) {
    emit(putCommentLoadingState());
    DioHelper.putData(path: "$postComment/${commentId.toString()}",
        data: {
          'body': body,

        }).then((value) {
      getAllComments(cultureId: cultureId);
      emit(putCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(putCommentErrorState());
    });
  }

  Future upLoadCulture(
      {required PlatformFile file,
        rate,
        category,
        titleAr,
        titleEn,
        discAr,
        discEn,
        link,
        mainchar}) async {
    emit(UploadCultureStateLoading());
    dio.FormData formData = dio.FormData.fromMap({
      "image": await dio.MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      ),
      'rate': double.parse(rate),
      'link': link,
      'category_id': int.parse(category),
      'maincharacter': mainchar,
      'firebase_id': uid,
      'ar[title]': titleAr,
      'ar[description]': discAr,
      'en[title]': titleEn,
      'en[description]': discEn
    });
    try {
      final response = await DioHelper.postCulture(path: sendCulture,
        data: formData);
      print(response.statusCode);
      if (response.statusCode == 200) {
        emit(UploadCultureStateSuccess());
        print("${response.data}");
        print(response.statusMessage);
        print(response.statusCode);
        return response.data;
      }
    } catch (ex) {
      emit(UploadCultureStateError());
      print('there\'s an exception:$ex');
      return null;
    }
  }

  CategoriesCultureModel? categoriesCultureModel;
  void getCategoriesCultur() {
    emit(getCategoriesCultureLoadingState());
    DioHelper.getData(path: categoriesCulture).then((value) {
      categoriesCultureModel = CategoriesCultureModel.fromJson(value.data);
      print(value.data);
      emit(getCategoriesCultureSuccessState());
    }).catchError((e) {
      emit(getCategoriesCultureErrorState());
    });
  }
  int? valueee;
  changeValueee(val){
    valueee = val;
    emit(changeValSuccessState());
  }

  FilePickerResult? result;
  PlatformFile? file;
  Future<void> openFileExplorer() async {
    result = await FilePicker.platform.pickFiles();
    file = result!.files.single;
    emit(getImageStateS());
  }

}
