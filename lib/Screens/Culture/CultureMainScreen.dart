import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:visit_egypt/Screens/Culture/add_culture_screen.dart';
import 'package:visit_egypt/Screens/Culture/cubit/cubit.dart';
import 'package:visit_egypt/Screens/Culture/cubit/states.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/Widgets/full_event_card.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'CultureContentScreen.dart';

class CultureMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CultureCubit>(context)
        ..getCategoriesCultur()
        ..getAllCultures(),
      child:
          BlocConsumer<CultureCubit, CultureStates>(listener: (context, state) {
        if (state is removedFromFavSuccess) {
          // showToast("Done successfully".tr,context: context,textStyle: GoogleFonts.cairo());
        }
        if (state is addFavState) {
          showToast("Added successfully".tr,
              context: context, textStyle: GoogleFonts.cairo());
        }
      }, builder: (context, state) {
        return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed:
                  CultureCubit.get(context).categoriesCultureModel != null
                      ? () {
                    uid != "" ?    Get.to(() => AddCultureScreen()):
                    showToast(
                      "سجل الدخول اولا",
                      borderRadius: BorderRadius.circular(5),
                      context: context,
                      animation: StyledToastAnimation.scale,
                      reverseAnimation: StyledToastAnimation.fade,
                      animDuration: Duration(milliseconds: 250),
                    );
                        }
                      : () {},
              icon: Icon(Icons.event_available_rounded),
              backgroundColor: primaryColor,
              label: Text(
                "Add Culture".tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
            body:(CultureCubit.get(context)
                .clutureModel == null)?LoadingScreen() : RefreshIndicator(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
              color: Colors.white,
              onRefresh: () async {
                await CultureCubit.get(context)
                  ..getAllCultures();
                await CultureCubit.get(context)
                  ..getCategoriesCultur();
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 4.0, left: 4),
                  child: ListView(
                    children: [
                      CultureCubit.get(context)
                          .clutureModel!.data!.isNotEmpty ?  ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemExtent: 150,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => AnimatedWidgets(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Container(

                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                CultureCubit.get(context).clutureModel!.data![index].image ?? "",
                                              ),
                                              fit: BoxFit.cover,
                                              colorFilter: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? ColorFilter.mode(
                                                      Colors.grey.shade800
                                                          .withOpacity(0.8),
                                                      BlendMode.dstATop)
                                                  : null,
                                            )),
                                        child: Text(
                                          CultureCubit.get(context).clutureModel!.data![index].title!.capitalize ?? "",
                                          style: GoogleFonts.cairo(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(() => CultureContentScreen(
                                          CultureCubit.get(context).clutureModel!.data![index].id.toString()));
                                      print(CultureCubit.get(context).clutureModel!.data![index].id.toString());
                                    },
                                  ),
                                ),
                                delay: 300,
                              ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: CultureCubit.get(context)
                              .clutureModel!
                              .data!
                              .length)
                      :  Center(child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 250.0),
                    child: Text("No Data here yet".tr,
                      style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),),
                  ),),

                    ],
                  )),
            ));
      }),
    );
  }
}
