import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_egypt/Widgets/animated_widget.dart';
import 'package:visit_egypt/constants/constants.dart';
// main class for data of embassy
class EmbassyContacts {
  String title;
  String phone;

  EmbassyContacts(this.title, this.phone);
}


class EmbassyPhoneScreen extends StatefulWidget {

  @override
  _EmbassyPhoneScreenState createState() => new _EmbassyPhoneScreenState();
}

class _EmbassyPhoneScreenState extends State<EmbassyPhoneScreen> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = [];

  List<EmbassyContacts> words = [
    EmbassyContacts("Morocco", "+20227364849"),
    EmbassyContacts("saudiArabia", "+37493082"),
    EmbassyContacts("Italy", "+27943194"),
    EmbassyContacts("usa", "+2027973300"),
    EmbassyContacts("algeria", "+2027361520"),
    EmbassyContacts("kuwait", "+37602661"),
    EmbassyContacts("mali", "+33371641"),
    EmbassyContacts("canda", "+27918700"),
    EmbassyContacts("iran", "+37496820"),
    EmbassyContacts("Sudan", "+27949661"),
    EmbassyContacts("icland", "+23925573"),
    EmbassyContacts("France", "+25673200"),
    EmbassyContacts("portugal", "+27350779"),
    EmbassyContacts("germany", "+20227282000"),

  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))
          ),
          brightness: Brightness.light,
          centerTitle: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("embassyPhones".tr ,style: GoogleFonts.cairo(
                  color:  Theme.of(context).brightness == Brightness.dark ? primaryColor : Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),),
              TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "search".tr,
                    hintText: "search".tr,
                    labelStyle: GoogleFonts.cairo(
                        color:  Colors.white,
                        fontWeight: FontWeight.bold),
                    hintStyle: GoogleFonts.cairo(color:Colors.white,),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),

                  prefixIcon: Icon(Icons.search,color: Colors.white,),
                   ),
              ),
            ],
          )
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("clickOpenLongCopy".tr,
                style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 14,
                      wordSpacing: 2,
                      color: Colors.grey

                    )),),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    if (editingController.text.isEmpty) {
                      return AnimatedWidgets(
                        delay: 300,
                        child: InkWell(
                          onTap: () => launch('tel:${words[index].phone}'),
                          onLongPress: () {
                            FlutterClipboard.copy(words[index].phone.toString())
                                .then((value) {
                              showToast(
                                "Copied!",
                                borderRadius: BorderRadius.circular(5),
                                context: context,
                                animation: StyledToastAnimation.scale,
                                reverseAnimation: StyledToastAnimation.fade,
                                animDuration: Duration(milliseconds: 250),
                              );
                            }).catchError((error) {
                              showToast(
                                error.toString(),
                                borderRadius: BorderRadius.circular(5),
                                context: context,
                                animation: StyledToastAnimation.scale,
                                reverseAnimation: StyledToastAnimation.fade,
                                animDuration: Duration(milliseconds: 250),
                              );
                            });
                          },
                          child: ListTile(
                            leading:Text("${words[index].title}".tr, style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  wordSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor
                                )),) ,
                            trailing:Text(words[index].phone, style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 13,
                                  wordSpacing: 2,

                                )),)  ,

                          ),
                        ),
                      );
                    } else if (words[index]
                        .title.tr
                        .toLowerCase()
                        .contains(editingController.text) ||
                        words[index]
                            .phone
                            .toLowerCase()
                            .contains(editingController.text)) {
                      return InkWell(
                        onTap: () => launch('tel:${words[index].phone}'),
                        onLongPress: () {
                          FlutterClipboard.copy(words[index].phone.toString())
                              .then((value) {
                            showToast(
                              "Copied!",
                              borderRadius: BorderRadius.circular(5),
                              context: context,
                              animation: StyledToastAnimation.scale,
                              reverseAnimation: StyledToastAnimation.fade,
                              animDuration: Duration(milliseconds: 250),
                            );
                          }).catchError((error) {
                            showToast(
                              error.toString(),
                              borderRadius: BorderRadius.circular(5),
                              context: context,
                              animation: StyledToastAnimation.scale,
                              reverseAnimation: StyledToastAnimation.fade,
                              animDuration: Duration(milliseconds: 250),
                            );
                          });
                        },
                        child: ListTile(
                          leading:Text("${words[index].title}".tr, style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  wordSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor
                              )),) ,
                          trailing:Text(words[index].phone, style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                fontSize: 13,
                                wordSpacing: 2,

                              )),)  ,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}