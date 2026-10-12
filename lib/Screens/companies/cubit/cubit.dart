import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:visit_egypt/Models/all_comments_model.dart';
import 'package:visit_egypt/Models/all_companies_model.dart';
import 'package:visit_egypt/Screens/companies/all_comments_screen.dart';
import 'package:visit_egypt/Screens/companies/cubit/states.dart';
import 'package:visit_egypt/Screens/companies/noSqlHelper/favourite_company_model.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/shared/components/api_constants.dart';
import 'package:visit_egypt/shared/network/remote/dio_helper.dart';

import '../../../shared/components/api_constants.dart';

class TransportationCubit extends Cubit<TransportationStates> {
  TransportationCubit() : super(InitialTransportationState());

  static TransportationCubit get(context) => BlocProvider.of(context);

  AllCompaniesModel? companyModel;
  List<Data>? companyModelSearch = [];

  getAllCompanies() {
    emit(getPostsLoadingState());
    companyModelSearch = [];
    DioHelper.getData(
        path: Get.locale == Locale('en', 'US') ? companiesEn : companiesAr)
        .then((value) {
      companyModel = AllCompaniesModel.fromJson(value.data);
      companyModel!.data!.forEach((element) {
        companyModelSearch!.add(element);
      });
      emit(getAllCompaniesSuccessState());
    }).catchError((error) {
      emit(getAllCompaniesErrorState());
    });
  }

  bool searching = false;

  isSearch() {
    searching = !searching;
    emit(isSearchState());
  }

  getSearch(String val) {
    companyModelSearch = [];
    if (val.isEmpty) {
      companyModel!.data!.forEach((element) {
        companyModelSearch!.add(element);
      });
      emit(AllState());
    }
    val = val.toLowerCase();
    companyModel!.data!.forEach((e) {
      var name = e.name!.toLowerCase();
      if (name.contains(val)) {
        companyModelSearch!.add(e);
      }
    });
    emit(getSearchState());
  }

  Titlesearch(TextEditingController textEditingController, Color color) {
    return AnimatedContainer(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      clipBehavior: Clip.none,
      height: searching ? 70 : 0,
      duration: Duration(milliseconds: 250),
      curve: Curves.decelerate,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: TextFormField(
          controller: textEditingController,
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          cursorWidth: 1,
          cursorHeight: 18,
          style: TextStyle(fontSize: 14),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            filled: true,
            prefixIcon: Icon(
              Icons.search,
            ),
            hintText: "search".tr,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            fillColor: color,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (val) {
            getSearch(val);
          },
        ),
      ),
    );
  }


  void onPressFav({
    required description,
    required type,
    required image,
    required id,
    required name,
    required contactLink,
    required createdAt,
    required rate,
    required updatedAt,
    required websiteLink,
  }) {
    Box favouriteFavBox = Hive.box<DataFav>('favBox');
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
          DataFav(
              description: description,
              type: type,
              image: image,
              id: id,
              name: name,
              contactLink: contactLink,
              createdAt: createdAt,
              rate: rate,
              updatedAt: updatedAt,
              websiteLink: websiteLink)
      );
      emit(addFavState());
    }
  }

  AllCommentsModel? allCommentsModel;
  void getAllComments({companyId}){
    emit(getAllComentsLoadingState());
    DioHelper.getData(path: companiesComments,data: {
      'company_id':companyId,
    }).then((value){
      allCommentsModel = AllCommentsModel.fromJson(value.data);
      print(value.data);
      emit(getAllComentsSuccessState());
    }).catchError((e){

      emit(getAllComentsErrorState());
    });
  }
  void postcomment({required comment,required userId,required companyId}) {
    emit(postCommentLoadingState());
    DioHelper.postData(path: postComment, data: {
      'body':comment,
      'firebase_id':userId,
      'company_id':companyId,
    }).then((value) {
      getAllComments(companyId: companyId);
      emit(postCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(postCommentErrorState());
    });

  }
  void deletecomment({required commentId,required companyId}) {
    emit(deleteCommentLoadingState());
    DioHelper.deletetData(path: "$postComment/${commentId.toString()}").then((value) {
      getAllComments(companyId: companyId);
      emit(deleteCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(deleteCommentErrorState());
    });
  }

  void putcomment({required commentId,required companyId,required body}) {
    emit(putCommentLoadingState());
    DioHelper.putData(path: "$postComment/${commentId.toString()}",
    data:{
      'body':body,

    } ).then((value) {
      getAllComments(companyId: companyId);
      emit(putCommentSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(putCommentErrorState());
    });
  }

}
