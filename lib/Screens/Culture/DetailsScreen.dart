import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Models/specific_culture.dart';
import 'package:visit_egypt/Screens/Culture/noSqlHelper/favourite_culture_model.dart';
import 'package:visit_egypt/Widgets/CultureCard.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'all_comments_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class DetailsScreen extends StatelessWidget {
  final Data? culture;
  String? id;
  String? user_id;
  String? title;
  String? description;
  String? link;
  String? image;
  String? mainCharacter;
  int? rate;
  int? category_id;
  DetailsScreen([this.culture,  this.id, this.user_id, this.title, this.description,
     this.link,  this.image, this.rate,this.mainCharacter,this.category_id]);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: BlocProvider.of<CultureCubit>(context)..getSpecificCulture(culture!.categoryId.toString()),
    child: BlocConsumer<CultureCubit, CultureStates>(
    listener: (context, state) {},
    builder:(context, state) {

      return Scaffold(
        bottomNavigationBar:culture !=null? Container(
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
          height: 49,
          color: Colors.transparent,
          child: FlatButton(
            color: primaryColor,
            onPressed: () {
              Get.to(AllComments(culture!));
            },
            child: Text(
              'Show All comments'.tr,
              style: GoogleFonts.cairo(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ):Container(),
        body: state is loadingSpecificCulturesState?
        Center(
            child: LoadingBouncingGrid.square(
              backgroundColor: primaryColor,
            )) : SafeArea(
          child: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: primaryColor,
                  expandedHeight: MediaQuery.of(context).size.height * 0.5,
                  flexibleSpace: Hero(
                    tag: 'cultureHero',
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        image: DecorationImage(
                            image: NetworkImage(culture !=null ?culture!.image! :image!),
                            fit: BoxFit.cover
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 25,
                            top: 35,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child:Get.locale == Locale('en', 'US') ? Icon(Icons.arrow_back_outlined,color: Colors.black,)
                                    :Icon(Icons.arrow_forward,color: Colors.black,),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 25,
                            top: 35,
                            child: GestureDetector(
                              onTap: () {
                                Share.share(
                                    "${culture !=null?culture!.title! :title!} \n \n ${culture!.description !=null?culture!.description! :description!} ");
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                child: Icon(Icons.share),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.only(top: 24, left: 25,right: 25),
                        child: Text(
                          culture !=null ?culture!.title! :title!,
                          style: GoogleFonts.cairo(
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, left: 25,right: 25),
                            child: Text(
                              culture !=null ?culture!.maincharacter! :mainCharacter!,
                              style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: IconButton(onPressed: (){
                              launch(culture !=null ?culture!.link! :link!,);
                            },
                                icon: Icon(Icons.public)),
                          )
                        ],
                      ),

                      Container(
                        height: 300,
                        margin: EdgeInsets.only(top: 23, bottom: 36),
                        padding: EdgeInsets.only(left: 25,),
                        child: DefaultTabController(
                            length: 3,
                            child:Column(
                              children: [
                                Container(
                                  child: TabBar(
                                      labelPadding: EdgeInsets.all(0),
                                      indicatorPadding: EdgeInsets.all(0),
                                      isScrollable: true,
                                      labelColor: primaryColor,
                                      unselectedLabelColor: Colors.grey,
                                      labelStyle: GoogleFonts.cairo(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                      unselectedLabelStyle: GoogleFonts.cairo(
                                          fontSize: 16, fontWeight: FontWeight.w600),
                                      tabs: [
                                        Container(
                                          width:130,
                                          child: Tab(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text('Details'.tr),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Container(
                                            width:130,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text('Rate'.tr),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Container(
                                            width:100,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text('Similar'.tr),
                                            ),
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            culture !=null ?culture!.description! :description!,
                                            style: GoogleFonts.cairo(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 55.0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: RatingBarIndicator(
                                              itemBuilder: (context, index) {
                                                return Icon(Icons.star_border, color: Colors.amber,);
                                              },
                                              rating: (( culture !=null ?culture!.rate! :rate!)/1),
                                              itemCount: 5,
                                              itemSize: 35,
                                            ),
                                          ),
                                        ),
                                        culture !=null ?  Container(

                                          child: GridView.builder(

                                            scrollDirection: Axis.vertical,
                                            itemCount: CultureCubit.get(context).specificCultureModel!.data!.length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1
                                            ),
                                            itemBuilder: (context, index){
                                              Box favouriteFavBox = Hive.box<DataFavCuluture>('favCultureBox');
                                              var cubit = CultureCubit.get(context).specificCultureModel!;
                                              return AnimatedWidgets(
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
                                                      rate:cubit.data![index].rate,
                                                      link:cubit.data![index].link,
                                                      mainCharacter:cubit.data![index].maincharacter,

                                                    );
                                                  },
                                                  image: cubit.data![index].image ??
                                                      "",
                                                  title: cubit.data![index].title ?? "",
                                                  des: cubit.data![index]
                                                      .description ?? "",
                                                  rating:  cubit.data![index]
                                                      .rate ?? 3,
                                                  pressRead:(){
                                                    launch(cubit.data![index]
                                                        .link ?? "");
                                                  },
                                                  pressDetails: (){
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DetailsScreen(
                                                        cubit.data![index]
                                                    )));
                                                },
                                                ),
                                                delay: 300,
                                              );
                                            },
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                          ),
                                        ) :
                                        Container(),
                                      ]),
                                ),
                              ],
                            )


                        ),
                      ),

                    ]))
              ],
            ),
          ),
        ),
      );
    },
    )
    );
  }
}
