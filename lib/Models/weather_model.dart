import 'package:visit_egypt/config/env.dart';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weather {
  final int? max;
  final int? min;
  final int? current;
  final String? name;
  final String? day;
  final int? wind;
  final int? humidity;
  final int? chanceRain;
  final String? image;
  final String? time;
  final String? location;

  Weather(
      {this.max,
      this.min,
      this.name,
      this.day,
      this.wind,
      this.humidity,
      this.chanceRain,
      this.image,
      this.current,
      this.time,
      this.location});
}


String appId = Env.openWeatherApiKey;


Future<List> fetchData(String lat,String lon,String city) async{
  var url = "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId";
  var response = await http.get(Uri.parse(url));
  DateTime date = DateTime.now();
  if(response.statusCode==200){
    var res = json.decode(response.body);
    //current Temp
    var current = res["current"];
    Weather currentTemp = Weather(
        current: current["temp"]?.round()??0,
        name: current["weather"][0]["main"].toString(),
        day: DateFormat("EEEE dd MMMM").format(date),
        wind: current["wind_speed"]?.round()??0,
        humidity: current["humidity"]?.round()??0,
        chanceRain: current["uvi"]?.round()??0,
        location: city,
        image: findIcon(current["weather"][0]["main"].toString(), true)
    );

    //today weather
    List<Weather> todayWeather = [];
    int hour = int.parse(DateFormat("hh").format(date));
    for(var i=0;i<4;i++){
      var temp = res["hourly"];
      var hourly = Weather(
          current: temp[i]["temp"]?.round()??0,
          image: findIcon(temp[i]["weather"][0]["main"].toString(),false),
          time: Duration(hours: hour+i+1).toString().split(":")[0]+":00"
      );
      todayWeather.add(hourly);
    }

    //Tomorrow Weather
    var daily = res["daily"][0];
    Weather tomorrowTemp = Weather(
        max: daily["temp"]["max"]?.round()??0,
        min:daily["temp"]["min"]?.round()??0,
        image: findIcon(daily["weather"][0]["main"].toString(), true),
        name:daily["weather"][0]["main"].toString(),
        wind: daily["wind_speed"]?.round()??0,
        humidity: daily["rain"]?.round()??0,
        chanceRain: daily["uvi"]?.round()??0
    );

    //Seven Day Weather
    List<Weather> sevenDay = [];
    for(var i=1;i<8;i++){
      String day = DateFormat("EEEE").format(DateTime(date.year,date.month,date.day+i+1)).substring(0,3);
      var temp = res["daily"][i];
      var hourly = Weather(
          max:temp["temp"]["max"]?.round()??0,
          min:temp["temp"]["min"]?.round()??0,
          image:findIcon(temp["weather"][0]["main"].toString(), false),
          name:temp["weather"][0]["main"].toString(),
          day: day
      );
      sevenDay.add(hourly);
    }
    return [currentTemp,todayWeather,tomorrowTemp,sevenDay];
  }
  return [null,null,null,null];
}
class sevenDayData {
  final String? dateTime;
  final int? temp;

  sevenDayData({this.dateTime, this.temp});

  factory sevenDayData.fromJson(dynamic json) {
    if (json == null) {
      return sevenDayData();
    }

    var f = json['dt_txt'].split(' ')[0].split('-')[2];
    var l = json['dt_txt'].split(' ')[1].split(':')[0];
    var fandl = '$f-$l';
    return sevenDayData(
      dateTime: '$fandl',
      temp: (double.parse(json['main']['temp'].toString()) - 273.15).round(),
    );
  }
}

/*

void getFiveDaysData() {
  WeatherService(city: '$city').getFiveDaysThreeHoursForcastData(
      onSuccess: (data) {
        fiveDaysData = data;
        update();
      }, onError: (error) {
    print(error);
    update();
  });
}
void getSevenDaysThreeHoursForcastData({
  Function()?  beforSend,
  Function(List<sevenDayData> sevenDayData)? onSuccess,
  Function(dynamic error)? onError,
}) {
  final url = '$baseUrl/forecast?q=$city&lang=en&$apiKey';
  print(url);
  ApiRepository(url: '$url', payload: null).get(
      beforeSend: () => {},
      onSuccess: (data) => {
        onSuccess((data['list'] as List)
            .map((t) => FiveDayData.fromJson(t))
            .toList() ??
            List.empty()),
      },
      onError: (error) => {
        print(error),
        onError(error),
      });
}

 */
//findIcon
findIcon(String name,bool type){
  if(type){
    switch(name){
      case "Clouds":
        return "assets/weather/sunny.png";
      case "Rain":
        return "assets/weather/rainy.png";
      case "Drizzle":
        return "assets/weather/rainy.png";
      case "Thunderstorm":
        return "assets/weather/thunder.png";
      case "Snow":
        return "assets/weather/snow.png";
      default:
        return "assets/weather/sunny.png";
    }
  }
  else{
    switch(name){
      case "Clouds":
        return "assets/weather/sunny_2d.png";
      case "Rain":
        return "assets/weather/rainy_2d.png";
      case "Drizzle":
        return "assets/weather/rainy_2d.png";
      case "Thunderstorm":
        return "assets/weather/thunder_2d.png";
      case "Snow":
        return "assets/weather/snow_2d.png";
      default:
        return "assets/weather/sunny_2d.png";
    }
  }
}

class CityModel{
  final String? name;
  final String? lat;
  final String? lon;
  CityModel({this.name,this.lat,this.lon});
}


var cityJSON;

Future<CityModel?> fetchCity(String cityName) async{
  if(cityJSON==null){
    String link = "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
    var response = await http.get(Uri.parse(link));
    if(response.statusCode==200){
      cityJSON = json.decode(response.body);
    }
  }
  for(var i=0;i<cityJSON.length;i++){
    if(cityJSON[i]["name"].toString().toLowerCase() == cityName.toLowerCase()){
      return CityModel(
          name:cityJSON[i]["name"].toString(),
          lat: cityJSON[i]["latitude"].toString(),
          lon: cityJSON[i]["longitude"].toString()
      );
    }
  }
  return null;
}
class itemCityData {
   String? name;

  itemCityData(this.name);
}

List<itemCityData> itemCityDataList = [
  itemCityData("Cairo"),
  itemCityData("Giza"),
  itemCityData("Alexandria"),
  itemCityData("Port Said"),
  itemCityData("Suez"),
  itemCityData("Luxor"),
  itemCityData("Zagazig"),
  itemCityData("Aswan"),
  itemCityData("Hurghada"),
  itemCityData("Sohag"),
  itemCityData("Ismailia"),
  itemCityData("Alamein"),
  itemCityData("Arish"),


];
class ApiRepository {
  final String? url;
  final Map<String,dynamic> payload;

  ApiRepository({this.url, required this.payload});

  Dio _dio = Dio();

  void get({
    Function()? beforeSend,
    Function(dynamic data)? onSuccess,
    Function(dynamic error)? onError,
  }) {
    _dio.get(this.url??'', queryParameters: this.payload).then((response) {
      if (onSuccess != null) {
        onSuccess(response.data);
      }
    }).catchError((error) {
      if (onError != null) {
        onError(error);
      }
    });
  }
}