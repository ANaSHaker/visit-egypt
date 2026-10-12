


import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Models/all_companies_model.dart';
import 'package:visit_egypt/Screens/companies/cubit/cubit.dart';
import 'package:visit_egypt/Screens/companies/cubit/states.dart';
import 'package:visit_egypt/Screens/companies/noSqlHelper/favourite_company_model.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'all_comments_screen.dart';

class TransportationScreen extends StatelessWidget {
  var textController =TextEditingController();
   Duration transitionDuration = Duration(milliseconds: 250);
   Curve transitionCurve= Curves.decelerate;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context){

    return BlocProvider(
      create:(context)=> TransportationCubit()..getAllCompanies(),
    child: BlocConsumer<TransportationCubit,TransportationStates>(
      builder: (context,state){
        if(state is getPostsLoadingState){
          return LoadingScreen();
        }
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: primaryColor
            ),
            centerTitle: true,
            title:  Text("Transportation Companies".tr,style: GoogleFonts.cairo(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: transitionDuration,
                  switchInCurve: transitionCurve,
                  switchOutCurve: transitionCurve,
                  transitionBuilder: (child, animation) {
                    return FadeScaleTransition(
                      child: child,
                      animation: animation,
                    );
                  },
                  child: TransportationCubit.get(context).searching
                      ? Icon(
                    Icons.close,
                    key: ValueKey<String>("icon2"),
                  )
                      : Icon(
                    Icons.search,
                    key: ValueKey<String>("icon1"),
                  ),
                ),
                onPressed: () {
                  TransportationCubit.get(context).isSearch();
                },
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
              )
            ],
          ),
          body:TransportationCubit.get(context).companyModel == null? LoadingScreen()
              : RefreshIndicator(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
            color: Colors.white,
            onRefresh: () async{
              await TransportationCubit.get(context)..getAllCompanies();
            },

            child: ListView(
              children: [
                TransportationCubit.get(context).searching
                    ? TransportationCubit.get(context).Titlesearch(textController, Theme.of(context).brightness == Brightness.dark ?Colors.black.withOpacity(0.3):Colors.grey.shade300)
                    :Container(),
                TransportationCubit
                    .get(context)
                    .companyModel!.data!.isNotEmpty ?   Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: grid(context),
                ): Center(child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 250.0),
                  child: Text("No Data here yet".tr,
                    style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),),
                ),),
              ],
            ),
          ),
        );
      },
    listener: (context,state){
      if(state is removedFromFavSuccess){
      //  showToast("Done successfully".tr,context: context,textStyle: GoogleFonts.cairo());
      }
      if(state is addFavState){
        showToast("Added successfully".tr,context: context,textStyle: GoogleFonts.cairo());
      }
    },
    ),
    );
  }
}
Widget companyWidget(Data? model,index,context) {
  Box favouriteFavBox = Hive.box<DataFav>('favBox');

  return AnimatedWidgets(
    delay: 300,
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme
                .of(context)
                .brightness == Brightness.dark ? Colors.black12 : Colors.grey
                .shade100,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(1, 1),
          ),
        ]
        , borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: FlipCard(
        fill: Fill.fillBack,
        // Fill the back side of the card to make in the same size as the front.
        direction: FlipDirection.HORIZONTAL,
        // default
        front: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Image.network((model!.image ?? ""), fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                  colorBlendMode: BlendMode.dstIn,
                  loadingBuilder: (BuildContext context, Widget? child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child!;
                    return Center(
                      child: Icon(Icons.image, size: 60,),
                    );
                  },
                  errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                    return  Center(
                      child: Icon(Icons.image, size: 60,),
                    );
                  },),
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: () {
                  launch('tel:${model.contactLink}');
                }, icon: Icon(Icons.phone, color: primaryColor,),
                ),

                IconButton(onPressed: () {
                  launch('${model.websiteLink}');
                }, icon: Icon(Icons.public, color: primaryColor,),
                ),
              ],
            ),
            InkWell(
              child: Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Show All comments".tr, style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                    textAlign: TextAlign.center,),
                ),
              ),
              onTap: () {
                print(model.id);
                Get.to(AllComments(model));
                }
            ),
          ],
        ),
        back: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (model.description ?? ""), style: GoogleFonts.cairo(),overflow: TextOverflow.ellipsis, maxLines: 5,),
                    InkWell(child: Text("Read More".tr),onTap: (){
                       showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: new Text("Description".tr),
                                content: new Text(model.description ?? ""),
                                actions: <Widget>[
                                  new FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: new Text("Close".tr))
                                ]);
                          });
                    },),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RatingBarIndicator(
                itemBuilder: (context, index) {
                  return Icon(Icons.star_border, color: Colors.amber,);
                },
                rating: ((model.rate ?? 5) / 1),
                itemCount: 5,
                itemSize: 15,
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(child: CircleAvatar(
                      child: Icon(Icons.favorite_border),
                      backgroundColor: favouriteFavBox.containsKey(model.id)
                          ? Colors.red
                          : Colors.grey),
                    onTap: () {
                      TransportationCubit.get(context).onPressFav(id: model.id,
                          websiteLink: model.websiteLink,
                          updatedAt: model.updatedAt,
                          rate: model.rate,
                          createdAt: model.createdAt,
                          contactLink: model.contactLink,
                          name: model.name,
                          image: model.image,
                          type: model.type,
                          description: model.description);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),),
    ),
  );
}
Widget grid(context)=>new StaggeredGridView.countBuilder(
  physics: NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  crossAxisCount: 4,
  itemCount: TransportationCubit.get(context).companyModelSearch!.length,
  itemBuilder: (BuildContext context, int index) =>
      companyWidget(TransportationCubit.get(context).companyModelSearch![index],index,context),
  staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 3.2 : 3.6),
  mainAxisSpacing: 15.0,
  crossAxisSpacing: 40.0,
);
ShowSuccessDialog({context,Data? model,index}){
  return showDialog(
    context: context,
    builder: (_) => AssetGiffyDialog(
      image: Image.asset('assets/gifs/success.gif',alignment: Alignment.center,fit: BoxFit.contain,),
      title: Text((model!.name??""),style: GoogleFonts.cairo(
          height: 1.5),
      ),
      description: Text(
      (model.description??""),style: GoogleFonts.cairo(
          height: 1.5
      )
        ,),
      buttonCancelColor: Colors.grey,
      buttonOkColor: primaryColor,
      buttonOkText: Text("ok".tr,style: GoogleFonts.cairo(
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
