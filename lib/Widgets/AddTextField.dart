import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:visit_egypt/constants/size_config.dart';
Widget textForm(BuildContext context,
    {required title, required hint, required TextEditingController controller, TextInputType? textType}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "$title".tr,
            style: GoogleFonts.cairo(
                fontSize: 14,fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            height: 45,
            child: ClayContainer(
              height: SizeConfig.screenHeight,
              borderRadius: 30,
              child: Padding(
                padding: const EdgeInsets.only(right: 11,left: 11,top: 4),
                child: TextFormField(
                  controller: controller,
                  keyboardType: textType,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                      hintText: "$hint".tr,
                      isDense: true,
                      counterText: "",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey)),
                  // controller: viewModel.bookSpecialtyController,
                ),
              ),
              emboss: true,

              spread:2,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
              depth: 20,
            ),
          ),
        ),
      ],
    );