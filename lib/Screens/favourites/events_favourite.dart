import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:visit_egypt/Screens/events/cubit/cubit.dart';
import 'package:visit_egypt/Screens/events/cubit/states.dart';
import 'package:visit_egypt/Screens/events/event_details.dart';
import 'package:visit_egypt/Screens/events/noSqlHelper/favourite_event_model.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/Widgets/full_event_card.dart';

Widget favouriteEvents()=> BlocProvider(
  create: (context)=>EventsCubit(),

  child:BlocConsumer<EventsCubit,EventsStates>(
    listener: (context,state){},
    builder: (context,state){

      return ValueListenableBuilder(
          valueListenable: Hive.box<EventFav>('favEventBox').listenable(),
          builder: (context, Box<EventFav> box, _) {
            if(box.values.length == 0)
              return Center(child:Icon(Icons.event),);
            else
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:  ListView.separated(
                  itemCount: box.values.length,
                  itemBuilder: (context,index){
                    EventFav? favItem = box.getAt(index);

                    Box favouriteFavBox = Hive.box<EventFav>('favEventBox');

                    return AnimatedWidgets(
                      child: InkWell(
                        child: FullEventCard(
                          imageLocation:favItem!.image ??
                              "",
                          eventName: favItem.title ?? "",
                          eventDetails: favItem.description ?? "",
                          category: favItem.catergory ??
                              "",
                          payment: favItem.payment == 0
                              ? "free".tr
                              : "ticketed".tr,
                          favColor: favouriteFavBox.containsKey(
                              favItem.id)
                              ? Colors.red
                              : Colors.grey,
                          fav: () {
                            EventsCubit.get(context).onPressFav(
                              id: favItem.id,
                              user_id: favItem.user_id,
                              title: favItem.title,
                              description: favItem.description,
                              startDate:favItem.startDate,
                              endDate: favItem.endDate,
                              phone: favItem.phone,
                              websiteLink: favItem.websiteLink,
                              email: favItem.email,
                              payment: favItem.payment,
                              catergory: favItem.catergory,
                              image:  favItem.image,
                              location: favItem.location,
                              price: favItem.price,);
                          },
                        ),
                        onTap: () {
                          Get.to(() =>
                              EventDetailPage(null,favItem.id,favItem.user_id,favItem.title,favItem.description,favItem.startDate,favItem.endDate,favItem.phone,
                                favItem.websiteLink,favItem.email,favItem.catergory,favItem.image,  favItem.location, favItem.price, favItem.payment,));
                        },
                      ),
                      delay: 300,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 5,),
                ),
              );
          }
      );
    },
  ),
);