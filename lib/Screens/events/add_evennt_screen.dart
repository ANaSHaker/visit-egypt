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

class AddEventScreen extends StatelessWidget {

  var titleArController = TextEditingController();
  var titleEnController = TextEditingController();
  var descriptionArController = TextEditingController();
  var descriptionEnController = TextEditingController();
  var paymentController = TextEditingController();
  var timeDateController = TextEditingController();
  var locationController = TextEditingController();
  var websiteController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var categoryController = TextEditingController();
  var endTimeDateController = TextEditingController();
var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: BlocProvider.of<EventsCubit>(context),
      child: BlocConsumer<EventsCubit, EventsStates>(
        listener: (context, state) {
          if(state is sendEventSuccess){
            showToast("Send Successfully".tr,context: context,backgroundColor: Colors.green);
            Navigator.pop(context);
          }
          if(state is sendEventError){
            showToast("Failed sent".tr,context: context,backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: primaryColor
              ),
              title: Text("Add Event".tr, style: GoogleFonts.cairo(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body:(state is sendEventLoading)? Center(child: LoadingBouncingGrid.square(backgroundColor: primaryColor,)): Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          child: EventsCubit.get(context).file == null
                              ? SizedBox()
                              : Image.file(File(EventsCubit.get(context).file!.path!)),
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
                              await EventsCubit.get(context).openFileExplorer();
                              if (EventsCubit.get(context).result != null) {
                                print(EventsCubit.get(context).file!.path);
                                EventsCubit.get(context).file =EventsCubit.get(context).result!.files.single;
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
                                    value: EventsCubit.get(context).valueeeeeee,onChanged: (val){
                                    EventsCubit.get(context).changevalueeeeeee(val);
                                    categoryController.text = EventsCubit.get(context).valueeeeeee.toString();
                                  },hint: Text("Choose Category"),
                                    items: EventsCubit.get(context).categoriesEventModel!.data!.map((e){
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("Start Time and date of event".tr,
                                style: GoogleFonts.cairo(
                                    color: primaryColor),),
                            ),
                            TextFormField(
                              showCursor: true,
                              readOnly: true,
                              onTap: () {
                                BottomPicker.dateTime(
                                    title: "Start the time and date".tr,
                                    onSubmit: (val) {
                                     EventsCubit.get(context).saveStartDateTime(val);
                                     timeDateController.text = val.toString();
                                    },
                                    use24hFormat: false,
                                    bottomPickerTheme: BOTTOM_PICKER_THEME
                                        .BLUE
                                ).show(context);
                              },
                              controller: timeDateController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  hintText: "Time".tr),
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("End Time and date of event".tr,
                                style: GoogleFonts.cairo(
                                    color: primaryColor),),
                            ),
                            TextFormField(
                              showCursor: true,
                              readOnly: true,
                              onTap: () {
                                BottomPicker.dateTime(
                                    title: "End Time and date of event".tr,
                                    onSubmit: (val) {
                                      EventsCubit.get(context).saveEndDateTime(val);
                                      endTimeDateController.text = val.toString();
                                    },
                                    use24hFormat: false,
                                    bottomPickerTheme: BOTTOM_PICKER_THEME
                                        .BLUE
                                ).show(context);
                              },
                              controller: endTimeDateController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  hintText: "Time".tr),
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Free?".tr, style: GoogleFonts.cairo(
                              fontSize: 16, fontWeight: FontWeight.bold,),),
                            Expanded(
                              child: SwitchListTile(value: (EventsCubit
                                  .get(context)
                                  .value), onChanged: (val) {
                                EventsCubit.get(context).changeValue(val);
                                if ((EventsCubit
                                    .get(context)
                                    .value))
                                  paymentController.text = "";
                              }),
                            ),
                          ],
                        ),
                        if((EventsCubit
                            .get(context)
                            .value))
                          textForm(context,title: "Cost of event",
                              hint: "Cost",
                              controller: paymentController,
                              textType: TextInputType.number),
                        SizedBox(height: 15,),
                        textForm(context,title: "Location of event",
                            hint: "Location",
                            controller: locationController),
                        SizedBox(height: 15,),
                        textForm(context,title: "website of event",
                            hint: "website",
                            controller: websiteController),
                        SizedBox(height: 15,),
                        textForm(context,title: "email of event",
                            hint: "Email",
                            controller: emailController),
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
                          EventsCubit.get(context).upLoadEvent(
                            startDate: timeDateController.text,
                            endDate: endTimeDateController.text,
                            location: locationController.text,
                            phone: phoneController.text,
                            email: emailController.text,
                            user_id:uid,
                            websiteLink: websiteController.text,
                            catergory: categoryController.text,
                            price: paymentController.text,
                            discAr: descriptionArController.text,
                            discEn: descriptionEnController.text,
                            titleAr: titleArController.text,
                            titleEn: titleEnController.text,
                            file: (EventsCubit.get(context).file as PlatformFile),
                          ).then((value) {
                            EventsCubit.get(context).file = null;
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