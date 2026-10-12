import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_egypt/Screens/companies/cubit/cubit.dart';
import 'package:visit_egypt/Screens/companies/cubit/states.dart';
import 'package:visit_egypt/Screens/favourites/places_favourite.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'companies_favourite.dart';
import 'culture_favourite.dart';
import 'events_favourite.dart';

class FavouriteScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>TransportationCubit()
    ,child: BlocConsumer<TransportationCubit,TransportationStates>(
          listener: (context,state){
            if(state is removedFromFavSuccess){
              showToast("Deleted successfully".tr,context: context,backgroundColor: Colors.green,textStyle: GoogleFonts.cairo());
            }

          },
          builder: (context,state){
            return DefaultTabController(
                length: 4,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("favourite".tr, style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold

                    ),),
                    centerTitle: true,
                    elevation: 0,
                    bottom: TabBar(
                        labelColor: primaryColor,
                        unselectedLabelColor: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? primaryColor : Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.white),
                        tabs: [
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Companies".tr, style: TextStyle(fontSize: 12),),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Events".tr),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("InEgypt".tr),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Culture".tr),
                            ),
                          ),
                        ]),
                  ),
                  body: TabBarView(children: [
                    favouriteCompany(),
                    favouriteEvents(),
                    favouritePlaces(),

                    favouriteCultures(),
                  ]),
                ));
          },
        )
    );
  }
}

