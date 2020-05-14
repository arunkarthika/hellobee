
import 'package:flutter/material.dart';
import 'package:honeybee/ui/profile.dart';
import 'package:honeybee/ui/settings.dart';
import 'package:swipedetector/swipedetector.dart';

void main() => runApp(new SwipeDetect());

class SwipeDetect extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Swipe(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Swipe extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Swipe> {
  String _swipeDirection = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: SwipeDetector(
                  child: Card(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Swipe Me',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            '$_swipeDirection',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onSwipeUp: () {
                    setState(() {
                      Navigator.of(context)
                          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return new Settings();
                      }));
                    });
                  },
                  onSwipeDown: () {
                    setState(() {
                      Navigator.of(context)
                          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return new Settings();
                      }));
                    });
                  },
                  onSwipeLeft: () {
                    setState(() {
                      Navigator.of(context)
                          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return new Settings();
                      }));
                    });
                  },
                  onSwipeRight: () {
                    setState(() {
                      Navigator.of(context)
                          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return new Profile();
                      }));
                    });
                  },
                  swipeConfiguration: SwipeConfiguration(
                      verticalSwipeMinVelocity: 100.0,
                      verticalSwipeMinDisplacement: 50.0,
                      verticalSwipeMaxWidthThreshold:100.0,
                      horizontalSwipeMaxHeightThreshold: 50.0,
                      horizontalSwipeMinDisplacement:50.0,
                      horizontalSwipeMinVelocity: 200.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}