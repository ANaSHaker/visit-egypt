import 'dart:convert';

import 'package:visit_egypt/config/env.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  final String spcountrycodefrom = 'spcountrycodefrom',
      spcountrycodeto = 'spcountrycodeto';
  final String url =
      'https://free.currconv.com/api/v7/currencies?apiKey=${Env.currencyApiKey}';

  getListofc() async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        print('okay...............');
        // list = parseCurrency(res.body);
        final data = jsonDecode(res.body);
        print('print ${data["results"]["USD"]}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<double> convertCC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countryCodeFromspValue = prefs.getString(spcountrycodefrom) ?? "EGY";
    String countryCodeTospValue = prefs.getString(spcountrycodeto) ?? "USD";

    String converstionCode =
        countryCodeFromspValue + '_' + countryCodeTospValue;
    String urlConvert =
        "https://free.currconv.com/api/v7/convert?q=$converstionCode&compact=ultra&apiKey=${Env.currencyApiKey}";
    double resValue = 0.0;
    try {
      var res = await http.get(Uri.parse(urlConvert));

      if (res.statusCode == 200) {
        //print('hghfhgbcbvcvbcvbcvbccvbcxvcxvcx');
        var resData = jsonDecode(res.body);

        resValue = (resData[converstionCode]).toDouble();
        //print('ohhh $x');
        //print('from service ratio value $resValue');
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    //print('setting from sp in servies $countryCodeFromspValue and $countryCodeTospValue');

    return resValue;
  }

//load local json file
  Future<String> loadPersonFromAsset() async {
    return await rootBundle.loadString('assets/person.json');
  }
}
