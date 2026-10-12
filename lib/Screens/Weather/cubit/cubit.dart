// /*
// import 'package:bloc/bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:visit_egypt/Models/weather_model.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:visit_egypt/Screens/Weather/cubit/state.dart';
//
// class WeatherCubit extends Cubit<WeatherStates> {
//   WeatherCubit() : super(InitialinWeatherStates());
//
//   static WeatherCubit get(context) => BlocProvider.of(context);
//   String appId = "";
//
//
//   fetchData(String lat,String lon,String city) async{
//
//     var url = "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId";
//     var response = await http.get(Uri.parse(url));
//     DateTime date = DateTime.now();
//     if(response.statusCode==200){
//       var res = json.decode(response.body);
//       //current Temp
//       var current = res["current"];
//       Weather currentTemp = Weather(
//           current: current["temp"]?.round()??0,
//           name: current["weather"][0]["main"].toString(),
//           day: DateFormat("EEEE dd MMMM").format(date),
//           wind: current["wind_speed"]?.round()??0,
//           humidity: current["humidity"]?.round()??0,
//           chanceRain: current["uvi"]?.round()??0,
//           location: city,
//           image: findIcon(current["weather"][0]["main"].toString(), true)
//       );
//
//       //today weather
//       List<Weather> todayWeather = [];
//       int hour = int.parse(DateFormat("hh").format(date));
//       for(var i=0;i<4;i++){
//         var temp = res["hourly"];
//         var hourly = Weather(
//             current: temp[i]["temp"]?.round()??0,
//             image: findIcon(temp[i]["weather"][0]["main"].toString(),false),
//             time: Duration(hours: hour+i+1).toString().split(":")[0]+":00"
//         );
//         todayWeather.add(hourly);
//       }
//
//       //Tomorrow Weather
//       var daily = res["daily"][0];
//       Weather tomorrowTemp = Weather(
//           max: daily["temp"]["max"]?.round()??0,
//           min:daily["temp"]["min"]?.round()??0,
//           image: findIcon(daily["weather"][0]["main"].toString(), true),
//           name:daily["weather"][0]["main"].toString(),
//           wind: daily["wind_speed"]?.round()??0,
//           humidity: daily["rain"]?.round()??0,
//           chanceRain: daily["uvi"]?.round()??0
//       );
//
//       //Seven Day Weather
//       List<Weather> sevenDay = [];
//       for(var i=1;i<8;i++){
//         String day = DateFormat("EEEE").format(DateTime(date.year,date.month,date.day+i+1)).substring(0,3);
//         var temp = res["daily"][i];
//         var hourly = Weather(
//             max:temp["temp"]["max"]?.round()??0,
//             min:temp["temp"]["min"]?.round()??0,
//             image:findIcon(temp["weather"][0]["main"].toString(), false),
//             name:temp["weather"][0]["main"].toString(),
//             day: day
//         );
//         sevenDay.add(hourly);
//       }
//       return [currentTemp,todayWeather,tomorrowTemp,sevenDay];
//
//     }
//     else{
//       emit(getWeathersErrorState());
//     }
//     return [null,null,null,null];
//   }
//
// //findIcon
//    findIcon(String name,bool type){
//     if(type){
//       switch(name){
//         case "Clouds":
//           return "assets/weather/sunny.png";
//         case "Rain":
//           return "assets/weather/rainy.png";
//         case "Drizzle":
//           return "assets/weather/rainy.png";
//         case "Thunderstorm":
//           return "assets/weather/thunder.png";
//         case "Snow":
//           return "assets/weather/snow.png";
//         default:
//           return "assets/weather/sunny.png";
//       }
//     }
//     else{
//       switch(name){
//         case "Clouds":
//           return "assets/weather/sunny_2d.png";
//         case "Rain":
//           return "assets/weather/rainy_2d.png";
//         case "Drizzle":
//           return "assets/weather/rainy_2d.png";
//         case "Thunderstorm":
//           return "assets/weather/thunder_2d.png";
//         case "Snow":
//           return "assets/weather/snow_2d.png";
//         default:
//           return "assets/weather/sunny_2d.png";
//       }
//     }
//   }
//   Weather? currentTemp;
//   Weather? tomorrowTemp;
//   List<Weather>? todayWeather;
//   List<Weather>? sevenDay;
//   String lat = "30.033333";
//   String lon = "31.233334";
//   String city = "Cairo";
//   getData() async{
//     emit(loadingWeatherStates());
//     fetchData(lat, lon, city).then((value){
//       emit(getWeathereSuccessState());
//
//       currentTemp = value[0];
//       todayWeather = value[1];
//       tomorrowTemp = value[2];
//       sevenDay = value[3];
//     });
//   }
//   CityModel? cityModel;
//
//   var cityJSON;
//
//   fetchCity(String cityName) async{
//     if(cityJSON==null){
//       emit(loadingCityStates());
//
//       String link = "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
//       var response = await http.get(Uri.parse(link));
//       if(response.statusCode==200){
//         emit(geCitySuccessState());
//
//         cityJSON = json.decode(response.body);
//       }
//     }
//     for(var i=0;i<cityJSON.length;i++){
//       if(cityJSON[i]["name"].toString().toLowerCase() == cityName.toLowerCase()){
//         emit(geCitySuccessState());
//         return CityModel(
//             name:cityJSON[i]["name"].toString(),
//             lat: cityJSON[i]["latitude"].toString(),
//             lon: cityJSON[i]["longitude"].toString()
//         );
//       }
//     }
//     return null;
//   }
// }*/
//
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:visit_egypt/Models/weather_model.dart';
// import 'package:visit_egypt/Screens/Weather/cubit/state.dart';
// class WeatherCubit extends Cubit<WeatherState> {
//
//   bool searchBar = false;
//   bool updating = false;
//   var focusNode = FocusNode();
//   WeatherCubit() : super(InitialStateWeather());
//   static WeatherCubit get(context)=>BlocProvider.of(context);
//
//   getData() async {
//     emit(getDataWeatherLoading());
//     fetchData(lat, lon, city).then((value) {
//       currentTemp = value[0];
//       emit(getDataWeatherSuccess());
//       todayWeather = value[1];
//       emit(getDataWeatherSuccess());
//       tomorrowTemp = value[2];
//       emit(getDataWeatherSuccess());
//       sevenDay = value[3];
//       emit(getDataWeatherSuccess());
//       print(currentTemp!.day);
//       emit(getDataWeatherSuccess());
//     }).catchError((e){
//       emit(getDataWeatherError());
//     });
//   }
//
//   chooseCity(context,index,updateData)async{
//     emit(chooseCityWeatherLoading());
//     CityModel? temp =
//         await fetchCity(
//         itemCityDataList[
//         index]
//             .name!);
//     if (temp == null) {
//       showDialog(
//           context: context,
//           builder: (BuildContext
//           context) {
//             return AlertDialog(
//               title: Text(
//                   "City not found"),
//               content: Text(
//                   "Please check the city name"),
//               actions: [
//                 TextButton(
//                     onPressed:
//                         () {
//                       Navigator.of(
//                           context)
//                           .pop();
//                     },
//                     child: Text(
//                         "Ok"))
//               ],
//             );
//           });
//       searchBar = false;
//       return;
//     }
//     city = temp.name!;
//     lat = temp.lat!;
//     lon = temp.lon!;
//     updating = true;
//
//     updateData!();
//     searchBar = false;
//     updating = false;
//     Navigator.pop(context);
//   }
// }
//
//
//
//
//
//
//
//




// chart part

/*
import 'package:visit_egypt/Models/weather_model.dart';

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
  Function(List<dynamic> sevenDayData)? onSuccess,
  Function(dynamic error)? onError,
}) {
  final url = 'https://api.openweathermap.org/data/2.5/forecast?q=$city&lang=en&$apiKey';
  print(url);
  ApiRepository(url: '$url', payload: null).get(
      beforeSend: () => {},
      onSuccess: (data) => {
        onSuccess!((data['list'] as List)
            .map((t) => FiveDayData.fromJson(t))
            .toList() ??
            List.empty()),
      },
      onError: (error) => {
        print(error),
        onError!(error),
      });
}

*/
