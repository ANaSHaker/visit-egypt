import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Screens/Culture/DetailsScreen.dart';
import 'package:visit_egypt/Screens/Culture/cubit/cubit.dart';
import 'package:visit_egypt/Screens/Culture/cubit/states.dart';
import 'package:visit_egypt/Screens/Culture/noSqlHelper/favourite_culture_model.dart';
import 'package:visit_egypt/Widgets/CultureCard.dart';

import 'package:visit_egypt/Widgets/animated_widget.dart';

Widget favouriteCultures()=> BlocProvider(
  create: (context)=>CultureCubit(),

  child:BlocConsumer<CultureCubit,CultureStates>(
    listener: (context,state){},
    builder: (context,state){

      return ValueListenableBuilder(
          valueListenable: Hive.box<DataFavCuluture>('favCultureBox').listenable(),
          builder: (context, Box<DataFavCuluture> box, _) {
            if(box.values.length == 0)
              return Center(child:Icon(FontAwesomeIcons.book),);
            else
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:    GridView.builder(

                  itemCount:box.values.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                    childAspectRatio: 1.02,mainAxisSpacing: 12,),
                  itemBuilder: (context,index){
                    DataFavCuluture? favItem = box.getAt(index);

                    Box favouriteFavBox = Hive.box<DataFavCuluture>('favCultureBox');

                    return AnimatedWidgets(
                      child: CultureCard(
                        favColor: favouriteFavBox.containsKey(favItem!.id)
                            ? Colors.red
                            : Colors.grey,
                        favPress: (){
                          CultureCubit.get(context).onPressFav(
                            id: favItem.id,
                            description: favItem.description,
                            image:favItem.image,
                            title:favItem.title,
                            rate:favItem.rate,
                            link:favItem.link,
                            mainCharacter:favItem.mainCharacter,

                          );
                        },

                        image: favItem.image ??
                            "",
                        title: favItem.title ?? "",
                        des: favItem
                            .description ?? "",
                        rating:  favItem
                            .rate ?? 3,
                        pressRead:(){
                          launch(favItem
                              .link ?? "");

                        },
                        pressDetails: (){ Get.to(()=>DetailsScreen(
                        ));},

                      ),
                      delay: 300,
                    );
                  },
                ),
              );
          }
      );
    },
  ),
);