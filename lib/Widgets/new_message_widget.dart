import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visit_egypt/constants/constants.dart';

import '../Services/database/chat_database.dart';

class NewMessageWidget extends StatefulWidget {
  final String idUser;

  const NewMessageWidget({
    required this.idUser,
  });

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    if (message != '') {
      await FirebaseApi.uploadMessage("9OkAwTgpsAeLishqCuk6TSJWigD2", message)
          .whenComplete(() {
        setState(() {
          message = '';
        });
      });
    }
    _controller.clear();
  }

  void sendMessageAdmin() async {
    FocusScope.of(context).unfocus();
    if (message != '') {
      await FirebaseApi.uploadMessageAdmin("hO70BESHFKlxoD5jdXGG", message)
          .whenComplete(() {
        message = '';
      });
    }

    _controller.clear();
  }

  File? imageFile;
  ImagePicker picker = ImagePicker();

  Future getImage() async {
    setState(() async {
      await picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          imageFile = File(xFile.path);
          widget.idUser == "hO70BESHFKlxoD5jdXGG"
              ? uploadImageAdmin()
              : uploadImage();
        }
      });
    });
  }

  Future uploadImage() async {
    showToast(
      "Uploading..".tr,
      borderRadius: BorderRadius.circular(5),
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: Duration(milliseconds: 600),
    );
    String fileName = path.basename(imageFile!.path);
    print(fileName);
    int status = 1;
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!);

    if (status == 1) {
      String? imageUrl = await uploadTask.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('chats')
          .doc("9OkAwTgpsAeLishqCuk6TSJWigD2")
          .collection('messages')
          .doc()
          .set({
        "username": FirebaseAuth.instance.currentUser!.displayName,
        "message": imageUrl,
        "type": "img",
        "idUser": "${FirebaseAuth.instance.currentUser!.uid}",
        "createdAt": FieldValue.serverTimestamp(),
      }).then((value) {
        showToast(
          "Uploaded Successfully".tr,
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 250),
        );
      }).catchError((e){
        showToast(
          e,
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 250),
        );
      });
      print("$imageUrl ");
    }
  }

  Future uploadImageAdmin() async {
    showToast(
      "Uploading..".tr,
      borderRadius: BorderRadius.circular(5),
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: Duration(milliseconds: 600),
    );
    String fileName = path.basename(imageFile!.path);
    print(fileName);
    int status = 1;
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!);

    if (status == 1) {
      String? imageUrl = await uploadTask.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Admin')
          .doc("${FirebaseAuth.instance.currentUser!.uid}")
          .collection('messages')
          .doc()
          .set({
        "username": FirebaseAuth.instance.currentUser!.displayName,
        "message": imageUrl,
        "type": "img",
        "fromType":"User",
        "idUser": "${FirebaseAuth.instance.currentUser!.uid}",
        "createdAt": FieldValue.serverTimestamp(),
      }).then((value) {
        showToast(
          "Uploaded Successfully".tr,
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 250),
        );
      }).catchError((e){
        showToast(
          e,
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 250),
        );
      });

      print("$imageUrl ");
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.grey[100],
                  labelText: 'Typeyourmessage'.tr,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () => getImage(),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Icon(Icons.picture_in_picture, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: message.trim().isEmpty
                  ? null
                  : (widget.idUser == "hO70BESHFKlxoD5jdXGG"
                      ? sendMessageAdmin
                      : sendMessage),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
