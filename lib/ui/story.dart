import 'package:flutter/material.dart';
import 'package:honeybee/utils/colors.dart';
import 'package:honeybee/utils/string.dart';
import 'package:honeybee/widget/mycircleavatar.dart';

class Story extends StatelessWidget {
  final widgets = [
    storyAdd(),
    storyOnline(userProfileUrl1),
    storyOffline(userProfileUrl1),
    storyOnline(userProfileUrl2),
    storyOnline(userProfileUrl1),
    storyOffline(userProfileUrl1),
    storyOnline(userProfileUrl2),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  static Widget storyAdd() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFF3366FF),
                    const Color(0xFF00CCFF),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              color: Colors.orange[800],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/login/Logo.png',
                fit: BoxFit.cover,
              ),
              onPressed: () => {},
            ),
          ),
        ],
      ),
    );
  }

  static Widget storyOnline(String img) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF3366FF),
                        const Color(0xFF00CCFF),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                  color: Colors.orange[800],
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: MyCircleAvatar(
                    imgUrl: img,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.orange[800],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  static Widget storyOffline(String img) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                child: CircleAvatar(
                  backgroundColor: Colors.orange[800],
                  child: MyCircleAvatar(
                    imgUrl: img,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.orange[800],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
