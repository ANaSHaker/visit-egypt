import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_egypt/Models/weather_model.dart';
import 'package:visit_egypt/Widgets/loadingScreen_widget.dart';
import 'package:visit_egypt/constants/constants.dart';

import 'detailPage.dart';
import 'extraWeather.dart';
import 'package:get/get.dart';


Weather? currentTemp;
Weather? tomorrowTemp;
List<Weather>? todayWeather;
List<Weather>? sevenDay;
String lat = "30.033333";
String lon = "31.233334";
String city = "Cairo";
class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  getData() async{
    fetchData(lat, lon, city).then((value){
      currentTemp = value[0];
      todayWeather = value[1];
      tomorrowTemp = value[2];
      sevenDay = value[3];
      setState(() {

      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: darkColor,
        body:currentTemp==null ? Center(child: LoadingScreen(),):Column(
          children: [CurrentWeather(getData), TodayWeather()],
        ));
  }
}

class CurrentWeather extends StatefulWidget {
  final Function() updateData;
  CurrentWeather(this.updateData);
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {

  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        /* if(searchBar)
          setState(() {
            searchBar = false;
          });*/
      },
      child: GlowContainer(
        height: MediaQuery.of(context).size.height - 230,
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.only(top: 38, left: 30, right: 30),
        glowColor: Theme.of(context).brightness == Brightness.dark ?Colors.grey[900] :primaryColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
        color:primaryColor,
        spreadRadius: 5,
        child: Column(
          children: [
            Container(
              child: searchBar?
              TextField(
                focusNode: focusNode,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    hintText:"Enter a city Name"
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value)async{
                  CityModel? temp = await fetchCity(value);
                  if(temp==null){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title:Text("City not found"),
                        content: Text("Please check the city name"),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text("Ok"))
                        ],
                      );
                    });
                    searchBar = false;
                    return;
                  }
                  city = temp.name!;
                  lat = temp.lat!;
                  lon = temp.lon!;
                  updating = true;

                  widget.updateData();
                  searchBar = false;
                  updating = false;

                },
              )
                  :Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:Icon( CupertinoIcons.square_grid_2x2),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(

                            title:Text("Choose your city".tr
                              ,textAlign: TextAlign.center,style:
                              TextStyle(fontWeight: FontWeight.bold),),
                            content:  Container(
                              width: double.maxFinite,
                              child: ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {

                                    return GestureDetector(
                                        onTap: () async {
                                          print(itemCityDataList[index].name);
                                          CityModel? temp = await fetchCity(itemCityDataList[index].name!);
                                          if(temp==null){
                                            showDialog(context: context, builder: (BuildContext context){
                                              return AlertDialog(
                                                title:Text("City not found"),
                                                content: Text("Please check the city name"),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.of(context).pop();
                                                  }, child: Text("Ok"))
                                                ],
                                              );
                                            });
                                            searchBar = false;
                                            return;
                                          }
                                          city = temp.name!;
                                          lat = temp.lat!;
                                          lon = temp.lon!;
                                          updating = true;

                                          widget.updateData();
                                          searchBar = false;
                                          updating = false;
                                          Navigator.pop(context);
                                        },
                                        child: itemCityyData(itemCityDataList[index],context));
                                  },
                                  separatorBuilder: (context, index) =>
                                      Divider(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                  itemCount: itemCityDataList.length),
                            ),

                          );
                        });
                      });
                    },
                  ),
                  Text(
                    " " + city.tr,
                    style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Container()
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.white),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                updating?"Updating".tr:"Updated".tr,
                style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              height: 330,
              child: Stack(
                children: [
                  Image(
                    image: AssetImage(currentTemp!.image!),
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Center(
                        child: Column(
                          children: [
                            GlowText(
                              currentTemp!.current.toString(),
                              style: TextStyle(
                                  height: 0.1,
                                  fontSize: 150,
                                  color:Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(currentTemp!.name!.tr,
                                style: TextStyle(
                                  fontSize: 25,
                                  color:Colors.white,
                                )),
                            Text(currentTemp!.day!,
                                style: TextStyle(
                                  fontSize: 18,
                                  color:Colors.white,
                                ))
                          ],
                        )),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            ExtraWeather(currentTemp!)
          ],
        ),
      ),
    );

  }
  Widget itemCityyData(itemCityData item, context) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 25),
        child:Text(
          item.name!.tr,
          style: GoogleFonts.cairo(
              fontSize: 16,
              color: primaryColor,
              fontWeight: FontWeight.bold),
        ),

      );
}

class TodayWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today".tr,
                style: TextStyle(color:Colors.white,fontSize: 25, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return DetailPage(tomorrowTemp!,sevenDay!);
                      }));
                },
                child: Row(
                  children: [
                    Text(
                      "7 days".tr,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey,
                      size: 15,
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 30,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherWidget(todayWeather![0]),
                  WeatherWidget(todayWeather![1]),
                  WeatherWidget(todayWeather![2]),
                  WeatherWidget(todayWeather![3])
                ]),
          )
        ],
      ),
    );

  }
}

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  WeatherWidget(this.weather);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.white),
          borderRadius: BorderRadius.circular(35)),
      child: Column(
        children: [
          Text(
            weather.current.toString() + "\u00B0",
            style: TextStyle(color:Colors.white,fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),
          Image(
            image: AssetImage(weather.image!),
            width: 50,
            height: 50,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            weather.time??"",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}