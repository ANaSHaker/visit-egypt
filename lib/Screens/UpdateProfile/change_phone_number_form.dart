import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
//import 'package:logger/logger.dart';
import 'package:visit_egypt/Components/default_button.dart';
import 'package:visit_egypt/Services/database/user_database_helper.dart';
import 'package:visit_egypt/constants/constants.dart';

class ChangePhoneNumberForm extends StatefulWidget {


  @override
  _ChangePhoneNumberFormState createState() => _ChangePhoneNumberFormState();
}

class _ChangePhoneNumberFormState extends State<ChangePhoneNumberForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newPhoneNumberController =
      TextEditingController();
  final TextEditingController currentPhoneNumberController =
      TextEditingController();

  @override
  void dispose() {
    newPhoneNumberController.dispose();
    currentPhoneNumberController.dispose();
    super.dispose();
  }

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
                    "updatePhone".tr,
                    style: headingStyle,
                  ),
                  SizedBox(height: 10 * 0.1),
                  Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right:12.0,left: 12),
                      child: buildCurrentPhoneNumberField(),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right:12.0,left: 12),
                      child: buildNewPhoneNumberField(),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(right:12.0,left: 12),
                      child: DefaultButton(
                        text: "ChangePhoneNumber".tr,
                        press: () {
                          final updateFuture = updatePhoneNumberButtonCallback();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return FutureProgressDialog(
                                updateFuture,
                                message: Text("UpdatingPhoneNumber".tr),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
                ],
              ),
            ),
          ),
        )

    );
  }

  Future<void> updatePhoneNumberButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool status = false;
      String? snackbarMessage ;
      try {
        status = await UserDatabaseHelper()
            .updatePhoneForCurrentUser(newPhoneNumberController.text);

        if (status == true) {
          snackbarMessage = "PhoneUpdatedSuccessfully".tr;
        } else {
          throw "CoulndontUpdatePhone".tr;
        }
      } on FirebaseException catch (e) {
        //Logger().w("Firebase Exception: $e");
        snackbarMessage = "SomethingWentWrong".tr;
      } catch (e) {
       // Logger().w("Unknown Exception: $e");
        snackbarMessage = "SomethingWentWrong".tr;
      } finally {
       // Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage!),
          ),
        );
      }
    }
  }

  Widget buildNewPhoneNumberField() {
    return TextFormField(
      controller: newPhoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "EnterNewPhoneNumber".tr,
        labelText: "NewPhoneNumber".tr,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
      validator: (value) {
        if (newPhoneNumberController.text.isEmpty) {
          return "PhoneNumberCannotBeEmpty".tr;
        } else if (newPhoneNumberController.text.length != 11) {
          return "Only10DigitsAllowed".tr;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPhoneNumberField() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
         // Logger().w(error.toString());
        }
        String currentPhone = "";
        if (snapshot.hasData && snapshot.data != null)
          currentPhone = snapshot.data![UserDatabaseHelper.PHONE_KEY].toString();
        final textField = TextFormField(
          controller: currentPhoneNumberController,
          decoration: InputDecoration(
            hintText: "NoPhoneNumberAvailable".tr,
            labelText: "CurrentPhoneNumber".tr,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.phone),
          ),
          readOnly: true,
        );
        if (currentPhone != "")
          currentPhoneNumberController.text = currentPhone;
        return textField;
      },
    );
  }
}
