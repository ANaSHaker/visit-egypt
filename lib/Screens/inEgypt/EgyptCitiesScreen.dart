import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:visit_egypt/Screens/inEgypt/cubit/cubit.dart';
import 'package:visit_egypt/Screens/inEgypt/cubit/states.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'categories_cities_screen.dart';



class CitiesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    return BlocProvider.value(value: BlocProvider.of<inEgyptCubit>(context)..getAllCities(),
      child: BlocConsumer<inEgyptCubit,inEgyptStates>(
        builder: (context,state){

          if(state is loadinginEgyptesState){
            return LoadingScreen();
          }
          if(inEgyptCubit.get(context).egyptCities == null){
            return LoadingScreen();
          }else {
            var cubit = inEgyptCubit.get(context).egyptCities!;

            return RefreshIndicator(
              backgroundColor: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.6),
              color: Colors.white,
              onRefresh: () async {
                await inEgyptCubit.get(context)
                  ..getAllCities();
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8),
                  child: ListView(
                    children: [

                      GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                            childAspectRatio: 1.46,mainAxisSpacing: 12,),
                          itemBuilder: (context, index) =>
                              AnimatedWidgets(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0 ),
                                  child: InkWell(
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                      child: Container(
                                        width: 100,
                                        height: 70,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                            image: DecorationImage(
                                              image: NetworkImage( cubit.data![index].image ?? "",),
                                              fit: BoxFit.fill,



                                            )
                                        ),
                                        child: Text( cubit.data![index].name!.capitalize ?? "",
                                          style: GoogleFonts.cairo(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            color: Colors.white
                                          ),),
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(
                                          AllCategoriesCities(inEgyptCubit
                                          .get(context)
                                          .egyptCities!
                                          .data![index].id.toString()));
                                    },
                                  ),
                                ),
                                delay: 300,
                              ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),

                          itemCount: inEgyptCubit
                              .get(context)
                              .egyptCities!
                              .data!
                              .length),
                    ],
                  )
              ),
            );
          }
        },
        listener: (context,state){
          if(state is removedFromFavSuccess){
            // showToast("Done successfully".tr,context: context,textStyle: GoogleFonts.cairo());
          }
          if(state is addFavState){
            showToast("Added successfully".tr,context: context,textStyle: GoogleFonts.cairo());
          }
        },
      ),
    );
  }
}