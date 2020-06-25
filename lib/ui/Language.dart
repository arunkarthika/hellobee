import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridDashboard extends StatelessWidget {
  Items item1 = new Items(
      title: "தமிழ்",
      subtitle1: "Tamil",
      event: "",
      img: "assets/broadcast/chair.png");
  Items item2 = new Items(
    title: "English",
    subtitle1: "english",
    event: "",
    img: "assets/broadcast/chair.png",
  );
  Items item3 = new Items(
    title: "हिन्दी",
    subtitle1: "Hindi",
    event: "",
    img: "assets/broadcast/chair.png",
  );
  Items item4 = new Items(
    title: "Malayalam",
    subtitle1: "Rose favirited your Post",
    event: "",
    img: "assets/broadcast/chair.png",
  );
  Items item5 = new Items(
    title: "urdu",
    subtitle1: "urdu",
    event: "",
    img: "assets/broadcast/chair.png",
  );
  Items item6 = new Items(
    title: "Kannada",
    subtitle1: "kannada",
    event: "",
    img: "assets/broadcast/chair.png",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var color = 0xFFEF6C00;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return Container(
              decoration: BoxDecoration(
                  color: Color(color), borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    data.img,
                    width: 42,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    data.subtitle1,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.event,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle1;
  String event;
  String img;
  Items({this.title, this.subtitle1, this.event, this.img});
}
