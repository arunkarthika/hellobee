import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/audio/profileUi.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

Widget audienceBroadShow(context, common) {
  print("ok =============== ok");
  return Container(
    // color: Colors.amber,
    child: Row(
      children: <Widget>[
        common.camera == true
            ? GestureDetector(
                onTap: () {
                  onBeautification(context, common);
                },
                child: Image(
                  image: AssetImage(
                    'assets/images/broadcast/Beautification.png',
                  ),
                  width: 35,
                  height: 35,
                ),
              )
            : Container(),
        SizedBox(
          width: 5,
        ),
        common.camera == true
            ? GestureDetector(
                onTap: () {
                  onSwitchCamera(common);
                },
                child: Image(
                  image: AssetImage(
                    'assets/images/broadcast/TurnCamera.png',
                  ),
                  width: 35,
                  height: 35,
                ),
              )
            : Container(),
        SizedBox(
          width: 5,
        ),
        common.userTypeGlob == "broad"
            ? Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      onInvitaion(context, common);
                    },
                    child: Image(
                      image: AssetImage(
                        'assets/images/broadcast/Beautification.png',
                      ),
                      width: 35,
                      height: 35,
                    ),
                  ),
                  common.inviteRequest.length != 0
                      ? Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            // constraints: BoxConstraints(
                            //   minWidth: 14,
                            //   minHeight: 14,
                            // ),
                            child: Text(
                              '${common.inviteRequest.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container()
                ],
              )
            : Container(),
        SizedBox(
          width: 5,
        ),
        common.guestFlag == false
            ? GestureDetector(
                onTap: () {
                  common.publishMessage(
                      common.broadcastUsername,
                      "£01GuestInvite01£*£" +
                          common.userId +
                          "£*£" +
                          common.broadcasterId.toString() +
                          "£*£" +
                          common.name +
                          "£*£" +
                          common.username +
                          "£*£" +
                          common.profilePic +
                          "£*£" +
                          common.level);
                },
                child: Image(
                  image: AssetImage(
                    'assets/images/broadcast/VideoRequest.png',
                  ),
                  width: 35,
                  height: 35,
                ),
              )
            : Container(),
        SizedBox(
          width: 5,
        ),
        GestureDetector(
          child: Image(
            image: AssetImage(
              'assets/images/broadcast/Share.png',
            ),
            width: 35,
            height: 35,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        common.gift == true
            ? GestureDetector(
                child: Image(
                  image: AssetImage(
                    "assets/images/broadcast/Gift.png",
                  ),
                  width: 50,
                  height: 50,
                ),
                onTap: () {
                  // String userId = await CommonFun().getStringData('user_id');
                  // print(userId);
                  // setState(() {
                  giftShow(context, common);
                  // });
                },
              )
            : Container(),
        common.userTypeGlob == "broad" && common.broadcastType == "solo"
            ? GestureDetector(
                child: Image(
                  image: AssetImage(
                    "assets/images/broadcast/StartPK.png",
                  ),
                  width: 50,
                  height: 50,
                ),
                onTap: () {
                  // String userId = await CommonFun().getStringData('user_id');
                  // print(userId);
                  // setState(() {
                  // giftShow(context, common);
                  // });
                },
              )
            : Container(),
      ],
    ),
  );
}

void onSwitchCamera(common) {
  // AgoraRtcEngine.switchCamera();
  common.zego.onCamStateChanged();
}

