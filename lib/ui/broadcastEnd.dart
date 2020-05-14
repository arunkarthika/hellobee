import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:honeybee/constant/http.dart';

class BroadcastEnd extends StatefulWidget {
  BroadcastEnd({
    Key key,
    @required this.broadcastTime,
    @required this.viewvers,
    @required this.like,
    @required this.gold,
    @required this.userId,
  }) : super(key: key);

  final String viewvers;
  final String like;
  final String broadcastTime;
  final String userId;
  final String gold;

  @override
  // State<StatefulWidget> createState() {
  EndPage createState() => EndPage(
      broadcastTime: broadcastTime,
      viewvers: viewvers,
      like: like,
      gold: gold,
      userId: userId);
  // return EndPage();
  // }
}

class EndPage extends State<BroadcastEnd> {
  EndPage(
      {Key key,
      @required this.broadcastTime,
      @required this.viewvers,
      @required this.like,
      @required this.gold,
      @required this.userId});

  final String viewvers;
  final String like;
  final String broadcastTime;
  final String userId;
  final String gold;

  var name = "";
  var gender = "Female.png";
  var level = "";
  var country = "India";
  bool loader = true;
  var profile = "";
  var refrenceId = "";
  @override
  void dispose() {
    // Dispose of the Tab Controller
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var params = "action=quickProfile&user_id=" + userId;
    makeGetRequest("user", params, 0, context).then((response) {
      var res = jsonDecode(response);
      var data = res['body'];
      print(data);
      setState(() {
        level = data['level'];
        name = data['profileName'];
        gender = "Female.png";
        if (data['gender'] == "male") gender = "male.jpg";
        country = data['country'];
        profile = data['profile_pic'];
        refrenceId = data['reference_user_id'];
        loader = false;
      });
    });
    // Initialize the Tab Controller
  }

  @override
  Widget build(BuildContext context) {
    int duration = int.parse(broadcastTime);
    final now = Duration(seconds: duration);
    var broadTime = _printDuration(now);
    print(broadTime);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: loader == true
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image(
                        image: AssetImage(
                          "assets/broadcast/AudioBG.jpg",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(profile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 240,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          "ID" + ' ' + refrenceId + ' ' + "|" + ' ' + country,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 280,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(
                                "assets/images/audience/" + gender,
                              ),
                              width: 25,
                              height: 25,
                            ),
                            Container(
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Image(
                                      image: AssetImage(
                                        "assets/images/broadcast/Star.png",
                                      ),
                                      width: 10,
                                      height: 10,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      level,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(
                                            color: Colors.white,
                                            // fontSize: 12,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 320,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "VIEWERS",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                Image(
                                  image: AssetImage(
                                    "assets/broadcast/Contributers.png",
                                  ),
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  viewvers,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "LIKES",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                Image(
                                  image: AssetImage(
                                    "assets/audience/FansList.png",
                                  ),
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  like,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "B-GOLD",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                Image(
                                  image: AssetImage(
                                    "assets/broadcast/Coin.png",
                                  ),
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  gold,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 120,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            broadTime,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _onWillPop,
                          child: Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              "OK",
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return " 0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)} Hrs $twoDigitMinutes Minutes $twoDigitSeconds Seconds";
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context);
    Navigator.of(context).pushReplacementNamed('/dashboard');
    return Future.value(true);
  }
}
