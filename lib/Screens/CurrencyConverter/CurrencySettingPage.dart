import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visit_egypt/Widgets/BottomNavigation.dart';
import 'package:visit_egypt/constants/constants.dart';

import '../../Models/Country.dart';
import 'CurrencyMainPage.dart';

class Setting extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<Setting> {
  final String spcountrycodefrom = 'spcountrycodefrom',
      spcountrycodeto = 'spcountrycodeto';

   int? selectedcountryindexfrom;
   int? selectedcountryindexto;

  List<Country> _countries = Country.getCountries();

   List<DropdownMenuItem<Country>>? _dropdownMenuItemsFrom;
   List<DropdownMenuItem<Country>>? _dropdownMenuItemsTo;

   Country? _selectedCountryFrom;
   Country? _selectedCountryTo;

  List<DropdownMenuItem<Country>>? buildDropdownMenuItemsFrom(List countries) {
    List<DropdownMenuItem<Country>> items = [];
    for (Country country in countries) {
      String flag = country.countryFlag.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
              (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name.tr +'  ' +flag),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Country>>? buildDropdownMenuItemsTo(List countries) {
    List<DropdownMenuItem<Country>> items = [];
    for (Country country in countries) {
      String flag = country.countryFlag.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
              (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name.tr +'  ' +flag),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItemFrom(Country? selectedCountryFrom) {
    setState(() {
      _selectedCountryFrom = selectedCountryFrom!;
      print('sp from ${_selectedCountryFrom!.countryCode}');
    });

    autosaveFrom();
  }

  autosaveFrom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(spcountrycodefrom)) {
      prefs.setString(spcountrycodefrom, "USD");
    } else {
      prefs.setString(spcountrycodefrom, _selectedCountryFrom!.countryCode);
    }
  }

  onChangeDropdownItemTo(Country? selectedCountryTo) {
    setState(() {
      _selectedCountryTo = selectedCountryTo!;
      print('sp to ${_selectedCountryTo!.countryCode}');
    });

    autosaveTo();
  }

  autosaveTo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(spcountrycodeto)) {
      prefs.setString(spcountrycodeto, "EGY");
    } else {
      prefs.setString(spcountrycodeto, _selectedCountryTo!.countryCode);
    }
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(spcountrycodefrom)) {
      prefs.setString(spcountrycodefrom, "USD");
    } else {
      prefs.setString(spcountrycodefrom, _selectedCountryFrom!.countryCode);
    }

    if (!prefs.containsKey(spcountrycodeto)) {
      prefs.setString(spcountrycodeto, "EGY");
    } else {
      prefs.setString(spcountrycodeto, _selectedCountryTo!.countryCode);
    }

    showToast(
      "تم الحفظ",
      borderRadius: BorderRadius.circular(5),
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: Duration(milliseconds: 250),
    );
    Get.offAll(BottomNavigation());
    Get.to(CurrencyConvertor());

    print('sp to ${_selectedCountryTo!.countryCode}');
    print('sp from ${_selectedCountryFrom!.countryCode}');
  }

  @override
  void initState() {
    _dropdownMenuItemsFrom = buildDropdownMenuItemsFrom(_countries)!;
    _dropdownMenuItemsTo = buildDropdownMenuItemsTo(_countries)!;
    setTheSPstate().then((_) {
      setState(() {
        _selectedCountryFrom =
            _dropdownMenuItemsFrom![selectedcountryindexfrom!].value!;
        _selectedCountryTo = _dropdownMenuItemsTo![selectedcountryindexto!].value!;
      });
    });
    super.initState();
  }

  setTheSPstate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countryCodeFromspValue = prefs.getString(spcountrycodefrom) ?? "USD";
    String countryCodeTospValue = prefs.getString(spcountrycodeto) ?? "EGY";

    selectedcountryindexfrom =
        _countries.indexWhere((c) => c.countryCode == countryCodeFromspValue);
    selectedcountryindexto =
        _countries.indexWhere((c) => c.countryCode == countryCodeTospValue);

    print(
        'setting from sp $selectedcountryindexfrom and $selectedcountryindexto');
  }

  loadCountries() {
    _dropdownMenuItemsFrom = buildDropdownMenuItemsFrom(_countries)!;
    _dropdownMenuItemsTo = buildDropdownMenuItemsTo(_countries)!;

    _selectedCountryFrom =
        _dropdownMenuItemsFrom![selectedcountryindexfrom!].value!;
    _selectedCountryTo = _dropdownMenuItemsTo![selectedcountryindexto!].value!;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('setting'.tr,style:GoogleFonts.cairo(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold), ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,

          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: primaryColor,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),

        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClayContainer(
                borderRadius: 10,
                depth: 100,
                spread: 1,

                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'From'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        DropdownButton(
                          isExpanded: true,
                          value: _selectedCountryFrom,
                          items: _dropdownMenuItemsFrom,
                          onChanged: onChangeDropdownItemFrom,
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 20,),
              ClayContainer(
                borderRadius: 10,
                depth: 100,
                spread: 1,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'To'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            ),
                      ),
                      DropdownButton(
                        isExpanded: true,
                        value: _selectedCountryTo,
                        items: _dropdownMenuItemsTo,
                        onChanged: onChangeDropdownItemTo,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              ClayContainer(
                borderRadius: 10,
                depth: 100,
                spread: 1,
                width: 320,

                child:  TextButton(
                  onPressed: saveData,

                  child: Text(
                    'SaveSetting'.tr,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),

                ),
              ),


            ],
          ),
        ));
  }
}
