import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:visit_egypt/Components/default_button.dart';
import 'package:visit_egypt/Services/database/user_database_helper.dart';
import 'package:visit_egypt/Services/firestore_files_access/firestore_files_access_service.dart';
import 'package:visit_egypt/Services/local_files_access/local_files_access_service.dart';
import 'package:visit_egypt/constants/constants.dart';

class ChangeDisplayPicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]:Colors.white,
        ),
        body:SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    "updatePicture".tr,
                    style: headingStyle,
                  ),
                  SizedBox(height: 10 * 0.1),
                  ChangeNotifierProvider(
                    create: (context) => ChosenImage(),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: SizedBox(
                          width: double.infinity,
                          child: Consumer<ChosenImage>(
                            builder: (context, bodyState, child) {
                              return Column(
                                children: [
                                  Text(
                                    "changeAvatar".tr,
                                    style: headingStyle,
                                  ),

                                  SizedBox(height: 40),
                                  GestureDetector(
                                    child: buildDisplayPictureAvatar(context, bodyState),
                                    onTap: () {
                                      getImageFromUser(context, bodyState);
                                    },
                                  ),
                                  SizedBox(height: 80),
                                  Padding(
                                    padding: const EdgeInsets.only(right:12.0,left: 12),
                                    child: buildChosePictureButton(context, bodyState),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right:12.0,left: 12),
                                    child: buildUploadPictureButton(context, bodyState),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right:12.0,left: 12),
                                    child: buildRemovePictureButton(context, bodyState),
                                  ),
                                  SizedBox(height: 80),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )

    );
  }

  Widget buildDisplayPictureAvatar(
      BuildContext context, ChosenImage bodyState) {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
         /* final error = snapshot.error;
          Logger().w(error.toString());*/
        }
        ImageProvider? backImage;
         String url = "";
        if (bodyState.chosenImage != null) {
          backImage = MemoryImage(bodyState.chosenImage!.readAsBytesSync());
        } else if (snapshot.hasData && snapshot.data != null) {
           url = snapshot.data![UserDatabaseHelper.DP_KEY].toString();
          if (url != "") backImage = NetworkImage(url);
        }
        return CircleAvatar(
          radius: 60,
          backgroundColor: kTextColor.withOpacity(0.5),
          backgroundImage: backImage ?? null,
        );
      },
    );
  }

  void getImageFromUser(BuildContext context, ChosenImage bodyState) async {
    String path;
      path = await choseImageFromLocalFiles(context);
      if (path == null) {
        throw "No Path";
      }
    if (path == null) {
      return;
    }
    bodyState.setChosenImage = File(path);
  }

  Widget buildChosePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "choosePicture".tr,
      press: () {
        getImageFromUser(context, bodyState);
      },
    );
  }

  Widget buildUploadPictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "uploadPicture".tr,
      press: () {
        final Future uploadFuture =
            uploadImageToFirestorage(context, bodyState);
        showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              uploadFuture,
              message: Text("updatingDisplayPicture".tr),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("displayPictureUpdated".tr)));
      },
    );
  }

  Future<void> uploadImageToFirestorage(
      BuildContext context, ChosenImage? bodyState) async {
    bool uploadDisplayPictureStatus = false;
    String snackbarMessage = "";
    try {
      final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
          bodyState!.chosenImage!,
          UserDatabaseHelper().getPathForCurrentUserDisplayPicture());

      uploadDisplayPictureStatus = await UserDatabaseHelper()
          .uploadDisplayPictureForCurrentUser(downloadUrl);
      if (uploadDisplayPictureStatus == true) {
        snackbarMessage = "DisplayPictureUpdatedSuccessfully".tr;
      } else {
        throw "CoulndotUpdateDisplayPicture".tr;
      }
    } on FirebaseException catch (e) {
     // Logger().w("Firebase Exception: $e");
      snackbarMessage = "SomethingWentWrong".tr;
    } catch (e) {
    //  Logger().w("Unknown Exception: $e");
      snackbarMessage = "SomethingWentWrong".tr;
    } finally {
      //Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
    }
  }

  Widget buildRemovePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "RemovePicture".tr,
      press: () async {
        final Future uploadFuture =
            removeImageFromFirestore(context, bodyState);
        await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              uploadFuture,
              message: Text("DeletingDisplayPicture".tr),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("DisplayPictureRemoved".tr)));
        Navigator.pop(context);
      },
    );
  }

  Future<void> removeImageFromFirestore(
      BuildContext context, ChosenImage bodyState) async {
    bool status = false;
    String snackbarMessage = "";
    try {
      bool fileDeletedFromFirestore = false;
      fileDeletedFromFirestore = await FirestoreFilesAccess()
          .deleteFileFromPath(
              UserDatabaseHelper().getPathForCurrentUserDisplayPicture());
      if (fileDeletedFromFirestore == false) {
        throw "CouldnotDeleteFile".tr;
      }
      status = await UserDatabaseHelper().removeDisplayPictureForCurrentUser();
      if (status == true) {
        snackbarMessage = "PictureRemovedSuccessfully".tr;
      } else {
        throw "CoulndotRemovedImage".tr;
      }
    } on FirebaseException catch (e) {
     // Logger().w("Firebase Exception: $e");
      snackbarMessage = "SomethingWentWrong".tr;
    } catch (e) {
     // Logger().w("Unknown Exception: $e");
      snackbarMessage = "SomethingWentWrong".tr;
    } finally {
      //Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
    }
  }
}


class ChosenImage extends ChangeNotifier {
  File? _chosenImage;

  File? get chosenImage => _chosenImage;
  set setChosenImage(File img) {
    _chosenImage = img;
    notifyListeners();
  }
}
