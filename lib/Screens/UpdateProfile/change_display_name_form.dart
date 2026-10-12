
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:visit_egypt/Components/default_button.dart';
import 'package:visit_egypt/Services/Authentication/authentificationService.dart';
import 'package:visit_egypt/Services/database/user_database_helper.dart';
import 'package:visit_egypt/constants/constants.dart';

class ChangeDisplayNameForm extends StatefulWidget {


  @override
  _ChangeDisplayNameFormState createState() => _ChangeDisplayNameFormState();
}

class _ChangeDisplayNameFormState extends State<ChangeDisplayNameForm> {

  final TextEditingController newDisplayNameController =
      TextEditingController();

  final TextEditingController currentDisplayNameController =
      TextEditingController();

  @override
  void dispose() {
    newDisplayNameController.dispose();
    currentDisplayNameController.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
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
                  "updateName".tr,
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
                        child: buildCurrentDisplayNameField(),
                      ),
                      SizedBox(height:40),
                      Padding(
                        padding: const EdgeInsets.only(right:12.0,left: 12),
                        child: buildNewDisplayNameField(),
                      ),
                      SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.only(right:12.0,left: 12),
                        child: DefaultButton(
                          text: "ChangeDisplayName".tr,
                          press: () {
                            final uploadFuture = changeDisplayNameButtonCallback();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return FutureProgressDialog(
                                  uploadFuture,
                                  message: Text("UpdatingDisplayName".tr),
                                );
                              },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("DisplayNameUpdated".tr)));
                          },
                        ),
                      ),
                    ],
                  ),
                ),                ],
            ),
          ),
        ),
      )

    );
  }

  Widget buildNewDisplayNameField() {
    return TextFormField(
      controller: newDisplayNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "EnterNewDisplayName".tr,
        labelText: "NewDisplayName".tr,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (newDisplayNameController.text.isEmpty) {
          return "DisplayNameCannotBeEmpty".tr;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentDisplayNameField() {
    return StreamBuilder<User?>(
      stream: AuthentificationService().userChanges,
      builder: (context, snapshot) {
        String displayName = "";
        if (snapshot.hasData && snapshot.data != null)
          displayName = snapshot.data!.displayName!;
        final textField = TextFormField(
          controller: currentDisplayNameController,
          decoration: InputDecoration(
            hintText: "NoDisplayNameAvailable".tr,
            labelText: "CurrentDisplayName".tr,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.person),
          ),
          readOnly: true,
        );
        if (displayName != ""){
          currentDisplayNameController.text = displayName;
        }
        return textField;
      },
    );
  }

  Future<void> changeDisplayNameButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await AuthentificationService()
          .updateCurrentUserDisplayName(newDisplayNameController.text);
      await UserDatabaseHelper()
          .updateNameForCurrentUser(newDisplayNameController.text);
      print("DisplayNameUpdatedTo".tr +" ${newDisplayNameController.text} ...");
    }
  }
}
