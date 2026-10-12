import 'dart:io';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:visit_egypt/Widgets/AddTextField.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AddPlaceScreen extends StatelessWidget {

  var titleArController = TextEditingController();
  var titleEnController = TextEditingController();
  var descriptionArController = TextEditingController();
  var descriptionEnController = TextEditingController();
  var locationController = TextEditingController();
  var websiteController = TextEditingController();
  var phoneController = TextEditingController();
  var categoryController = TextEditingController();
  var rateController = TextEditingController();
  var cityController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: BlocProvider.of<inEgyptCubit>(context),
      child: BlocConsumer<inEgyptCubit, inEgyptStates>(
        listener: (context, state) {
          if(state is sendinEgypteSuccess){
            Navigator.pop(context);
            showToast("Send Successfully".tr,context: context,backgroundColor: Colors.green);
          }
          if(state is postCommentSuccessState){
            Navigator.pop(context);
            showToast("Send Successfully".tr,context: context,backgroundColor: Colors.green);
          }
          if(state is sendinEgypteError){
            showToast("Failed sent".tr,context: context,backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: primaryColor
              ),
              title: Text("Add Place".tr, style: GoogleFonts.cairo(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body:(state is sendinEgypteLoading)? Center(child: LoadingBouncingGrid.square(backgroundColor: primaryColor,)): Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: ListView(
                children: [

                  Center(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          child: inEgyptCubit.get(context).file == null
                              ? SizedBox()
                              : Image.file(File(inEgyptCubit.get(context).file!.path!)),
                          width: 350, height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: CircleAvatar(
                            child: IconButton(onPressed: ()async {
                              await inEgyptCubit.get(context).openFileExplorer();
                              if (inEgyptCubit.get(context).result != null) {
                                inEgyptCubit.get(context).file =inEgyptCubit.get(context).result!.files.single;
                              }
                            }, icon: Icon(Icons.add),),),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        textForm(context,title: "Title of event",
                            hint: "TitleArabic",
                            controller: titleArController),

                        SizedBox(height: 15,),
                        textForm(context,title: "Title of event",
                            hint: "TitleEnglish" ,
                            controller: titleEnController),

                        SizedBox(height: 15,),
                        textForm(context,title: "Description of event",
                            hint: "DescriptionArabic",
                            controller: descriptionArController),

                        SizedBox(height: 15,),
                        textForm(context,title: "Description of event",
                            hint: "DescriptionEnglish",
                            controller: descriptionEnController),

                        SizedBox(height: 15,),
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
                                    value: inEgyptCubit.get(context).valueCategory,
                                    onChanged: (val){
                                    inEgyptCubit.get(context).changevalueCat(val);
                                    categoryController.text = inEgyptCubit.get(context).valueCategory.toString();
                                  },hint: Text("Choose Category"),
                                    items: inEgyptCubit.get(context).allCategoriesAddPlaces!.data!.map((e){
                                      return DropdownMenuItem(
                                        value: e.id,
                                        child: Text((e.name??"")),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('city'.tr,style: GoogleFonts.cairo(
                                      fontSize: 14,fontWeight: FontWeight.bold),),
                                  DropdownButton(
                                    elevation: 3,
                                    isDense: true,
                                    value: inEgyptCubit.get(context).valueCity,onChanged: (val){
                                    inEgyptCubit.get(context).changevalueCity(val);
                                    cityController.text = inEgyptCubit.get(context).valueCity.toString();
                                  },hint: Text("Choose City".tr),
                                    items: inEgyptCubit.get(context).egyptCities!.data!.map((e){
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
                        SizedBox(height: 15,),
                        textForm(context,
                            title: "rate of event",
                            hint: "rate",
                            controller: rateController,textType: TextInputType.number),
                        SizedBox(
                          height: 15,
                        ),
                        textForm(context,title: "Location of event",
                            hint: "Location",
                            controller: locationController),
                        SizedBox(height: 15,),
                        textForm(context,title: "website of event",
                            hint: "website",
                            controller: websiteController),

                        SizedBox(height: 15,),
                        textForm(context,title: "phone of event",
                            hint: "Phone",
                            textType: TextInputType.number,
                            controller: phoneController),
                        SizedBox(height: 15,),
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: MaterialButton(onPressed: () {
                        print(categoryController.text);
                        if(formKey.currentState!.validate()) {
                          inEgyptCubit.get(context).upLoadPlace(

                            location: locationController.text,
                            phone: phoneController.text,
                            user_id:uid,
                            websiteLink: websiteController.text,
                            catergory: categoryController.text,
                            city: cityController.text,
                            rate: rateController.text,
                            discAr: descriptionArController.text,
                            discEn: descriptionEnController.text,
                            titleAr: titleArController.text,
                            titleEn: titleEnController.text,
                            file: (inEgyptCubit.get(context).file as PlatformFile),
                          ).then((value) {
                            inEgyptCubit.get(context).file = null;
                          });
                        }else
                          showToast("Please fill all fields !".tr,context: context,backgroundColor: Colors.red);
                      },
                        child: Text("Send".tr,
                          style: GoogleFonts.cairo(fontSize: 20),),
                        color: primaryColor,
                        height: 50,)),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


/* Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "$title".tr, style: GoogleFonts.cairo(color: primaryColor),),
        ),
        TextFormField(
          keyboardType: textType,
          controller: controller,
          decoration: InputDecoration(border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)),
              hintText: "$hint".tr),
        ),
      ],
    );*/

ShowSuccessDialog({context}) {
  return showDialog(
    context: context,
    builder: (_) =>
        AssetGiffyDialog(
          image: Image.asset(
            'assets/gifs/success.gif', alignment: Alignment.center,
            fit: BoxFit.contain,),
          title: Text("Sent successfully!".tr, style: GoogleFonts.cairo(
              height: 1.5),
          ),
          description: Text(
            "Sent successfully!".tr, style: GoogleFonts.cairo(
              height: 1.5
          )
            ,),
          buttonCancelColor: Colors.grey,
          buttonOkColor: primaryColor,
          buttonOkText: Text("ok".tr, style: GoogleFonts.cairo(
              fontWeight: FontWeight.w600,
              height: 1
          ),),
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