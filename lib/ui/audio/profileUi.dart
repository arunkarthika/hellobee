import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/http.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

profileview1(id, context, common) {
  print("id");
  print(id);
  var params = "";
  if (id == common.userId)
    params = "action=quickProfile";
  else
    params = "action=quickProfile&user_id=" + id.toString();
  print(params);
  makeGetRequest("user", params, 0, context).then((response) {
    var res = jsonDecode(response);
    var data = res['body'];
    print('iyooooooooooooooooooo');
    print(data);
    print(data['profile_pic']);
    var gender = "Female.png";
    if (data['gender'] == "male") gender = "male.jpg";
    common.userrelation = data['userRelationship'];
    print('common.userrelation');
    print(common.userrelation);
    if (common.userrelation == null) common.userrelation = 0;
    common.relationData = "Follow";
    common.relationImage = "assets/images/audience/Fans.png";
    if (common.userrelation == 1) {
      common.relationData = 'Unfollow';
      common.relationImage = "assets/images/audience/Followings.png";
    } else if (common.userrelation == 3) {
      common.relationImage = "assets/images/audience/Friends.png";
      common.relationData = 'Friend';
    }
    print('common.relationData');
    print(common.relationData);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: 500,
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 75),
                      height: double.infinity,
                      color: Colors.white,
                    ),
                    Positioned(
                      top: 100,
                      right: 10,
                      child: Text(
                        "Report",
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            image: DecorationImage(
                              image: NetworkImage(data['profile_pic']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          data['profileName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 180,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          "ID" +
                              ' ' +
                              data['reference_user_id'] +
                              ' ' +
                              "|" +
                              ' ' +
                              "India",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
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
                                      data['level'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
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
                      top: 260,
                      left: 0,
                      right: 0,
                      child: common.broadcasterId.toString() == common.userId &&
                              common.broadcasterId == id
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text("B-Gold"),
                                      Row(
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                              "assets/images/broadcast/Gold.png",
                                            ),
                                            width: 10,
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            data['over_all_gold'].toString(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text("Diamond"),
                                      Row(
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                              "assets/images/audience/Diamond.png",
                                            ),
                                            width: 10,
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            data['diamond'],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                  elevation: 5,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Image(
                                          image: AssetImage(
                                            "assets/images/audience/Message.png",
                                          ),
                                          width: 50,
                                          height: 50,
                                        ),
                                        Text(
                                          "Message",
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                common.broadcasterId.toString() ==
                                            common.userId &&
                                        common.broadcasterId != id
                                    ? Card(
                                        elevation: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            // print(id);common.broadcastUsername
                                            common.publishMessage(
                                                data['username'],
                                                "£01GuestInvite01£*£" +
                                                    id +
                                                    "£*£" +
                                                    common.broadcasterId
                                                        .toString() +
                                                    "£*£" +
                                                    data['profileName'] +
                                                    "£*£" +
                                                    data['username'] +
                                                    "£*£" +
                                                    data['profile_pic'] +
                                                    "£*£" +
                                                    data['level']);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                Image(
                                                  image: AssetImage(
                                                    "assets/images/audience/Call.png",
                                                  ),
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                Text("Call"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Card(
                                  elevation: 5,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Image(
                                          image: AssetImage(
                                            "assets/images/audience/Block.png",
                                          ),
                                          width: 50,
                                          height: 50,
                                        ),
                                        Text("Block"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    common.broadcasterId.toString() == common.userId &&
                            common.broadcasterId == id
                        ? Positioned(
                            top: 300,
                            left: 0,
                            right: 0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "Friends",
                                          ),
                                          Text(
                                            data['friends'],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "Fans",
                                          ),
                                          Text(
                                            data['fans'],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "Following",
                                          ),
                                          Text(
                                            data['followers'],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                "Target",
                                              ),
                                              Text(
                                                data['diamond'] + " Min",
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                "Acived",
                                              ),
                                              Text(
                                                data['diamond'] + " Min",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Gold Recived"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          LinearPercentIndicator(
                                            // width: 100.0,
                                            lineHeight: 8.0,
                                            percent: 0.9,
                                            progressColor:
                                                const Color(0xFFECC132),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Viewers"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          LinearPercentIndicator(
                                            // width: 100.0,
                                            lineHeight: 8.0,
                                            percent: 0.9,
                                            progressColor:
                                                const Color(0xFF32EC57),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Share"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          LinearPercentIndicator(
                                            // width: 100.0,
                                            lineHeight: 8.0,
                                            percent: 0.1,
                                            progressColor:
                                                const Color(0xFF32D9EC),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  userRelation(common.userrelation, id, common,
                                      setState, context);
                                },
                                child: Container(
                                  width: 125,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    // color: Colors.pink,
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFFEC008C),
                                        const Color(0xFFFC6767)
                                      ],
                                    ),
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 20,
                                        alignment: Alignment.center,
                                        child: Image(
                                          image: AssetImage(
                                            common.relationImage,
                                          ),
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          common.relationData,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  });
}

void userRelation(level, id, common, setState, context) {
  print('level');
  print(level);
  String endPoint = 'user/userRelation';
  var action = "";
  String returnData = "";
  String image = "Fans.png";
  int relationInt = 0;
  switch (level) {
    case 0:
      action = "follow";
      image = "Followings.png";
      returnData = "Unfollow";
      relationInt = 1;
      break;
    case 1:
      action = "unfollow";
      image = "Fans.png";
      returnData = "Follow";
      relationInt = 0;
      break;
    case 2:
      action = "follow";
      image = "Friends.png";
      returnData = "Friends";
      relationInt = 3;
      break;
    case 3:
      action = "unfollow";
      image = "Fans.png";
      returnData = "Follow";
      relationInt = 2;
      break;
    default:
  }
  var params = {
    "action": action,
    "user_id": id,
  };
  print(endPoint + jsonEncode(params));
  makePostRequest(endPoint, jsonEncode(params), 0, context)
      .then((response) async {
    setState(() {
      print(returnData);
      common.relationData = returnData;
      print(relationInt);
      common.userrelation = relationInt;
      common.relationImage = "assets/images/audience/" + image;
    });
  });
}
