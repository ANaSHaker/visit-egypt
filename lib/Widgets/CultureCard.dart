import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_egypt/constants/constants.dart';
class CultureCard extends StatelessWidget {
  final String image;
  final String title;
  final String des;
  final rating;
  final Function() pressDetails;
  final Function() pressRead;
  final Function() favPress;
  final Color favColor;

   CultureCard({
    required this.image,
    required this.title,
    required this.des,
    required this.rating,
    required this.pressDetails,
    required this.pressRead,
     required this.favPress,
     required this.favColor
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'cultureHero',
      child: Card(
       elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.network(
                      image,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: favPress,
                          child: Icon(Icons.favorite_border,color: favColor),
                        ),
                        SizedBox(height: 10,),
                        CultureRating(score: rating),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$title\n",
                              style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  SizedBox(width: 7,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                 child: GestureDetector(
                        onTap: pressDetails,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("Details".tr,style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TwoSideRoundedButton(
                      text: "link".tr,
                      press: pressRead,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TwoSideRoundedButton extends StatelessWidget {
  final String text;
  final double radious;
  final Function() press;
  const TwoSideRoundedButton({
    required this.text,
    this.radious = 29,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical:6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radious),
            bottomRight: Radius.circular(radious),
          ),
        ),
        child: Text(
          text,style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
        ),
    );
  }
}

class CultureRating extends StatelessWidget {
  final  score;
  const CultureRating({
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color:  Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] :Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 7),
            blurRadius: 20,
            color: Theme.of(context).brightness == Brightness.dark ?Colors.grey.shade900 : Color(0xFD3D3D3).withOpacity(.5),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 15,
          ),
          SizedBox(height: 5),
          Text(
            "${score.toDouble()}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}