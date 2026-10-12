import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:visit_egypt/Screens/events/noSqlHelper/favourite_event_model.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/Widgets/full_event_card.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'add_evennt_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'event_details.dart';


class EventsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Box favouriteFavBox = Hive.box<EventFav>('favEventBox');

    return BlocProvider.value(value: BlocProvider.of<EventsCubit>(context)
      ..getAllEvents()..getCategoriesEvents(),
        child: BlocConsumer<EventsCubit, EventsStates>(
            listener: (context, state) {
              if(state is loadingEventsState)
                   LoadingScreen();
            },
            builder: (context, state) {
              return Scaffold(
                floatingActionButtonLocation:
                FloatingActionButtonLocation
                    .centerFloat, floatingActionButton:
              FloatingActionButton.extended(
                onPressed:EventsCubit.get(context).categoriesEventModel != null? () {
                  uid != "" ?   Get.to(() => AddEventScreen())
                      :
                  showToast(
                    "سجل الدخول اولا",
                    borderRadius: BorderRadius.circular(5),
                    context: context,
                    animation: StyledToastAnimation.scale,
                    reverseAnimation: StyledToastAnimation.fade,
                    animDuration: Duration(milliseconds: 250),
                  );
                } : (){},
                icon: Icon(Icons.event_available_rounded),
                backgroundColor: primaryColor, label: Text("Add Event".tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),),
              ),
                body:(state is loadingEventsState || EventsCubit
                    .get(context)
                    .eventModel == null)? LoadingScreen()  :RefreshIndicator(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor
                      .withOpacity(0.6),
                  color: Colors.white,
                  onRefresh: () async {
                    await EventsCubit.get(context)
                      ..getAllEvents();
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(right: 18.0, left: 18),
                      child: ListView(
                        children: [
                          EventsCubit
                  .get(context)
                  .eventModel!.data!.isNotEmpty ? ListView.separated(
                              itemBuilder: (context, index) =>
                                  AnimatedWidgets(
                                    child: InkWell(
                                      child: FullEventCard(
                                        imageLocation: EventsCubit
                  .get(context)
                  .eventModel!.data![index]
                                            .image ??
                                            "",
                                        eventName: EventsCubit
                  .get(context)
                  .eventModel!.data![index].title ??
                                            "",
                                        eventDetails: EventsCubit
                  .get(context)
                  .eventModel!.data![index]
                                            .description ?? "",
                                        category: EventsCubit
                  .get(context)
                  .eventModel!.data![index]
                                            .catergory ??
                                            "",
                                        payment: EventsCubit
                  .get(context)
                  .eventModel!.data![index].payment == 0
                                            ? "free".tr
                                            : "ticketed".tr,
                                        favColor: favouriteFavBox.containsKey(
                                            EventsCubit
                  .get(context)
                  .eventModel!.data![index].id)
                                            ? Colors.red
                                            : Colors.grey.shade800,
                                        fav: () {
                                          EventsCubit.get(context).onPressFav(
                                            id: EventsCubit
                  .get(context)
                  .eventModel!.data![index].id,
                                            user_id: EventsCubit
                  .get(context)
                  .eventModel!.data![index].user_id,
                                            title: EventsCubit
                  .get(context)
                  .eventModel!.data![index].title,
                                            description: EventsCubit
                  .get(context)
                  .eventModel!.data![index]
                                                .description,
                                            startDate: EventsCubit
                  .get(context)
                  .eventModel!.data![index]
                                                .startDate,
                                            endDate: EventsCubit
                  .get(context)
                  .eventModel!.data![index].endDate,
                                            phone: EventsCubit
                  .get(context)
                  .eventModel!.data![index].phone,
                                            websiteLink: EventsCubit
                  .get(context)
                  .eventModel!.data![index]
                                                .websiteLink,
                                            email: EventsCubit
                  .get(context)
                  .eventModel!.data![index].email,
                                            payment: EventsCubit
                  .get(context)
                  .eventModel!.data![index].payment,
                                            catergory: EventsCubit
                  .get(context)
                  .eventModel!.data![index]
                                                .catergory,
                                            image: EventsCubit
                  .get(context)
                  .eventModel!.data![index].image,
                                            location: EventsCubit
                  .get(context)
                  .eventModel!.data![index]
                                                .location,
                                            price: EventsCubit
                  .get(context)
                  .eventModel!.data![index].price,);
                                        },
                                      ),
                                      onTap: () {
                                        Get.to(() =>
                                            EventDetailPage(EventsCubit
                                                .get(context)
                                                .eventModel!
                                                .data![index]));
                                      },
                                    ),
                                    delay: 300,
                                  ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 5,),
                              itemCount: EventsCubit
                                  .get(context)
                                  .eventModel!
                                  .data!
                                  .length)
                              : Center(child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 250.0),
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
              );
            }));
  }
}
