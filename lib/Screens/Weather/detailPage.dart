import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visit_egypt/Models/weather_model.dart';
import 'package:visit_egypt/constants/constants.dart';
import 'package:get/get.dart';
import 'extraWeather.dart';


class DetailPage extends StatelessWidget {
  final Weather tomorrowTemp;
  final List<Weather> sevenDay;
  DetailPage(this.tomorrowTemp,this.sevenDay);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030317),
      body: Column(
        children: [
          TomorrowWeather(tomorrowTemp),
          SevenDays(sevenDay),


        ],
      ),
    );
  }
}

class TomorrowWeather extends StatelessWidget {
  final Weather tomorrowTemp;
  TomorrowWeather(this.tomorrowTemp);
  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      color: primaryColor,
      glowColor: primaryColor,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50, right: 30, left: 30, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    Text(
                      "7 days".tr,
                      style:
                          TextStyle(color:Colors.white,fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(tomorrowTemp.image!))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tomorrow".tr,
                      style: TextStyle(color:Colors.white,fontSize: 30, height: 0.1),
                    ),
                    Container(
                      height: 105,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GlowText(
                            tomorrowTemp.max.toString(),
                            style: TextStyle(
                                color:Colors.white,fontSize: 100, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "/" + tomorrowTemp.min.toString() + "\u00B0",
                            style: TextStyle(
                                color: Colors.black54.withOpacity(0.3),
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      " " + tomorrowTemp.name!.tr,
                      style: TextStyle(
                        fontSize: 15,color:Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 20,
              right: 50,
              left: 50,
            ),
            child: Column(
              children: [
                Divider(color: Colors.white),
                SizedBox(
                  height: 10,
                ),
                ExtraWeather(tomorrowTemp)
              ],
            ),
          )
        ],
      ),
    );
  }
}



class SevenDays extends StatelessWidget {
  final List<Weather> sevenDay;

  SevenDays(this.sevenDay);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height - 430,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sevenDay.length, //+ 1,
              itemBuilder: (BuildContext context, int index) {
             /*   if (index == 7)
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 250,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries<sevenDayData, String>>[
                          SplineSeries<sevenDayData, String>(
                            dataSource: [],
                            xValueMapper: (sevenDayData f, _) =>
                            f.dateTime,
                            yValueMapper: (sevenDayData f, _) =>
                            f.temp,
                          ),
                        ],
                      ),
                    ),
                  );
                else*/
                  return Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(sevenDay[index].day!,
                              style: TextStyle(color: Colors.white,
                                  fontSize: 20)),
                          Container(
                            width: 135,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(sevenDay[index].image!),
                                  width: 40,
                                ),
                                SizedBox(width: 15),
                                Text(
                                  sevenDay[index].name!.tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "+" + sevenDay[index].max.toString() + "\u00B0",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "+" + sevenDay[index].min.toString() + "\u00B0",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ));
              },
            ),
          ),

        ],
      ),


    );
  }
}