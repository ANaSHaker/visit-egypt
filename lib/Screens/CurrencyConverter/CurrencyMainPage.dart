import 'dart:async';
import 'dart:ui';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/CheckInternetCon.dart';
import '../../Services/database/converterApi.dart';
import '../../constants/constants.dart';
import 'CurrencySettingPage.dart';


class CurrencyConvertor extends StatefulWidget {
  @override
  _CurrencyConvertorState createState() => _CurrencyConvertorState();
}

class _CurrencyConvertorState extends State<CurrencyConvertor> {
  // ignore: cancel_subscriptions
   StreamSubscription<InternetConnectionChecker>? listener;
  String amountVal = '0.0', fromCurrency = '', tocurrency = '';
  double ratio = 0.0;
  String title = 'Currency Converter';
  //String title = 'Currency Converter';
  final String spcountrycodefrom = 'spcountrycodefrom',
      spcountrycodeto = 'spcountrycodeto';

  TextEditingController amountController = TextEditingController();

  //for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _validateInputsStatus = false;
  bool loading = true;

  //get all currencies
  getAllCurrencyList() async {
    await ApiServices().getListofc();
    setState(() {
      loading = false;
    });
  } //getallcurencylist

  Future<double> getCC() async {
    bool connectionResult = await InternetConnectionChecker().hasConnection;
    if (connectionResult) {
      ratio = (await ApiServices().convertCC()).toDouble();
    } else {
      showToast(
        "calculating...",
        borderRadius: BorderRadius.circular(5),
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );    }
    return ratio;
  }

  loadCurrentCurrencyCode() async {
    //get current setting from SP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fromCurrency = prefs.getString(spcountrycodefrom) ?? "EGY";
      tocurrency = prefs.getString(spcountrycodeto) ?? "USD";
    });
  }

  getAmount() {
    getCC().then((_) {
      amountVal = '0.0';
      setState(() {
        //amountVal = amountController.text;
        amountVal = (double.parse(amountController.text) * ratio)
            .toStringAsFixed(3)
            .toString();
      });
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Setting':
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Setting(),
          ),
        );
        break;
    }
  }


  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {

    loadCurrentCurrencyCode();

    getCC();
    super.initState();
  }

  connectionStatus() async {
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          setState(() {
            title = 'Currency Converter';
          });
          break;
        case InternetConnectionStatus.disconnected:
          setState(() {
            showToast(
              "calculating...",
              borderRadius: BorderRadius.circular(5),
              context: context,
              animation: StyledToastAnimation.scale,
              reverseAnimation: StyledToastAnimation.fade,
              animDuration: Duration(milliseconds: 250),
            );
          });
          break;
      }
    }) as StreamSubscription<InternetConnectionChecker>;
  }

  //validate user input
  void validateInputs() {
    print('validate inputs');
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      _validateInputsStatus = true;
    } else {
      //If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
        _validateInputsStatus = false;
      });
    }
  }

  //exit app when on back pressed


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed:null,
        backgroundColor: primaryColor,
        label: Text(
          "From $fromCurrency",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white),
        ),
      ),
      appBar: AppBar(
        title:Text("currencyConvertor".tr,style:GoogleFonts.cairo(
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
            padding: const EdgeInsets.all(20.0),
            child: new Form(
              key: _formKey,
              // ignore: deprecated_member_use
            //  autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 90.0),

                  ClayContainer(
                    borderRadius: 25,
                    depth: -100,
                    spread: 1,
                    color: Get.isDarkMode? Colors.grey[800]: Colors.grey[300],

                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,


                          hintText: 'Enter the amount ..',
                          labelText: 'Amount',
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        validator: validateNumber,
                        onSaved: (String? str) {
                          amountController.text = str!;
                          amountController.selection = TextSelection.fromPosition(
                              TextPosition(offset: amountController.text.length));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    margin: const EdgeInsets.all(0.1),
                    color: Colors.white54,
                    elevation: 0.0,
                    child: SizedBox(
                      height: 50.0,
                      child: InkWell(
                        splashColor: Colors.lightBlue,
                        onTap: () {},
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              '$amountVal $tocurrency',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black),
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ClayContainer(
                    borderRadius: 10,
                    depth: 100,
                    spread: 1,
                    width: 320,

                    child:  TextButton(
                      onPressed: () => {
                        validateInputs(),
                        if (_validateInputsStatus)
                          {
                            getAmount(),
                          },
                      },
                      child: Text(
                        'convert'.tr,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
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
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Setting()))

                      },
                      child: Text(
                        'setting'.tr,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),

                    ),
                  ),


                ],

              ),
            )),


    );
  }

  String? validateNumber(String? str) {
    if (str == '') {
      return "Enter the amount";
    } else if (!_isNumeric(str!)) {
      return "Enter Number only characters";
    } else {
      return null;
    }
  } //validate

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }
}
