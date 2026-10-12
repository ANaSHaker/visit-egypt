import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Screens/Culture/cubit/cubit.dart';
import 'package:visit_egypt/Screens/Culture/cubit/states.dart';
import 'package:visit_egypt/Screens/Culture/noSqlHelper/favourite_culture_model.dart';
import 'package:visit_egypt/Widgets/CultureCard.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';

import 'DetailsScreen.dart';

class CultureContentScreen extends StatelessWidget {
  String id;

  CultureContentScreen(this.id);
  var textController =TextEditingController();
  Box favouriteFavBox = Hive.box<DataFavCuluture>('favCultureBox');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context)=> CultureCubit()..getSpecificCulture(id),
      child: BlocConsumer<CultureCubit,CultureStates>(
        builder: (context,state){

          if(state is loadingCulturesState){
            return LoadingScreen();
          }
          if(CultureCubit.get(context).specificCultureModel == null){
            return LoadingScreen();
          }else {
            var cubit = CultureCubit.get(context).specificCultureModel!;
            return RefreshIndicator(
              backgroundColor: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.6),
              color: Colors.white,
              onRefresh: () async {
                await CultureCubit.get(context)
                  ..getSpecificCulture(id);
              },
              child: Scaffold(
                body: SafeArea(
                  child: Container(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 25, top: 40,right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Discover Latest We Have'.tr,
                                  style: GoogleFonts.cairo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            )),
                        CultureCubit.get(context).Titlesearch(context,textController,id),
                        SizedBox(height: 10,),
                        cubit.data!.isNotEmpty ?  GridView.builder(
                            itemCount: CultureCubit.get(context).cultureModelSearch!.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                          childAspectRatio: 1.06,mainAxisSpacing: 12,),
                            itemBuilder: (context, index) =>
                                AnimatedWidgets(
                                  child: CultureCard(
                                    favColor: favouriteFavBox.containsKey(cubit.data![index].id)
                                        ? Colors.red
                                        : Colors.grey,
                                    favPress: (){
                                      CultureCubit.get(context).onPressFav(
                                        id: cubit.data![index].id,
                                        description: cubit.data![index].description,
                                        image:cubit.data![index].image,
                                        title:cubit.data![index].title,
                                        rate:cubit.data![index].rate.toDouble(),
                                        link:cubit.data![index].link,
                                        mainCharacter:cubit.data![index].maincharacter,
                                      );
                                    },
                                    image: cubit.data![index].image ??
                                        "",
                                    title: cubit.data![index].title ?? "",
                                    des: cubit.data![index]
                                        .description ?? "",
                                    rating:  cubit.data![index].rate ?? 3,
                                    pressRead:(){
                                      launch(cubit.data![index]
                                          .link ?? "");
                                    },
                                    pressDetails: (){
                                      print(cubit.data![index].categoryId);
                                      Get.to(()=> DetailsScreen(
                                        cubit.data![index]
                                    ));},
                                  ),
                                  delay: 300,
                                ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            )
                        :Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 250.0),
                          child: Text("No Data here yet".tr,
                          style: GoogleFonts.cairo(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),),
                        ),),
                      ],
                    )
                  ),
                ),
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
