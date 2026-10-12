import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:visit_egypt/Screens/inEgypt/DetailsScreen.dart';
import 'package:visit_egypt/Screens/inEgypt/add_place_screen.dart';
import 'package:visit_egypt/Screens/inEgypt/cubit/cubit.dart';
import 'package:visit_egypt/Screens/inEgypt/cubit/states.dart';
import 'package:visit_egypt/Screens/inEgypt/noSqlHelper/favourite_place_model.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/constants/constants.dart';

class AllCategoriesCities extends StatefulWidget {
  String id;

  AllCategoriesCities(this.id);

  @override
  State<AllCategoriesCities> createState() => _AllCategoriesCitiesState();
}

class _AllCategoriesCitiesState extends State<AllCategoriesCities>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var cubit = inEgyptCubit.get(context);
    Box favouriteFavBox = Hive.box<DataFavPlaces>('favPlacesBox');
    return BlocProvider.value(
        value: BlocProvider.of<inEgyptCubit>(context)
          ..getAllCategoriesCities(widget.id)..getAllCategoriesAddPlaces(),
        child: BlocConsumer<inEgyptCubit, inEgyptStates>(
          listener: (context, state) {},
          builder: (context, state) {

            TabController tabController = TabController(
                length: cubit.allCategoriesCity == null
                    ? 2
                    : cubit.allCategoriesCity!.data!.length,
                vsync: this,
                initialIndex: 0);
            return Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton:   FloatingActionButton.extended(
                onPressed:(inEgyptCubit.get(context).allCategoriesCity != null || inEgyptCubit.get(context).allCategoriesAddPlaces == null)? () {
                  uid != "" ? Get.to(() => AddPlaceScreen()) :
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
                backgroundColor: primaryColor, label: Text("Add Place".tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),),
              ),
              appBar: (state is loadinginAllCategoriesCityesState || state is loadinginAllCategoriesCityesState ||
                  cubit.allCategoriesCity == null ||
                  state is loadinginAllPlacesCityesState || cubit.allCategoriesCity!.data!.isEmpty)
                  ? AppBar(
                      centerTitle: true,
                      title: Text(
                        "Categories".tr,
                        style: GoogleFonts.cairo(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : AppBar(
                      title: Text(
                        "Categories".tr,
                        style: GoogleFonts.cairo(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      centerTitle: true,
                      elevation: 0,
                      bottom: TabBar(
                        isScrollable: true,
                          controller: tabController,


                          labelColor: primaryColor,
                          unselectedLabelColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? primaryColor
                                  : Colors.white,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.white),
                          tabs: cubit.allCategoriesCity!.data!.map((e) {
                            return Tab(child: Text(e.name ?? ""));
                          }).toList())),
              body: (state is loadinginAllCategoriesCityesState ||
                      cubit.allCategoriesCity == null ||
                      state is loadinginAllPlacesCityesState || cubit.allCategoriesCity!.data!.isEmpty)
                  ? Center(
                      child: LoadingBouncingGrid.square(
                      backgroundColor: primaryColor,
                    ))
                  : TabBarView(
                      controller: tabController,
                      children: cubit.allCategoriesCity!.data!.map((e) {
                        return ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Hero(
                                tag: "placeImage",
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => PlacesDetails(
                                            e.places![index],
                                          ));
                                      print(e.places![index].imagePath);
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: Container(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                    imageUrl: e.places![index].imagePath ??"",
                                      placeholder: (context, url) => Icon(Icons.image,size: 45,),
                                      errorWidget: (context, url, error) => new Icon(Icons.error),
                                    ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                             ),
                                            height: 180,
                                            width: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          left: 15,
                                          child: Column(
                                            crossAxisAlignment:
                                                Get.locale == Locale('en', 'US')
                                                    ? CrossAxisAlignment.start
                                                    : CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                e.places![index].name ?? "",
                                                style: GoogleFonts.cairo(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              e.places![index]
                                                  .description != null ?Text(
                                                  e.places![index].description!.length >30
                                                  ? "${e.places![index].description!.substring(0,30)}..."
                                                  :e.places![index].description!,
                                                  style: GoogleFonts.cairo(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold))
                                              :Container(),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: InkWell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: CircleAvatar(
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.redAccent,
                                                ),
                                                backgroundColor:
                                                    favouriteFavBox.containsKey(
                                                            e.places![index].id)
                                                        ? Colors.red
                                                        : Colors.grey.shade800
                                                            .withOpacity(0.7),
                                              ),
                                            ),
                                            onTap: () {
                                              inEgyptCubit
                                                  .get(context)
                                                  .onPressFav(
                                                    id: e.places![index].id,
                                                    image: e.places![index].image,
                                                    rate: e.places![index].rate,
                                                    description: e.places![index].description,
                                                    location: e.places![index].location,
                                                    title: e.places![index].name,
                                                    websiteLink: e.places![index].website,
                                                    phone: e.places![index].phone,
                                                  );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 1,
                                ),
                            itemCount: e.places!.length);
                      }).toList(),
                    ),
            );
          },
        ));
  }
}
