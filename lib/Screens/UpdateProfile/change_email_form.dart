import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:visit_egypt/Components/default_button.dart';
import 'package:visit_egypt/Services/Authentication/authentificationService.dart';
import 'package:visit_egypt/Services/database/user_database_helper.dart';

import '../../constants/constants.dart';

class ChangeEmailForm extends StatefulWidget {
  @override
  _ChangeEmailFormState createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    currentEmailController.dispose();
    newEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
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
                    "updateEmail".tr,
                    style: headingStyle,
                  ),
                  SizedBox(height: 10 * 0.1),
                  Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:12.0,left: 12),
                      child: buildCurrentEmailFormField(),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right:12.0,left: 12),
                      child: buildNewEmailFormField(),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right:12.0,left: 12),
                      child: buildPasswordFormField(),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(right:12.0,left: 12),
                      child: DefaultButton(
                        text: "ChangeEmail".tr,
                        press: () {
                          final updateFuture = changeEmailButtonCallback();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return FutureProgressDialog(
                                updateFuture,
                                message: Text("UpdatingEmail".tr),
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

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password".tr,
        labelText: "EnterPassword".tr,
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
      validator: (value) {
        if (passwordController.text.isEmpty) {
          return "PasswordCannotBeEmpty".tr;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentEmailFormField() {
    return StreamBuilder<User?>(
      stream: AuthentificationService().userChanges,
      builder: (context, snapshot) {
        String currentEmail= "";
        if (snapshot.hasData && snapshot.data != null)
          currentEmail = snapshot.data!.email!;
        final textField = TextFormField(
          controller: currentEmailController,
          decoration: InputDecoration(
            hintText: "CurrentEmail".tr,
            labelText: "CurrentEmail".tr,
            floatingLabelBehavior: FloatingLabelBehavior.always,

          ),
          readOnly: true,
        );
        if (currentEmail != "") currentEmailController.text = currentEmail;
        return textField;
      },
    );
  }

  Widget buildNewEmailFormField() {
    return TextFormField(
      controller: newEmailController,
      decoration: InputDecoration(
        hintText: "EnterNewEmail".tr,
        labelText: "NewEmail".tr,
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
      validator: (value) {
        if (newEmailController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(newEmailController.text)) {
          return kInvalidEmailError;
        } else if (newEmailController.text == currentEmailController.text) {
          return "EmailIsAlreadyLinkedToAccount".tr;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> changeEmailButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final AuthentificationService authService = AuthentificationService();
      bool passwordValidation =
          await authService.verifyCurrentUserPassword(passwordController.text);

      if (passwordValidation) {
        bool updationStatus = false;
        String snackbarMessage;
          updationStatus = await authService.changeEmailForCurrentUser(
              newEmail: newEmailController.text);
          updationStatus = await UserDatabaseHelper()
              .updatePhoneForCurrentUser(newEmailController.text);
          if (updationStatus == true) {
            snackbarMessage =
                "VerificationEmailSentPleaseVerifyYourNewEmail".tr;
          } else {
            throw "CouldnotProcessYourRequestNowPleaseTryAgainLater".tr;
          }

      }
    }
  }
}
