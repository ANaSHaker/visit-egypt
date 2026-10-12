import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:visit_egypt/Models/all_categories_model.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/Widgets/UserCommentWidget.dart';
import 'package:visit_egypt/constants/constants.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';
class AllComments extends StatelessWidget {
  Places model;
  int? commentId;
  String? comment;
  var _commentFormKey = GlobalKey<FormState>();
  TextEditingController messageController = new TextEditingController();

  AllComments(this.model);

  var commentController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return BlocProvider.value(value: BlocProvider.of<inEgyptCubit>(context)..getAllComments(placeId: model.id),
        child: BlocConsumer<inEgyptCubit, inEgyptStates>(
            listener: (context, state) {
              if (state is deleteCommentSuccessState) {
                showToast("Deleted successfully".tr, context: context,
                    textStyle: GoogleFonts.cairo());
              }
              if (state is postCommentSuccessState) {
                Navigator.pop(context);
                showToast("Added successfully".tr, context: context,
                    textStyle: GoogleFonts.cairo());
              }
              if (state is putCommentSuccessState) {
                showToast("Updated successfully".tr, context: context,
                    textStyle: GoogleFonts.cairo());
              }
            },
            builder: (context, state) {
              var commentCubit = inEgyptCubit.get(context);

              return Scaffold(
                appBar: AppBar(
                  title: Text("Comments".tr,
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                  centerTitle: true,
                ),
                body: (state is getAllComentsLoadingState || commentCubit
                    .allCommentsModel == null) ? Center(
                    child: LoadingBouncingGrid.square(
                      backgroundColor: primaryColor,))
                    :
                Column(
                  children: [
                    (state is postCommentLoadingState || state is putCommentLoadingState || state is deleteCommentLoadingState)
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                      child: LinearProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                        : Text(''),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          commentId =
                              (commentCubit.allCommentsModel!.data![index]).id;
                          comment =
                              (commentCubit.allCommentsModel!.data![index])
                                  .body;
                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      uid == (commentCubit.allCommentsModel!.data![index]).firebaseId ?
                                      buildDisplayPictureAvatar(context,
                                          (commentCubit.allCommentsModel!
                                              .data![index]).id,
                                          (commentCubit.allCommentsModel!
                                              .data![index]).body, (TapUpDetails details){
                                            showPopup(details.globalPosition,() {
                                              inEgyptCubit.get(context)
                                                  .deletecomment(
                                                  commentId: (commentCubit
                                                      .allCommentsModel!
                                                      .data![index]).id,
                                                  placeId: model.id);
                                            }, () {
                                              showMaterialModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      Container(
                                                        height: 170,
                                                        child: Form(
                                                          key: _commentFormKey,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                    top: 35.0,
                                                                    left: 15.0,
                                                                    right: 15.0),
                                                                child: TextFormField(
                                                                  controller: messageController,
                                                                  decoration: InputDecoration(
                                                                      labelText: "Update comment"
                                                                          .tr,
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                            color: Colors
                                                                                .red,
                                                                            width: 2.0,
                                                                          ))),

                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                    top: 15.0),
                                                                child: RaisedButton(
                                                                    child: Text(
                                                                        "Update"
                                                                            .tr),
                                                                    onPressed: () {
                                                                      if (_commentFormKey.currentState!.validate()) {
                                                                        inEgyptCubit.get(context)
                                                                            .putcomment(commentId: (commentCubit
                                                                            .allCommentsModel!.data![index])
                                                                            .id,
                                                                            placeId: model
                                                                                .id,
                                                                            body: messageController
                                                                                .text);
                                                                        Navigator
                                                                            .pop(
                                                                            context);
                                                                      }
                                                                    }),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                              );
                                            });

                                          }) :
                                      buildUnknownUser(
                                          commentCubit.allCommentsModel!
                                              .data![index].user!.name,
                                          context, (commentCubit.allCommentsModel!
                                              .data![index]).body,(TapUpDetails details){
                                        showPopup(details.globalPosition,() {
                                          inEgyptCubit.get(context)
                                              .deletecomment(
                                              commentId: (commentCubit
                                                  .allCommentsModel!
                                                  .data![index]).id,
                                              placeId: model.id);
                                        }, () {
                                          showMaterialModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  Container(
                                                    height: 170,
                                                    child: Form(
                                                      key: _commentFormKey,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(
                                                                top: 35.0,
                                                                left: 15.0,
                                                                right: 15.0),
                                                            child: TextFormField(
                                                              controller: messageController,
                                                              decoration: InputDecoration(
                                                                  labelText: "Update comment"
                                                                      .tr,
                                                                  border: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                        color: Colors
                                                                            .red,
                                                                        width: 2.0,
                                                                      ))),

                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(
                                                                top: 15.0),
                                                            child: RaisedButton(
                                                                child: Text(
                                                                    "Update"
                                                                        .tr),
                                                                onPressed: () {
                                                                  if (_commentFormKey.currentState!.validate()) {
                                                                    inEgyptCubit.get(context)
                                                                        .putcomment(commentId: (commentCubit
                                                                            .allCommentsModel!.data![index])
                                                                            .id,
                                                                        placeId: model
                                                                            .id,
                                                                        body: messageController
                                                                            .text);
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  }
                                                                }),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                          );
                                        });

                                      }),


                                    ],
                                  ),
                                )),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(
                              height: 1,
                            ),
                        itemCount: commentCubit
                            .allCommentsModel!
                            .data!
                            .length,
                        physics: BouncingScrollPhysics(),
                      ),
                    ),
                    SizedBox(height: 20,)

                  ],
                ),
                floatingActionButton: InkWell(child: CircleAvatar(
                  child: Icon(Icons.add, color: Colors.white, size: 20,),
                  radius: 30,
                  backgroundColor: primaryColor,), onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        Container(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: ListView(
                                children: [
                                  TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "this field can't be empty".tr;
                                      }
                                    },
                                    controller: commentController
                                    , decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your comment".tr,
                                      filled: true
                                  ),),
                                  SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (FirebaseAuth.instance.currentUser ==
                                            null)
                                          showToast("Sign in first !!".tr,
                                              context: context,
                                              backgroundColor: Colors.red,
                                              position: StyledToastPosition
                                                  .bottom);
                                        else {
                                          commentCubit.postcomment(
                                              comment: commentController.text,
                                              userId: FirebaseAuth.instance
                                                  .currentUser!.uid,
                                              placeId: model.id);
                                          print(commentController.text);
                                          print(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid);
                                          print(model.id);
                                          commentController.text = "";

                                        }
                                      },
                                      child: Text(
                                        "Add".tr, style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold
                                      ),),
                                      color: primaryColor,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  );
                },
                ),
              );
            }
        ));
  }
}

