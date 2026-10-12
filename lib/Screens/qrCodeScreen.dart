import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:unicorndial/unicorndial.dart';

import '../constants/constants.dart';


class qrScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>  _qrScreenState();


}

class _qrScreenState extends State<qrScreen> {

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the
  // platform is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final childButtons = <UnicornButton>[];

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
          backgroundColor: primaryColor,
          mini: true,
          child: Icon(Icons.flash_auto),
          onPressed: () async {
            await controller?.toggleFlash();
            setState(() {});
          },
        )));
    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
          backgroundColor: primaryColor,
          mini: true,
          child: Icon(Icons.camera_alt),
          onPressed: () async {
            await controller?.flipCamera();
            setState(() {});
          },
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
          backgroundColor: primaryColor,
          mini: true,
          child: Icon(Icons.pause),
          onPressed: () async {
            await controller?.pauseCamera();
          },
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            backgroundColor: primaryColor,
          mini: true,
          child: Icon(Icons.fiber_manual_record_sharp,),
          onPressed: () async {
            await controller?.resumeCamera();
          }
        )));
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:100.0),
        child: buildUnicornDialer(childButtons),
      ),
      appBar: AppBar(
        title: Text(
          "qrScan".tr,
          style: GoogleFonts.cairo(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: primaryColor,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),

        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
      ),
      body:  Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (result != null)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              'Type: ${describeEnum(result!.format)} ',
                              style: GoogleFonts.cairo(
                                  color: Color(0xff02ab94),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: Icon(Icons.copy,color: primaryColor,),
                            onPressed: (){
                              Clipboard.setData(ClipboardData(text: "${result!.code}"));
                            },
                          )
                        ],
                      ),
                      Text("${result!.code.length > 30 ? result!.code.substring(0,30) : result!.code}...",style: GoogleFonts.cairo(
                          color: primaryColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                else
                  Text('qrScan'.tr, style: GoogleFonts.cairo(
                      color: primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),


              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the
    // scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation we need to
    // set the is ten for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  UnicornDialer buildUnicornDialer(List<UnicornButton> childButtons) {
    return UnicornDialer(
        backgroundColor: Color.fromRGBO(255, 255, 255, .75),
        parentButtonBackground: primaryColor,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.menu),
        childButtons: childButtons);
  }
}