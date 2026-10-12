import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:visit_egypt/Widgets/AddTextField.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AddCultureScreen extends StatelessWidget {

  var titleArController = TextEditingController();

  var titleEnController = TextEditingController();

  var descriptionArController = TextEditingController();

  var descriptionEnController = TextEditingController();

  var rateController = TextEditingController();

  var linkController = TextEditingController();

  var mainCharacterController = TextEditingController();

  var categoryController = TextEditingController();

  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: BlocProvider.of<CultureCubit>(context)..getCategoriesCultur(),
      child: BlocConsumer<CultureCubit, CultureStates>(
        listener: (context, state) {
          if(state is UploadCultureStateSuccess){
            showToast("Send Successfully".tr,context: context,backgroundColor: Colors.green);
            Navigator.pop(context);
          }
          if(state is UploadCultureStateError){
            showToast("Failed sent".tr,context: context,backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: primaryColor),
              title: Text(
                "Add Culture".tr,
                style: GoogleFonts.cairo(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: (state is UploadCultureStateLoading)
                ? Center(
                    child: LoadingBouncingGrid.square(
                    backgroundColor: primaryColor,
                  ))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ListView(
                      children: [
                        Center(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                child:CultureCubit.get(context).file == null
                                    ? SizedBox()
                                    : Image.file(File(CultureCubit.get(context).file!.path!)),
                                width: 350,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: CircleAvatar(
                                  child: IconButton(
                                    onPressed: () async {
                                      await CultureCubit.get(context).openFileExplorer();
                                      if (CultureCubit.get(context).result != null) {
                                        CultureCubit.get(context).file = CultureCubit.get(context).result!.files.single;
                                      }
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              textForm(context,
                                  title: "TitleEnglish",
                                  hint: "TitleArabic",
                                  controller: titleArController),
                              SizedBox(
                                height: 15,
                              ),
                              textForm(context,
                                  title: "TitleEnglish",
                                  hint: "TitleEnglish",
                                  controller: titleEnController),
                              SizedBox(
                                height: 15,
                              ),
                              textForm(context,
                                  title: "DescriptionArabic",
                                  hint: "DescriptionArabic",
                                  controller: descriptionArController),
                              SizedBox(
                                height: 15,
                              ),
                              textForm(context,
                                  title: "DescriptionEnglish",
                                  hint: "DescriptionEnglish",
                                  controller: descriptionEnController),
                              SizedBox(
                                height: 15,
                              ),
                              textForm(context,
                                  title: "mainCharacter",
                                  hint: "mainCharacter",
                                  controller: mainCharacterController),
                              SizedBox(
                                height: 15,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Category of event'.tr,style: GoogleFonts.cairo(
                                            fontSize: 14,fontWeight: FontWeight.bold),),
                                        DropdownButton(
                                          elevation: 3,
                                          isDense: true,
                                          value: CultureCubit.get(context).valueee,
                                          onChanged: (val){
                                          CultureCubit.get(context).changeValueee(val);
                                          categoryController.text = CultureCubit.get(context).valueee.toString();
                                        },
                                          hint: Text("Choose Category"),
                                          items: CultureCubit.get(context).categoriesCultureModel!.data!.map((e){
                                            return DropdownMenuItem(
                                              value: e.id,
                                              child: Text((e.name??"")),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              textForm(context,
                                  title: "rate of event",
                                  hint: "rate",
                                  controller: rateController,textType: TextInputType.number),
                              SizedBox(
                                height: 15,
                              ),
                              textForm(context,
                                  title: "link",
                                  hint: "link",
                                  controller: linkController),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: MaterialButton(
                              onPressed: () async {
                               await CultureCubit.get(context)
                                    .upLoadCulture(file: (CultureCubit.get(context).file as PlatformFile),rate: rateController.text,category: categoryController.text,mainchar: mainCharacterController.text,discAr: descriptionArController.text,discEn: descriptionEnController.text,titleAr: titleArController.text,titleEn: titleEnController.text,link: linkController.text).then((value) {
                                 CultureCubit.get(context).file = null;
                               });
                              },
                              child: Text(
                                "Send".tr,
                                style: GoogleFonts.cairo(fontSize: 20),
                              ),
                              color: primaryColor,
                              height: 50,
                            )),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

ShowSuccessDialog({context}) {
  return showDialog(
    context: context,
    builder: (_) => AssetGiffyDialog(
      image: Image.asset(
        'assets/gifs/success.gif',
        alignment: Alignment.center,
        fit: BoxFit.contain,
      ),
      title: Text(
        "Sent successfully!".tr,
        style: GoogleFonts.cairo(height: 1.5),
      ),
      description: Text(
        "Sent successfully!".tr,
        style: GoogleFonts.cairo(height: 1.5),
      ),
      buttonCancelColor: Colors.grey,
      buttonOkColor: primaryColor,
      buttonOkText: Text(
        "ok".tr,
        style: GoogleFonts.cairo(fontWeight: FontWeight.w600, height: 1),
      ),
      buttonRadius: 5,
      cornerRadius: 25,
      onOkButtonPressed: () {
        Get.back();
      },
      entryAnimation: EntryAnimation.BOTTOM_RIGHT,
      onlyOkButton: true,
    ),
  );
}