void onBeautification(context, common) {
  showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      common.zego.beautify("None");
                    },
                    child: Container(
                      width: 50,
                      height: 200,
                      alignment: Alignment.center,
                      child: Text(
                        "None",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      common.zego.beautify("sharpen");
                    },
                    child: Container(
                      width: 50,
                      height: 200,
                      alignment: Alignment.center,
                      child: Text(
                        "Sharpen",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      common.zego.beautify("polish");
                    },
                    child: Container(
                      width: 50,
                      height: 200,
                      alignment: Alignment.center,
                      child: Text(
                        "Polish",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      common.zego.beautify("whiten");
                    },
                    child: Container(
                      width: 50,
                      height: 200,
                      alignment: Alignment.center,
                      child: Text(
                        "Whiten",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      common.zego.beautify("skinWhiten");
                    },
                    child: Container(
                      width: 50,
                      height: 200,
                      alignment: Alignment.center,
                      child: Text(
                        "SkinWhiten",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void onInvitaion(context, common) {
  showModalBottomSheet(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            // height: 200,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            // child: Padding(
            // padding: EdgeInsets.only(
            //     bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Ivitation Request",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                common.inviteRequest.length != 0
                    ? Expanded(
                        child: Container(
                          child: ListView.builder(
                              itemCount: common.inviteRequest.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  // color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    common.inviteRequest[index]
                                                        .image,
                                                  ),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          width: 50,
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                common
                                                    .inviteRequest[index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              Text(
                                                common
                                                    .inviteRequest[index].level,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            print("reject");
                                            common.publishMessage(
                                              common.broadcastUsername,
                                              "£01GuestInviteResponse01£*£Rejected£*£" +
                                                  common.inviteRequest[index]
                                                      .userId +
                                                  "£*£" +
                                                  common.inviteRequest[index]
                                                      .name +
                                                  "£*£" +
                                                  common.inviteRequest[index]
                                                      .name +
                                                  "£*£" +
                                                  common.inviteRequest[index]
                                                      .image,
                                            );
                                            print(common.inviteRequest);
                                            setState(() {
                                              common.inviteRequest
                                                  .removeAt(index);
                                            });
                                            print(common.inviteRequest);
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            child: Image(
                                              image: AssetImage(
                                                "assets/images/broadcast/Reject.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            common.publishMessage(
                                              common.broadcastUsername,
                                              "£01GuestInviteResponse01£*£Accepted£*£" +
                                                  common.inviteRequest[index]
                                                      .userId +
                                                  "£*£" +
                                                  common.inviteRequest[index]
                                                      .name +
                                                  "£*£" +
                                                  common.inviteRequest[index]
                                                      .username +
                                                  "£*£" +
                                                  common.inviteRequest[index]
                                                      .image,
                                            );
                                            setState(() {
                                              common.inviteRequest
                                                  .removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            child: Image(
                                              image: AssetImage(
                                                "assets/images/broadcast/Accept.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      )
                    : Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Invitation",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        });
      });
}

void giftShow(context, common) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 250,
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: TabBar(
                          tabs: [
                            Tab(
                              child: Text(
                                "Animation GIFTS",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Sticker GIFTS",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                          ],
                          controller: common.giftController,
                          onTap: (indexs) {
                            var data;
                            int currectIndex = 0;
                            var message = "animation";
                            if (indexs == 0) {
                              currectIndex = common.animationSelect;
                              data = common.animationGift;
                            } else {
                              message = "normal";
                              currectIndex = common.normalSelect;
                              data = common.normalGift;
                            }
                            // print("=======data=============");
                            // print(data);
                            setState(() {
                              int flag =
                                  int.parse(data[currectIndex]['comboFlag']);
                              if (flag != 0) {
                                common.comboFlag = false;
                                var list = data[currectIndex]['comboPacks']
                                    .split("!")[flag];
                                common.comboList = list.split(",");
                                print('comboList');
                                print(common.comboList);
                                common.giftCountTemp =
                                    int.parse(common.comboList[0]);
                                print('giftCountTemp2');
                                print(common.giftCountTemp);
                              } else {
                                common.giftCountTemp = 1;
                                common.comboFlag = true;
                                common.comboList = [];
                              }
                            });
                            common.giftCount = common.giftCountTemp;
                            common.giftNames = data[currectIndex]['name'];
                            common.giftMessage = message;
                            common.giftValue =
                                int.parse(data[currectIndex]['price']);
                          },
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: common.animationGift.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                // print("00000000000000000000000000000");
                                // print(common.animationGift);
                                // print("index");
                                // print(index);
                                var data = common.animationGift[index];
                                // print("data");
                                // print(data);
                                // print(common.animationSelect);
                                // print(data);
                                // print('displayIcon');
                                // print(listData[index]['combo_flag']);
                                return Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        common.animationSelect = index;
                                        int flag = int.tryParse(common
                                            .animationGift[index]['comboFlag']);
                                        common.currentIndex = index;
                                        print("flag");
                                        print(flag);
                                        if (flag != 0) {
                                          common.comboFlag = false;
                                          var list = common.animationGift[index]
                                                  ['comboPacks']
                                              .split("!")[flag];
                                          common.comboList = list.split(",");
                                          print('comboList');
                                          print(common.comboList);
                                          common.giftCountTemp =
                                              int.parse(common.comboList[0]);
                                          print('giftCountTemp2');
                                          print(common.giftCountTemp);
                                        } else {
                                          common.giftCountTemp = 1;
                                          common.comboFlag = true;
                                          common.comboList = [];
                                        }
                                      });
                                      common.giftCount = common.giftCountTemp;
                                      common.giftNames = data['name'];
                                      common.giftMessage = "animation";
                                      common.giftValue =
                                          int.tryParse(data['price']);
                                      print("giftValue");
                                      print(common.giftValue);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 15, right: 15),
                                      decoration: common.animationSelect ==
                                              index
                                          ? BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.5),
                                              border: Border.all(
                                                  color: Colors.orange),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            )
                                          : BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.transparent,
                                            child: Image(
                                              image: MemoryImage(
                                                base64Decode(
                                                    common.animationGift[index]
                                                        ['giftIcon']),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(color: Colors.amber),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // crossAxisAlignment:CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image(
                                                image: AssetImage(
                                                  "assets/images/audience/Diamond.png",
                                                ),
                                                width: 10,
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                data['price'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                      color: const Color(
                                                          0xFF00DFAB),
                                                    ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: common.normalGift.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var data = common.normalGift[index];
                                // print('displayIcon');
                                // print(listData[index]['combo_flag']);
                                return Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        common.normalSelect = index;
                                        common.currentIndex = index;
                                        int flag = int.parse(common
                                            .normalGift[index]['comboFlag']);
                                        if (flag != 0) {
                                          common.comboFlag = false;
                                          var list = common.normalGift[index]
                                                  ['comboPacks']
                                              .split("!")[flag];
                                          common.comboList = list.split(",");
                                          print('comboList');
                                          print(common.comboList);
                                          common.giftCountTemp =
                                              int.tryParse(common.comboList[0]);
                                          print('giftCountTemp2');
                                          print(common.giftCountTemp);
                                        } else {
                                          common.giftCountTemp = 1;
                                          common.comboFlag = true;
                                          common.comboList = [];
                                        }
                                      });
                                      print(data['name']);
                                      print(common.giftCountTemp);
                                      common.giftCount = common.giftCountTemp;
                                      common.giftNames = data['name'];
                                      common.giftMessage = "normal";
                                      common.giftValue =
                                          int.tryParse(data['price']);
                                      print("giftValue");
                                      print(common.giftValue);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 15, right: 15),
                                      decoration: common.normalSelect == index
                                          ? BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.5),
                                              border: Border.all(
                                                  color: Colors.orange),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            )
                                          : BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.transparent,
                                            child: Image(
                                              image: MemoryImage(
                                                base64Decode(
                                                    common.normalGift[index]
                                                        ['giftIcon']),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(color: Colors.amber),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // crossAxisAlignment:CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image(
                                                image: AssetImage(
                                                  "assets/images/audience/Diamond.png",
                                                ),
                                                width: 10,
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                data['price'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                      color: const Color(
                                                          0xFF00DFAB),
                                                    ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        controller: common.giftController,
                      ),
                      flex: 7,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                              // width: 50,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    // width: 25,
                                    alignment: Alignment.center,
                                    child: Image(
                                      image: AssetImage(
                                        "assets/images/audience/Diamond.png",
                                      ),
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      common.diamond.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            color: const Color(0xFF00DFAB),
                                            fontSize: 14,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 25,
                              child: Row(
                                children: <Widget>[
                                  common.comboList.length > 0
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                                canvasColor: Colors.orange),
                                            child: DropdownButton(
                                              items: common.comboList.map<
                                                      DropdownMenuItem<String>>(
                                                  (value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              underline: SizedBox(),
                                              iconEnabledColor: Colors.white,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  common.giftCount =
                                                      int.parse(newValue);
                                                  print('giftCount3');
                                                  print(common.giftCount);
                                                });
                                              },
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: Colors.white),
                                              value:
                                                  common.giftCount.toString(),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  GestureDetector(
                                    onTap: () {
                                      print('giftCount');
                                      print(common.giftCount);
                                      print(common.giftMessage);
                                      sendGift(
                                          common.giftNames,
                                          common.giftMessage,
                                          common.giftValue,
                                          common.giftCount,
                                          setState,
                                          context,
                                          common);
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(0, 0, 0, 0.5),
                                        border:
                                            Border.all(color: Colors.orange),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 1, 10, 1),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "SEND",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                )),
          );
        },
      );
    },
  );
}

Widget showAnimationGift(common) {
  return Container(
    // color: Colors.amber,
    width: double.infinity,
    height: double.infinity,
    child: SVGAImage(common.animationController),
  );
}

Widget showNormalGift(context, common) {
  return Stack(
    children: <Widget>[
      Container(
        width: 100,
        height: 100,
        // width: double.infinity,
        // height: double.infinity,
        color: Colors.transparent,
        // color: Colors.red,
      ),
      Positioned(
        top: 0,
        left: 10,
        right: 100,
        child: Container(
          alignment: Alignment.centerLeft,
          child: SlideTransition(
            position: common.normalleft1animation,
            child: AnimatedOpacity(
              opacity: common.loading1 ? 1 : 0,
              duration: Duration(seconds: 1),
              child: Container(
                padding: EdgeInsets.fromLTRB(3, 1, 15, 1),
                height: 50,
                decoration: BoxDecoration(
                  // color: const Color.fromRGBO(255, 166, 0, 0.30),
                  // color: const Color.fromRGBO(255, 193, 0, 1),
                  gradient: LinearGradient(
                    colors: [const Color(0xFFF4CD3A), Colors.transparent],
                  ),
                  // color: const Color(0xFFF4CD3A),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    bottomLeft: const Radius.circular(25.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: NetworkImage(
                            common.normalList1.length == 0
                                ? "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png"
                                : common.normalList1[0],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            common.normalList1.length == 0
                                ? "hi"
                                : common.normalList1[1],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            common.normalList1.length == 0
                                ? "hi"
                                : common.normalList1[2],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: common.normalList1.length == 0
                              ? NetworkImage(
                                  "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png",
                                )
                              : MemoryImage(
                                  common.normalList1[3] as Uint8List,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        common.normalList1.length == 0
                            ? "x0"
                            : "x" + common.normalList1[4],
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: const Color(0xFFF4CD3A),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        left: 10,
        right: 100,
        child: Container(
          alignment: Alignment.centerLeft,
          child: SlideTransition(
            position: common.normalleft2animation,
            child: AnimatedOpacity(
              opacity: common.loading3 ? 1 : 0,
              duration: Duration(seconds: 1),
              child: Container(
                padding: EdgeInsets.fromLTRB(3, 1, 15, 1),
                height: 50,
                decoration: BoxDecoration(
                  // color: const Color.fromRGBO(255, 166, 0, 0.30),
                  // color: const Color.fromRGBO(255, 193, 0, 1),
                  gradient: LinearGradient(
                    colors: [const Color(0xFFF4CD3A), Colors.transparent],
                  ),
                  // color: const Color(0xFFF4CD3A),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    bottomLeft: const Radius.circular(25.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: NetworkImage(
                            common.normalList3.length == 0
                                ? "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png"
                                : common.normalList3[0],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            common.normalList3.length == 0
                                ? "hi"
                                : common.normalList3[1],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            common.normalList3.length == 0
                                ? "hi"
                                : common.normalList3[2],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: common.normalList3.length == 0
                              ? NetworkImage(
                                  "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png",
                                )
                              : MemoryImage(
                                  common.normalList3[3] as Uint8List,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        common.normalList3.length == 0
                            ? "x0"
                            : "x" + common.normalList3[4],
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: const Color(0xFFF4CD3A),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        left: 100,
        right: 10,
        child: Container(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: common.normalright1animation,
            child: AnimatedOpacity(
              opacity: common.loading2 ? 1 : 0,
              duration: Duration(seconds: 1),
              child: Container(
                padding: EdgeInsets.fromLTRB(3, 1, 15, 1),
                height: 50,
                decoration: BoxDecoration(
                  // color: const Color.fromRGBO(255, 166, 0, 0.30),
                  // color: const Color.fromRGBO(255, 193, 0, 1),
                  gradient: LinearGradient(
                    colors: [Colors.transparent, const Color(0xFFF4CD3A)],
                    stops: [0.1, 0.7],
                  ),
                  // color: const Color(0xFFF4CD3A),
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(25.0),
                    bottomRight: const Radius.circular(25.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Text(
                        common.normalList2.length == 0
                            ? "0x"
                            : common.normalList2[4] + "x",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: const Color(0xFFF4CD3A),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: common.normalList2.length == 0
                              ? NetworkImage(
                                  "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png",
                                )
                              : MemoryImage(
                                  common.normalList2[3] as Uint8List,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            common.normalList2.length == 0
                                ? "hi"
                                : common.normalList2[1],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            common.normalList2.length == 0
                                ? "hi"
                                : common.normalList2[2],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: NetworkImage(
                            common.normalList2.length == 0
                                ? "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png"
                                : common.normalList2[0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        left: 100,
        right: 10,
        child: Container(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: common.normalright2animation,
            child: AnimatedOpacity(
              opacity: common.loading4 ? 1 : 0,
              duration: Duration(seconds: 1),
              child: Container(
                padding: EdgeInsets.fromLTRB(3, 1, 15, 1),
                height: 50,
                decoration: BoxDecoration(
                  // color: const Color.fromRGBO(255, 166, 0, 0.30),
                  // color: const Color.fromRGBO(255, 193, 0, 1),
                  gradient: LinearGradient(
                    colors: [Colors.transparent, const Color(0xFFF4CD3A)],
                    stops: [0.1, 0.7],
                  ),
                  // color: const Color(0xFFF4CD3A),
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(25.0),
                    bottomRight: const Radius.circular(25.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Text(
                        common.normalList4.length == 0
                            ? "0x"
                            : common.normalList4[4] + "x",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: const Color(0xFFF4CD3A),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: common.normalList4.length == 0
                              ? NetworkImage(
                                  "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png",
                                )
                              : MemoryImage(
                                  common.normalList4[3] as Uint8List,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            common.normalList4.length == 0
                                ? "hi"
                                : common.normalList4[1],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            common.normalList4.length == 0
                                ? "hi"
                                : common.normalList4[2],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: NetworkImage(
                            common.normalList4.length == 0
                                ? "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png"
                                : common.normalList4[0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget arrivedShow(common) {
  return Container(
    // color: Colors.amber,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          // color: Colors.amberAccent,
          child: AnimatedBuilder(
              animation: common.arrivedMessageController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      common.arrivedMessageAnimation.value * common.widthScreen,
                      0.0,
                      0.0),
                  child: AnimatedOpacity(
                    opacity: common.arrivedStatus ? 1 : 0,
                    duration: Duration(seconds: 3),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            // alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(40, 5, 20, 5),
                                  margin: EdgeInsets.only(left: 30),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(0, 0, 0, 0.5),
                                        Colors.white
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      topLeft: Radius.circular(50),
                                    ),
                                    border: Border.all(
                                        width: 2.0,
                                        color: const Color(0xFFE59134)),
                                  ),
                                  child: Text(
                                    "    " +
                                        common.dispayEffectName +
                                        "\n\n has Arrived",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                // Positioned(
                                //   top: 0,
                                // child:
                                Container(
                                  width: 70,
                                  height: 70,
                                  // alignment: Alignment.center,
                                  // color: Colors.red,
                                  child: Image(
                                    image: NetworkImage(
                                      common.dispayEffect,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    ),
  );
}

Widget buildInfoList(common) {
  print("chatlis" +
      common.chatlist.length.toString() +
      common.chatlist[0].txtmsg);
  Timer(
      Duration(milliseconds: 100),
      () => common.mesagecontroller
          .jumpTo(common.mesagecontroller.position.maxScrollExtent));
  return ListView.builder(
    itemCount: common.chatlist.length,
    controller: common.mesagecontroller,
    itemBuilder: (context, i) {
      return Align(
        alignment: Alignment.centerLeft,
        child: common.chatlist[i].level != ""
            ? Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.30),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        profileview1(common.chatlist[i].gold, context, common);
                      },
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.purple),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 20,
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  "assets/images/dashboard/Group3.png",
                                ),
                                width: 10,
                                height: 10,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                common.chatlist[i].level,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        common.chatlist[i].txtmsg,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  common.chatlist[i].txtmsg,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white, fontSize: 12),
                ),
              ),
      );
    },
  );
}

void sendGift(
    giftName, message, giftValue, giftCount, setState, context, common) {
  var arriveMsg = "";
  if (common.diamond <= 0) {
    toast("Diamond Value is Low", Colors.red);
  } else {
    var params = {
      "giftName": giftName,
      "giftCount": giftCount.toString(),
      "giftValue": giftValue.toString(),
      "user_id": "100084",
    };
    print(jsonEncode(params));
    makePostRequest("user/sendGift", jsonEncode(params), 0, context)
        .then((response) {
      var res = jsonDecode(response);
      if (res['status'] == 0 && res['message'] == "Success") {
        print(res['body']);
        print(res['body']['sender']);
        print(res['body']['sender']['diamond_balance']);
        setState(() {
          common.gold = res['body']['receiver']['over_all_gold'];
          print("=========================gold=======================");
          print(common.gold);
          common.diamond = res['body']['sender']['diamond_balance'];
        });
        CommonFun().saveShare("diamond", common.diamond);
        print(common.name);
        print(common.username);
        print(common.profilePic);
        print(common.level);
        print(message);
        if (giftName == 'bulletMessage') {
          arriveMsg = "£01bullet01£*£" +
              common.name +
              "£*£" +
              common.username +
              "£*£" +
              Uri.encodeFull(common.profilePic) +
              "£*£" +
              common.level +
              "£*£" +
              message;
          print("message");
          print(arriveMsg);
        } else {
          arriveMsg = "£01sendGift01£*£" +
              common.userId +
              "£*£" +
              common.name +
              "£*£" +
              giftName +
              "£*£" +
              common.level +
              "£*£" +
              message +
              "£*£" +
              Uri.encodeFull(common.profilePic) +
              "£*£" +
              giftCount.toString();
          print(arriveMsg);
        }
        common.publishMessage(common.broadcastUsername, arriveMsg);
      }
    });
  }
}

void loadArrived(setState, common) async {
  if (common.arrivedStatus == false) {
    if (common.arrivedqueuelist.length != 0) {
      setState(() {
        common.dispayEffect = common.arrivedqueuelist[0].image;
        common.dispayEffectName = common.arrivedqueuelist[0].name;
      });
      common.arrivedqueuelist.removeAt(0);
      common.arrivedMessageController.reset();
      common.arrivedMessageController.forward()
        ..whenComplete(() {
          if (common.arrivedqueuelist.length != 0) {
            loadArrived(setState, common);
          }
        });
    }
  }
}

void loadNormal(setState, common) async {
  print(common.normalgiftqueuelist);
  if (common.loading1 == false) {
    if (common.normalgiftqueuelist.length != 0) {
      String currentpath = common.normalgiftqueuelist[0].giftName;
      print(currentpath);
      common.normalList1 = [
        common.normalgiftqueuelist[0].image,
        common.normalgiftqueuelist[0].name,
        common.normalgiftqueuelist[0].giftName,
        base64Decode(common.displaynormalIcon[currentpath]),
        common.normalgiftqueuelist[0].compo
      ];
      print(common.normalList1);
      common.normalgiftqueuelist.removeAt(0);
      common.normalleft1controller.reset();
      common.normalleft1controller.forward()
        ..whenComplete(() {
          if (common.normalgiftqueuelist.length != 0) {
            loadNormal(setState, common);
          }
        });
    }
  }

  if (common.loading2 == false) {
    if (common.normalgiftqueuelist.length != 0) {
      String currentpath = common.normalgiftqueuelist[0].giftName;
      common.normalList2 = [
        common.normalgiftqueuelist[0].image,
        common.normalgiftqueuelist[0].name,
        common.normalgiftqueuelist[0].giftName,
        base64Decode(common.displaynormalIcon[currentpath]),
        common.normalgiftqueuelist[0].compo
      ];
      common.normalgiftqueuelist.removeAt(0);
      common.normalright1controller.reset();
      common.normalright1controller.forward()
        ..whenComplete(() {
          if (common.normalgiftqueuelist.length != 0) {
            loadNormal(setState, common);
          }
        });
    }
  }
  if (common.loading3 == false) {
    if (common.normalgiftqueuelist.length != 0) {
      String currentpath = common.normalgiftqueuelist[0].giftName;
      print('----------------------currentpath-------------------');
      print(currentpath);
      // CommonFun.getImages(currentpath).then((bytes) async {
      common.normalList3 = [
        common.normalgiftqueuelist[0].image,
        common.normalgiftqueuelist[0].name,
        common.normalgiftqueuelist[0].giftName,
        base64Decode(common.displaynormalIcon[currentpath]),
        common.normalgiftqueuelist[0].compo
      ];
      common.normalgiftqueuelist.removeAt(0);
      common.normalleft2controller.reset();
      common.normalleft2controller.forward()
        ..whenComplete(() {
          if (common.normalgiftqueuelist.length != 0) {
            loadNormal(setState, common);
          }
        });
      // });
    }
  }
  if (common.loading4 == false) {
    if (common.normalgiftqueuelist.length != 0) {
      String currentpath = common.normalgiftqueuelist[0].giftName;
      print('----------------------currentpath-------------------');
      print(currentpath);
      // CommonFun.getImages(currentpath).then((bytes) async {
      common.normalList4 = [
        common.normalgiftqueuelist[0].image,
        common.normalgiftqueuelist[0].name,
        common.normalgiftqueuelist[0].giftName,
        base64Decode(common.displaynormalIcon[currentpath]),
        common.normalgiftqueuelist[0].compo
      ];
      common.normalgiftqueuelist.removeAt(0);
      common.normalright2controller.reset();
      common.normalright2controller.forward()
        ..whenComplete(() {
          if (common.normalgiftqueuelist.length != 0) {
            loadNormal(setState, common);
          }
        });
      // });
    }
  }
}

String getArrayInfo(Map theMap, String searchText) {
  for (var val in theMap.values) {
    if (val['name'] == searchText) return (val['title']);
  }
  return 'not found';
}

void loadAnimation(setState, common) async {
  setState(() {
    common.giftVisible = true;
  });
  // isgiftload = true;
  String currentpath = common.giftqueuelist[0].giftName;
  var videoItem;
  print("===============inside gift");
  print(currentpath);
  // CommonFun.getImages(currentpath).then((bytes) async {
  // videoItem = await SVGAParser.shared
  //     .decodeFromBuffer(base64Decode(common.displayanimaionIcon[currentpath]));
  toast("/data/user/0/com.sjh.streaming/app_flutter/halloween.svga",Colors.amber);
  videoItem = await SVGAParser.shared.decodeFromAssets(
      "/data/user/0/com.sjh.streaming/app_flutter/halloween.svga");
  common.animationController.videoItem = videoItem;
  print('requestvalues1');
  common.animationController.forward() // Try to use .forward() .reverse()
      .whenComplete(() {
    // Timer(Duration(seconds: _giftqueuelist[0].duration), () {
    common.animationController.videoItem = null;
    common.animationController.reset();
    common.giftqueuelist.removeAt(0);
    print('requestvalues');
    print(common.giftqueuelist.length);
    if (common.giftqueuelist.length != 0) {
      print('innnn');
      loadAnimation(setState, common);
    } else {
      print('outttt');

      // isgiftload = false;
      setState(() {
        common.giftVisible = false;
      });
    }
  });
  // });
}

void chatEnable(context, setState, common) {
  showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextFormField(
              focusNode: common.focusNode,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                hintText: 'Type Here...',
                counterText: "",
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                suffixIcon: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // added line
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (common.chatController.text.isEmpty) {
                            return;
                          }
                          sendGift("bulletMessage", common.chatController.text,
                              1, 0, setState, context, common);
                          common.chatController.text = "";
                        },
                        child: Image(
                          image: AssetImage(
                              "assets/images/broadcast/BulletMessage.png"),
                          // width: 25,
                          // height: 25,
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          toggleSendChannelMessage(
                              common.chatController.text, common);
                          common.chatController.text = "";
                        },
                        child: Image(
                          image: AssetImage("assets/images/broadcast/Send.png"),
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
              controller: common.chatController,
            ),
          ),
        );
      });
  common.focusNode.requestFocus();
}

Widget bulletMessageShow(common) {
  return Container(
    // alignment: Alignment.center,
    // color: Colors.red,
    child: Column(
      // crossAxisAlignment:
      //     CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          // color: Colors.pink,
          child: AnimatedBuilder(
            animation: common.bullet1controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.translationValues(
                    common.bullet1animation.value * common.widthScreen,
                    0.0,
                    0.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(3, 1, 15, 1),
                  // alignment:
                  //     Alignment.center,
                  // height: 40,
                  // width: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 166, 0, 0.30),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    // mainAxisAlignment:
                    //     MainAxisAlignment
                    //         .center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: NetworkImage(
                              common.bullet1List.length == 0
                                  ? "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png"
                                  : common.bullet1List[0],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              common.bullet1List.length == 0
                                  ? "hi"
                                  : common.bullet1List[1],
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white, fontSize: 14),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              common.bullet1List.length == 0
                                  ? "hi"
                                  : common.bullet1List[2],
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: AnimatedBuilder(
              animation: common.bullet2controller,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      common.bullet2animation.value * common.widthScreen,
                      0.0,
                      0.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 15, 1),
                    // height: 40,
                    // width: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 166, 0, 0.30),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(
                              image: NetworkImage(
                                common.bullet2List.length == 0
                                    ? "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png"
                                    : common.bullet2List[0],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                common.bullet2List.length == 0
                                    ? "hi"
                                    : common.bullet2List[1],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Colors.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                common.bullet2List.length == 0
                                    ? "hi"
                                    : common.bullet2List[2],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          // color: Colors.pink,
          child: AnimatedBuilder(
              animation: common.bullet3controller,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      common.bullet3animation.value * common.widthScreen,
                      0.0,
                      0.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 15, 1),
                    // height: 40,
                    // width: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 166, 0, 0.30),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(
                              image: NetworkImage(
                                common.bullet3List.length == 0
                                    ? "https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png"
                                    : common.bullet3List[0],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                common.bullet3List.length == 0
                                    ? "hi"
                                    : common.bullet3List[1],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Colors.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                common.bullet3List.length == 0
                                    ? "hi"
                                    : common.bullet3List[2],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    ),
    // child: SlideTransition(
    //   position: _animation,
    //   child: const Padding(
    //     padding: EdgeInsets.all(8.0),
    //     child: FlutterLogo(size: 150.0),
    //   ),
    // ),
    // width: 200,
    //     // width: double.infinity,
    // child: _buildMarquee(),
  );
}

toggleSendChannelMessage(text, common) async {
  // String text = _channelMessageController.text;
  if (text.isEmpty) {
    // _log('Please input text to send.');
    return;
  }
  try {
    var message = common.level + common.userId + common.name + " : " + text;
    print(message);
    print("messsssssssage"+message);
    common.publishMessage(common.broadcastUsername, message);

    // await _channel.sendMessage(AgoraRtmMessage.fromText(message))
    // _log('Send channel message success.');
  } catch (errorCode) {
     print('Send channel message error: ' + errorCode.toString());
  }
}

void loadBullet(common) async {
  // _animationcontroller.forward();
  print(
      "=================================_bulletqueuelist.length=====================");
  print(common.bulletqueuelist.length);
  print(
      "=================================common.animation2Status=====================");
  print(common.animation2Status);
  print(
      "=================================common.animation3Status=====================");
  print(common.animation3Status);
  print(
      "=================================common.animation1Status=====================");
  print(common.animation1Status);
  if (common.animation1Status == false) {
    if (common.bulletqueuelist.length != 0) {
      common.bullet1List = [
        common.bulletqueuelist[0].image,
        common.bulletqueuelist[0].name,
        common.bulletqueuelist[0].message
      ];
      common.bulletqueuelist.removeAt(0);
      common.bullet1controller.reset();
      common.bullet1controller.forward()
        ..whenComplete(() {
          if (common.bulletqueuelist.length != 0) {
            loadBullet(common);
          }
        });
    }
  }
  if (common.animation2Status == false) {
    if (common.bulletqueuelist.length != 0) {
      common.bullet2List = [
        common.bulletqueuelist[0].image,
        common.bulletqueuelist[0].name,
        common.bulletqueuelist[0].message
      ];
      common.bulletqueuelist.removeAt(0);
      common.bullet2controller.reset();
      common.bullet2controller.forward()
        ..whenComplete(() {
          if (common.bulletqueuelist.length != 0) {
            loadBullet(common);
          }
        });
    }
  }
  if (common.animation3Status == false) {
    if (common.bulletqueuelist.length != 0) {
      common.bullet3List = [
        common.bulletqueuelist[0].image,
        common.bulletqueuelist[0].name,
        common.bulletqueuelist[0].message
      ];
      common.bulletqueuelist.removeAt(0);
      common.bullet3controller.reset();
      common.bullet3controller.forward()
        ..whenComplete(() {
          if (common.bulletqueuelist.length != 0) {
            loadBullet(common);
          }
        });
    }
  }
}
