import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/model/Queue.dart';
import 'package:honeybee/ui/liveroom/profileUi.dart';

import '../footer.dart';

Widget audio(context, setState, common) {
  return Stack(
    children: <Widget>[
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Image(
          image: AssetImage(
            "assets/broadcast/AudioBG.jpg",
          ),
          fit: BoxFit.cover,
        ),

        /* decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFE51E4D), const Color(0xFF181437)],
            stops: [0.1, 1],
          ),
        ),*/
      ),
      Container(
        margin: EdgeInsets.only(top: 120),
        width: double.infinity,
        height: double.infinity,
        child: GridView.count(
          controller: common.audioScrollcontroller,
          childAspectRatio: 0.7,
          crossAxisSpacing: 5,
          mainAxisSpacing: 1,
          primary: false,
          crossAxisCount: 4,
          children: List.generate(8, (index) {
            return Container(
              width: 150,
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (common.userTypeGlob == 'broad') {
                          if (common.guestData.length > index) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('Do you want to Go to?'),
                                  actions: <Widget>[
                                    new FlatButton(
                                      onPressed: () {
//                                      Navigator.pop(context);
                                        profileviewAudience(
                                            common.guestData[index].userId,
                                            context,
                                            common);
                                      },
                                      child: Text('ViewProfile'),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                        common.giftUserId =
                                            common.guestData[index].userId;
                                        giftShow(context, common);
                                      },
                                      child: Text('Gift'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Fluttertoast.showToast(msg: 'Seat Lock is on the way');


                            setState(() {
                              common.loaderInside = true;
                            });
                            var params = {
                              'action': 'addGuest',
                              'guest_id': common.userId,
                              'position': index.toString(),
                              'broadcast_id': common.broadcasterId
                            };
                            makePostRequest('user/guest', jsonEncode(params), 0, context)
                                .then((response) {
                              var data = jsonDecode(response);
                              if (data['status'] == 0) {
//                                common.guestFlag = true;
                                common.loaderInside = false;
                                common.publishMessage(
                                    common.broadcastUsername,
                                    '£01'
                                        'refreshAudience01£*£' +
                                        common.userId +
                                        '£*£' +
                                        common.name +
                                        '£*£' +
                                        common.username +
                                        '£*£' +
                                        common.profilePic +
                                        '£*£' +
                                        common.level);
                                var gData = GuestData("userId", common.name, common.username,
                                    "common.profilePic", common.level, 0, 0);
                                setState(() {
                                  common.guestData.add(gData);
                                });
                              }
                            });

                          }
                        } else if (common.guestData.length > index &&
                            common.userTypeGlob != 'broad') {
                          giftShow(context, common);
                          common.giftUserId = common.guestData[index].userId;
                        }
                      });
                    },
                    child: common.guestData.length > index
                        ? Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                          image: NetworkImage(
                            common.guestData[index].image.toString(),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                        : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          borderRadius:
                          BorderRadius.all(Radius.circular(50))),
                      child: Image(
                        image: AssetImage(
                          "assets/broadcast/chair.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  common.guestData.length > index
                      ? Container(
                    child: Text(
                      common.guestData[index].name.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.white),
                    ),
                  )
                      : Container(
                    child: Text((++index).toString()),
                  ),
                  common.guestData.length > index
                      ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        Text(
                          common.guestData[index].points.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                      : Container(),
                ],
              ),
            );
          }),
        ),
      ),
    ],
  );
}

Widget audioold(context, setState, common) {
  if (common.c == 0) {
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    common.zego.setCallback(setState);

    if (common.userTypeGlob == "broad") {
      common.zego.playViewWidget = [];
      common.zego.playViewWidget.clear();
      common.zego.setPreview(
          setState, common.broadcasterId.toString(), common.broadcastType);
      common.zego.startPublish(common.broadcasterId.toString());
    }
    print("----------------------------counter " +
        common.c.toString() +
        " ---------------------------");
    common.c++;
  } else {
    print("----------------------------counter " +
        common.c.toString() +
        " ---------------------------");
  }
  return Stack(
    children: <Widget>[
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Image(
          image: AssetImage(
            "assets/broadcast/AudioBG.jpg",
          ),
          fit: BoxFit.cover,
        ),

        /* decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFE51E4D), const Color(0xFF181437)],
            stops: [0.1, 1],
          ),
        ),*/
      ),
      Container(
        margin: EdgeInsets.only(top: 120),
        width: double.infinity,
        height: double.infinity,
        child: GridView.count(
          controller: common.audioScrollcontroller,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 1,
          primary: false,
          crossAxisCount: 4,
          children: List.generate(8, (index) {
            return Container(
              width: 150,
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (common.userTypeGlob == "broad") {
                          print("broad");
                          common.giftUserId = common.guestData[index].userId;
                          giftShow(context, common);
                        } else if (common.guestData.length > index &&
                            common.userTypeGlob != "broad") {
                          giftShow(context, common);
                          common.giftUserId = common.guestData[index].userId;
                        }
                        print(common.giftUserId);
                      });
                    },
                    child: common.guestData.length > index
                        ? Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          image: NetworkImage(
                            common.guestData[index].image,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                        : Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          borderRadius:
                          BorderRadius.all(Radius.circular(50))),
                      child: Image(
                        image: AssetImage(
                          "assets/broadcast/chair.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  common.guestData.length > index
                      ? Container(
                    child: Text(
                      common.guestData[index].name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Colors.white),
                    ),
                  )
                      : Container(
                    child: Text((++index).toString()),
                  ),
                  common.guestData.length > index
                      ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        Text(
                          common.guestData[index].points.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                      : Container(),
                ],
              ),
            );
          }),
        ),
      ),
    ],
  );
}
