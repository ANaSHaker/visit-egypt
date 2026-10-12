import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Screens/companies/cubit/cubit.dart';
import 'package:visit_egypt/Screens/companies/cubit/states.dart';
import 'package:visit_egypt/Screens/companies/noSqlHelper/favourite_company_model.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

Widget favouriteCompany()=> BlocProvider(
  create: (context)=>TransportationCubit(),

  child:BlocConsumer<TransportationCubit,TransportationStates>(
    listener: (context,state){},
    builder: (context,state){

      return ValueListenableBuilder(
          valueListenable: Hive.box<DataFav>('favBox').listenable(),
          builder: (context, Box<DataFav> box, _) {
            if(box.values.length == 0)
              return Center(child: Icon(Icons.emoji_transportation));
            else
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: new StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: box.values.length,
                  itemBuilder: (context,index){
                    DataFav? favItem = box.getAt(index);
                    return companyWidget(favItem, context);
                  },
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.count(2, index.isEven ? 3.2 : 4.2),
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 20.0,
                ),
              );
          }
      );
    },
  ),
);
Widget companyWidget(DataFav? model, context) {
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

              },
            ),
          ],
        ),
        back: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                (model.description ?? ""), style: GoogleFonts.cairo(),),
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
                      print(model.id);
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
Widget grid(context,Box box) {
  return new StaggeredGridView.countBuilder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    crossAxisCount: 4,
    itemCount: box.values.length,
    itemBuilder: (BuildContext context, int index){
      DataFav? favItem = box.getAt(index);
      return companyWidget(favItem, context);
    },
    staggeredTileBuilder: (int index) =>
        StaggeredTile.count(2, index.isEven ? 3.2 : 3.6),
    mainAxisSpacing: 15.0,
    crossAxisSpacing: 40.0,
  );
}