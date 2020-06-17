import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honeybee/music/main_1.dart';
import 'package:honeybee/ui/editprofile.dart';
import 'package:honeybee/ui/liveroom/constants.dart' as Constants;
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/constant/models.dart';
import 'package:honeybee/model/AudienceList.dart';
import 'package:honeybee/model/Chatmodel.dart';
import 'package:honeybee/model/Queue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:honeybee/ui/message.dart';
import 'package:honeybee/ui/search_page.dart';
import 'package:honeybee/utils/global.dart';
import 'package:honeybee/widget/mycircleavatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:wakelock/wakelock.dart';
import '../Dashboard.dart';
import '../broadcastEnd.dart';

import 'body/audio.dart';
import 'commonFun.dart';
import 'footer.dart';

class LiveRoom extends StatefulWidget {
  LiveRoom({
    Key key,
    @required this.userId1,
    @required this.username1,
    @required this.userType1,
    @required this.broadcastType1,
    @required this.broadcasterId1,
  }) : super(key: key);

  final String broadcastType1;
  final String userId1;
  final String username1;
  final String userType1;
  final String broadcasterId1;

  RenderBroadcast createState() => RenderBroadcast(
        userId: userId1,
        broadcastUsername: username1,
        userType: userType1,
        broadcastType: broadcastType1,
        broadcasterId: broadcasterId1,
      );
}

class RenderBroadcast extends State<LiveRoom>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  RenderBroadcast({
    Key key,
    @required this.userId,
    @required this.broadcastUsername,
    @required this.userType,
    @required this.broadcastType,
    @required this.broadcasterId,
  });

  final String broadcastType;
  final String userId;
  final String broadcasterId;
  final String userType;
  final String broadcastUsername;
  Common common = Common();

  final String pk = 'assets/liveroom/pk.svg';
  final String gallery = 'assets/liveroom/gallery.svg';
  final String music = 'assets/liveroom/music.svg';
  final String games = 'assets/liveroom/games.svg';
  final String heart = 'assets/liveroom/heart.svg';

  final List tags = [
    "↑Lv 10",
    '🌝 Happy face',
    "💎 50K",
    "♀ Male",
    "💐 Life style🤳",
    "Bio: 😚 Forget Whoe Forgets U 👍"
  ];
  
  @override
  void initState() {
    common.animationController = SVGAAnimationController(vsync: this);
    loadAnimation(setState, common);
    Wakelock.enable();
    CommonFun().saveShare('broadcasterId', broadcasterId);
    CommonFun().saveShare('broadcastUsername', broadcastUsername);
    CommonFun().saveShare('userType', userType);
    common.dataGet();
    common.broadcasterId = broadcasterId;
    common.broadcastUsername = broadcastUsername;
    common.giftController = TabController(length: 2, vsync: this);
    print("okok1");
    Timer(Duration(milliseconds: 500), () {
      print("okok2");
      prepareMqttClient();
      print("Yeah, this line is printed after 1 seconds");
      ZegoUser user = ZegoUser(userId, common.username);
      ZegoExpressEngine.instance.loginRoom(broadcastUsername, user);

      common.zego.setCallback(setState);

      common.zego.width = MediaQuery.of(context).size.width.ceil().toInt();
      common.zego.height = (MediaQuery.of(context).size.height.ceil().toInt());

      Timer(Duration(milliseconds: 500), () {
        onMessage();
        print(userType);
        if (userType == "broad") {
          common.broadcastType = broadcastType;
          getAudience();
          String endPoint = 'user/goLive';
          var params = {
            "action": "live",
            "broadcast_type": broadcastType,
          };

          print(endPoint + jsonEncode(params));
          makePostRequest(endPoint, jsonEncode(params), 0, context)
              .then((response) {
            print("object" + response);

            setState(() {
              common.gift = false;
              common.camera = true;
              common.loader = false;
              common.guestFlag = true;
            });
          });
        } else {
          addAudience();
        }
      });
    });

    print(common.chatlist);
    Chatmodel chatmodel = Chatmodel(
        "",
        "",
        "Warning : We moderate Live Broadcast. Smoking, Vulgarity, Porn, Indecent exposure, child pornographu and abuse or Any copyright infringement is NOT allowed and will be banned. Live broadcasts are monitored 24X7 . Hack or mis-uses subject to account closure,suspension , or permanent Ban  ",
        "grey");
    common.chatlist.add(chatmodel);
    print(common.chatlist);

    giftControllerFun();

    common.scrollControllerforbottom.addListener(() {
      print(common.scrollControllerforbottom.position.pixels);
      print(common.scrollControllerforbottom.position.maxScrollExtent);
      if (common.scrollControllerforbottom.position.pixels ==
          common.scrollControllerforbottom.position.maxScrollExtent) {
        if (common.pageforbottm <= common.lastpageforbottom) {
          common.pageforbottm++;
          getaudiencelist(common, context);
        }
      }
    });

    common.scrollController.addListener(() {
      if (common.scrollController.position.pixels ==
          common.scrollController.position.maxScrollExtent) {
        if (common.page <= common.pageLength) {
          common.page++;
          getAudience();
        }
      }
    });

    SystemChannels.lifecycle.setMessageHandler((state) {
      common.publishMessage(
          common.broadcastUsername, "on detached " + state.toString());
      if (state.toString() == "AppLifecycleState.paused") {
        common.currentPassTime = DateTime.now();
      }
      if (state.toString() == "AppLifecycleState.detached") {
        common.publishMessage(common.broadcastUsername, "on detached");
        print("app Destroyed");
      }
      if (state.toString() == "AppLifecycleState.resumed") {
        common.idelTime += dateTimeDiff(common.currentPassTime);
        print('common.idelTime');
        print(common.idelTime);
      }
      return null;
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (userType == "broad") {
      ZegoExpressEngine.instance.stopPublishingStream();
    }
    ZegoExpressEngine.instance.stopPreview();
    ZegoExpressEngine.onPublisherStateUpdate = null;
    ZegoExpressEngine.onPublisherQualityUpdate = null;
    ZegoExpressEngine.onPublisherVideoSizeChanged = null;

    ZegoExpressEngine.onPlayerStateUpdate = null;
    ZegoExpressEngine.onPlayerQualityUpdate = null;
    ZegoExpressEngine.onPlayerVideoSizeChanged = null;

    for (final streamID in common.zego.previewID.keys) {
      disposePlay(streamID);
    }

    ZegoExpressEngine.instance.logoutRoom(broadcastUsername);
    common.zego.playViewWidget = [];
    common.zego.playViewWidget.clear();
    common.c = 0;
    common.zego.guest = [];
    common.zego.guest.clear();
    common.scrollController.dispose();
    common.chatController.dispose();
    common.giftController.dispose();
    common.animationController.dispose();
    common.normalleft1controller.dispose();
    common.normalleft2controller.dispose();
    common.normalright1controller.dispose();
    common.normalright2controller.dispose();
    common.mesagecontroller.dispose();
    common.bullet1controller.dispose();
    common.bullet2controller.dispose();
    common.bullet3controller.dispose();
    common.arrivedMessageController.dispose();
    common.menuController.dispose();
    common.audioScrollcontroller.dispose();
    Timer(Duration(milliseconds: 1200), () {
      common.client.disconnect();
    });
    super.dispose();
  }

  disposePlay(streamID) {
    print(common.zego.previewID[streamID]);
    int stream = common.zego.previewID[streamID];
    ZegoExpressEngine.instance.destroyTextureRenderer(stream);
    ZegoExpressEngine.instance.stopPlayingStream(streamID.toString());
  }

  @override
  Widget build(BuildContext context) {
    common.widthScreen = MediaQuery.of(context).size.width;
    return GestureDetector(
      onDoubleTap: () {

      },
      child: SafeArea(
        child: common.loader == true
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : WillPopScope(
                onWillPop: userType != "broad" ? onWillPopOffline : onWillPop,
                child: SwipeDetector(
                  child: Scaffold(
                    body: Stack(
                      children: common.swipeup
                          ? <Widget>[body()]
                          : <Widget>[
                              body(),
                              header(),
                              footer()
                            ],
                    ),
                  ),
                  onSwipeUp: () {
                    print("up");
                   /* switchToAnother(common.prevUserId, common.prevUsername);*/
                  },
                  onSwipeDown: () {
                   /* switchToAnother(common.nextUserId, common.nextUsername);*/
                    print("down");
                  },
                  onSwipeLeft: () {
                    print("left");
                    setState(() {
                      common.swipeup = false;
                    });
                  },
                  onSwipeRight: () {
                    print("right");
                    setState(() {
                      common.swipeup = true;
                    });
                  },
                ),
              ),
      ),
    );
  }

  Widget header() {
    return Stack(
      children: <Widget>[
        broadDataLeft(context, common),
        Positioned(
          top: 70,
          right: 15,
          child: SingleChildScrollView(
            child: Container(
              width: 250,
              height: 45,
              child: audienceListView(common),
            ),
          ),
        ),
        Positioned(
          top: 25,
          right: 15,
          child: GestureDetector(
            onTap: userType != "broad" ? onWillPopOffline : onWillPop,
            child: Image(
              color: Colors.white,
              image: AssetImage(
                "assets/broadcast/Close.png",
              ),
              width: 15,
              height: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget body() {
    print(common.broadcastType);
    return audio(context, setState, common);
  }

  Widget footer() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 100,
          left: 0,
          right: -3,
          child: arrivedShow(common),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 1.7,
          left: 10,
          bottom: 50,
          right: 60,
          child: Container(
            // color:Colors.lime,
            height: 300,
            child: buildInfoList(common),
          ),
        ),
        Positioned(
          child: showAnimationGift(common),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 250,
          child: showNormalGift(context, common),
        ),
        Positioned(
          bottom: 200,
          left: 10,
          right: 10,
          child: bulletMessageShow(common),
        ),
        Positioned(
          bottom: 10.0,
          left: 10.0,
          child: GestureDetector(
            onTap: () => _profileview(),
            child: Image(
              image: AssetImage(
                "assets/broadcast/menu.png",
              ),
              width: 28,
              height: 28,
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 90.0,
          child: GestureDetector(
            onTap: () => {

            },
            child: Image(
              image: AssetImage(
                "assets/broadcast/mic.png",
              ),
              width: 28,
              height: 28,
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 50.0,
          child: GestureDetector(
            onTap: () {
              chatEnable(context, setState, common);
            },
            child: Image(
              image: AssetImage(
                "assets/broadcast/Chat.png",
              ),
              width: 28,
              height: 28,
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 130.0,
          child: GestureDetector(
            onTap: () {
              _share();
            },
            child: Image(
                image: AssetImage(
                  "assets/liveroom/share.png",
                ),
                width: 28,
                height: 28,
                color: Colors.white
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            child: Image(
              image: AssetImage(
                "assets/broadcast/gift.png",
              ),
              width: 35,
              height: 35,
            ),
            onTap: () {
              giftShow(context, common);
            },
          ),
        ),
      ],
    );
  }

  Future<bool> onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Quit BroadCast?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  exit(context);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> onWillPopOffline() async {
    if (common.guestFlag == true) {
      common.removeGuest(common.userId, context);
    }
    String endPoint = "user/audiance";
    print(endPoint);
    var params = {
      "action": "removeAudience",
      "length": "10",
      "page": common.page.toString(),
      "user_id": broadcasterId
    };

    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      common.audiencelist.removeWhere((item) => item.userId == userId);
      var arriveMsg = "£01RemoveAud01£*£" +
          userId +
          "£*£" +
          common.name +
          "£*£" +
          common.username +
          "£*£" +
          Uri.encodeFull(common.profilePic) +
          "£*£" +
          common.level;
      print(arriveMsg);
      toggleSendChannelMessage(arriveMsg, common);
      if (common.guestFlag == false) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (Route<dynamic> route) => false,
        );
      }
    });
    return Future.value(true);
  }

  void getaudiencelist(common, context) {
    String endPoint = "user/List";
    String params = "page=" +
        common.page.toString() +
        "&length=10&action=audience&user_id=" +
        common.broadcasterId.toString();
    print(params);
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      setState(() {
        common.lastpageforbottom = pic['body']["last_page"];
        var res = pic['body']['audience']['viewers_list'];
        if (res.length > 0) {
          for (dynamic v in res) {
            var relation = v['userRelation'];
            relation = relation == null ? 0 : relation;
            IconData icon = Icons.add;
            var name = "Follow";
            print("relation");
            print(relation);
            if (relation == 1) {
              name = "Unfollow";
              icon = Icons.remove;
            } else if (relation == 3) {
              name = "Friend";
              icon = Icons.swap_horiz;
            }

            Person person = Person(v["profileName"], v["user_id"], v["level"],
                v['userRelation'], v['profile_pic'], name, icon);
            common.filteredList.add(person);
          }
        }
      });
    });
  }

  getAudience() async {
    String endPoint = "user/List";
    String params = "page=" +
        common.page.toString() +
        "&length=10&action=audience&user_id=" +
        broadcasterId.toString();
    print(params);
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      print(pic);
      if (common.page <= common.pageLength) {
        for (var list in pic['body']['audience']['viewers_list']) {
          AudienceList audList = AudienceList(list["user_id"],
              list["profileName"], list["username"], list["profile_pic"]);
          common.audiencelist.insert(0, audList);
        }
        common.pageLength = pic['body']['last_page'];
      }
      common.guestList = pic['body']['audience']['guestList'];

      print("***************************************");
      print(common.guestList);
      print("***************************************");

      if (common.guestList == null) common.guestList = {};
      common.guestData = [];
      common.guestData.clear();
      common.guestList.forEach((k, v) {
        GuestData gData = GuestData(k, v["profileName"], v["username"],
            v["profile_pic"], v["level"], 0);
        common.guestData.add(gData);
        print('Key=$k, Value=$v');

        common.zego.playRemoteStream(k, setState, common.broadcastType);
        // }
      });
      setState(() {
        common.guestData = common.guestData;
      });

      print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
      print(common.zego.guest.toString());
      print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
    });
  }

  dateTimeDiff(time) {
    DateTime now = DateTime.now();
    var diff = now.difference(time).inSeconds;
    return diff;
  }

  void exit(contexts) {
    var actualBroadcastingTime;
    Navigator.of(contexts).pop(false);
    if (userType == "broad") {
      String endPoint = 'user/goLive';
      var broadcastingTime = dateTimeDiff(common.currentTime);
      actualBroadcastingTime = broadcastingTime - common.idelTime;
      var params = {
        "action": "offline",
        "broadcast_type": broadcastType,
        "broadcasting_time": broadcastingTime.toString(),
        "idle_time": common.idelTime.toString(),
        "actual_broadcasting_time": actualBroadcastingTime.toString(),
      };

      print(endPoint + jsonEncode(params));
      makePostRequest(endPoint, jsonEncode(params), 0, context)
          .then((response) {
        print("object" + response);
        print(userType);
        Navigator.pop(context);
        userType == "broad"
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BroadcastEnd(
                      broadcastTime: actualBroadcastingTime.toString(),
                      viewvers: common.audiencelist.length.toString(),
                      like: common.like.toString(),
                      gold: common.bgold.toString(),
                      userId: broadcasterId),
                ),
                (Route<dynamic> route) => false,
              )
            : Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (Route<dynamic> route) => false,
              );
      });
    }
  }

  addAudience() async {
    String endPoint = "user/audiance";
    var params = {
      "action": "addAudience",
      "length": "10",
      "page": common.page.toString(),
      "user_id": common.broadcasterId
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      setState(() {
        if (common.page <= common.pageLength) {
          for (var list in pic['body']['viewers_list']) {
            AudienceList audList = AudienceList(list["user_id"],
                list["profileName"], list["username"], list["profile_pic"]);
            common.audiencelist.insert(0, audList);
          }
          common.broadcasterProfileName =
              pic['body']['broadCastList']['profileName'];
          common.broadcastType = pic['body']['broadCastList']['broadcast_type'];
          common.gold =
              int.tryParse(pic['body']['broadCastList']['over_all_gold']);
          common.broadprofilePic = pic['body']['broadCastList']['profile_pic'];
          common.giftUserId =
              pic['body']['broadCastList']['user_id'].toString();
          common.broadcastUsername = pic['body']['broadCastList']['username'];
          common.broadcasterId = pic['body']['broadCastList']['user_id'];
          common.pageLength = pic['body']['last_page'];
          print("gggggggggguestgggggggggg");
          print(pic['body']['guestList']);
          common.guestList = pic['body']['guestList'];
        }
        if (common.guestList == null) common.guestList = {};
        print("jdklafkedafejhlkfaelkfaef");
        print(common.broadcasterId);
        print(common.giftUserId);
        common.zego.playViewWidget.clear();
        common.zego.playRemoteStream(
            common.broadcasterId, setState, common.broadcastType);
        common.guestData = [];
        common.guestData.clear();
        common.guestList.forEach((k, v) {
          GuestData gData = GuestData(k, v["profileName"], v["username"],
              v["profile_pic"], v["level"], 0);
          common.guestData.add(gData);
          print('Key=$k, Value=$v');
          common.zego.playRemoteStream(k, setState, common.broadcastType);
        });
        common.guestData = common.guestData;
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        print(common.zego.guest.toString());
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        print('ofter fun');
        common.gift = true;
        common.camera = false;
        common.loader = false;
        common.guestFlag = false;

        var arriveMsg = "£01getGuestData01£*£" +
            userId +
            "£*£" +
            common.name +
            "£*£" +
            common.username +
            "£*£" +
            Uri.encodeFull(common.profilePic) +
            "£*£" +
            common.level +
            "£*£" +
            common.entranceEffect;
        toggleSendChannelMessage(arriveMsg, common);
      });
    });
  }

  void giftControllerFun() {
    common.menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    print("=======arrivedMessageController==============");
    common.arrivedMessageController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    print('=======================common.arrivedMessageController==========');
    print(common.arrivedMessageController);
    common.arrivedMessageAnimation =
        Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: common.arrivedMessageController,
      curve: Curves.easeIn,
    ))
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              setState(() {
                common.arrivedStatus = true;
              });
            }
            if (status == AnimationStatus.completed) {
              setState(() {
                common.arrivedStatus = false;
              });
              common.arrivedMessageController.stop();
            }
          });
    print("=======bullet1controller==============");
    common.bullet1controller =
        AnimationController(duration: Duration(seconds: 15), vsync: this);
    common.bullet1animation =
        Tween(begin: 1.0, end: -1.0).animate(CurvedAnimation(
      parent: common.bullet1controller,
      curve: Curves.fastOutSlowIn,
    ))
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              setState(() {
                common.animation1Status = true;
              });
            }
            if (status == AnimationStatus.completed) {
              setState(() {
                common.animation1Status = false;
              });
              common.bullet1controller.stop();
            }
          });
    print("=======bullet2controller==============");
    common.bullet2controller =
        AnimationController(duration: Duration(seconds: 15), vsync: this);
    common.bullet2animation =
        Tween(begin: 1.0, end: -1.0).animate(CurvedAnimation(
      parent: common.bullet2controller,
      curve: Curves.fastOutSlowIn,
    ))
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              setState(() {
                common.animation2Status = true;
              });
            }
            if (status == AnimationStatus.completed) {
              setState(() {
                common.animation2Status = false;
              });
              common.bullet2controller.stop();
            }
          });
    print("=======bullet3controller==============");
    common.bullet3controller =
        AnimationController(duration: Duration(seconds: 15), vsync: this);
    common.bullet3animation =
        Tween(begin: 1.0, end: -1.0).animate(CurvedAnimation(
      parent: common.bullet3controller,
      curve: Curves.fastOutSlowIn,
    ))
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              setState(() {
                common.animation3Status = true;
              });
            }
            if (status == AnimationStatus.completed) {
              setState(() {
                common.animation3Status = false;
              });
              common.bullet3controller.stop();
            }
          });
    print("=======normalleft1controller==============");
    common.normalleft1controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    common.normalleft1animation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0.0, -6.0))
        .animate(CurvedAnimation(
      parent: common.normalleft1controller,
      curve: Curves.fastOutSlowIn,
    ))
          ..addStatusListener((status) {
            print("========================= normal status===================");
            print(status);

            if (status == AnimationStatus.forward) {
              setState(() {
                common.loading1 = true;
              });
            }
            if (status == AnimationStatus.completed) {
              setState(() {
                common.loading1 = false;
              });
              common.normalleft1controller.stop();
            }
          });
    print("=======normalleft2controller==============");
    common.normalleft2controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    common.normalleft2animation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0.0, -6.0))
        .animate(CurvedAnimation(
      parent: common.normalleft2controller,
      curve: Curves.fastOutSlowIn,
    ))
          ..addStatusListener((status) {
            print("========================= normal status===================");
            print(status);

            if (status == AnimationStatus.forward) {
              setState(() {
                common.loading3 = true;
              });
            }
            if (status == AnimationStatus.completed) {
              setState(() {
                common.loading3 = false;
              });
              common.normalleft2controller.stop();
            }
          });
    print("=======normalright1controller==============");
    common.normalright1controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    common.normalright1animation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0.0, -6.0))
        .animate(CurvedAnimation(
      parent: common.normalright1controller,
      curve: Curves.fastOutSlowIn,
    ))
          ..addStatusListener((status) {
            print("========================= normal status===================");
            print(status);

            if (status == AnimationStatus.forward) {
              setState(() {
                common.loading2 = true;
              });
            }
            if (status == AnimationStatus.completed) {
              setState(() {
                common.loading2 = false;
              });
              common.normalright1controller.stop();
            }
          });
    print("=======normalright2controller==============");
    common.normalright2controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    common.normalright2animation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0.0, -6.0))
        .animate(CurvedAnimation(
      parent: common.normalright2controller,
      curve: Curves.fastOutSlowIn,
    ))
          ..addStatusListener((status) {
            print("========================= normal status===================");
            print(status);

            if (status == AnimationStatus.forward) {
              setState(() {
                common.loading4 = true;
              });
            }
            if (status == AnimationStatus.completed) {
              setState(() {
                common.loading4 = false;
              });
              common.normalright2controller.stop();
            }
          });
  }

  void onMessage() {
    common.client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      MqttPublishMessage recMess = c[0].payload;
      // print(c[0].topic);
      String receivedTopic = c[0].topic;
      // String LocationJson=recMess.payload.message.toString();
      String locationJson =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print("MQTTClientWrapper::GOT A  MESSAGE $locationJson");
      // buildchatzone("GOT A  MESSAGE $receivedTopic $LocationJson");

      var tmpmsg = locationJson;
      if (tmpmsg.contains("£01AudArrive01£*") && !tmpmsg.contains(userId)) {
        var arrData = tmpmsg.split("£*£");
        setState(() {
          AudienceList audList =
              AudienceList(arrData[1], arrData[2], arrData[3], arrData[4]);
          common.audiencelist.insert(0, audList);
          Arrivedqueue giftqueue = Arrivedqueue(arrData[2], arrData[6]);
          common.arrivedqueuelist.add(giftqueue);
          loadArrived(setState, common);
          // // var arriveMsg="£01AudArrive01£*£"+userId+"£*£"+name+"£*£"+username+"£*£"+profilePic;
          //  _channel.sendMessage(AgoraRtmMessage.fromText(arriveMsg));
          var arrived = arrData[5] + arrData[1] + arrData[2] + " has arrived";
          buildchatzone(arrived, "blue");
        });
      } else if (tmpmsg.contains("£01getGuestData01£*£")) {
        if (common.broadcastType != "solo" &&
            common.broadcastType != "pk" &&
            common.userTypeGlob == "broad") {
          var arrData = tmpmsg.split("£*£");
          var arriveMsg = "£01GuestDataUpdate01£*£" +
              arrData[1] +
              "£*£" +
              jsonEncode(common.guestData.map((i) => i.toJson()).toList())
                  .toString();
          toggleSendChannelMessage(arriveMsg, common);
        }
      } else if (tmpmsg.contains("£01GuestDataUpdate01£*")) {
        var arrData = tmpmsg.split("£*£");
        print(arrData[1] + " == " + common.userId);
        if (arrData[1] == common.userId) {
          var jsonData = jsonDecode(arrData[2]);
          print(jsonData);
          for (var gdata in jsonData) {
            common.guestData.forEach((item) {
              print(item.userId + ' and ' + gdata['userId']);
              if (item.userId == gdata['userId']) {
                print("before points");
                print(item.points);
                item.points = gdata['points'];
                print("after points update");
                print(item.points);
              }
            });
            print(gdata['userId'].toString());
            print(gdata['points']);
          }
          // setState(() {

          // common.guestData=common.guestData;
          print("ggggggggggggggggggggggggggggggggggggggggggggggggggg");
          print(jsonEncode(common.guestData.map((i) => i.toJson()).toList())
              .toString());
          print(common.guestData[0].points);
          // print("ggggggggggggggggggggggggggggggggggggggggggggggggggg");
          // common.guestData = [];
          // GuestData.fromJson(jsonData);
          // print("ggggggggggggggggggggggggggggggggggggggggggggggggggg");
          // print(jsonEncode(common.guestData.map((i) => i.toJson()).toList())
          //     .toString());
          // print("ggggggggggggggggggggggggggggggggggggggggggggggggggg");
          // });
        }
      } else if (tmpmsg.contains("£01RemoveAud01£*") &&
          !tmpmsg.contains(userId)) {
        var arrData = tmpmsg.split("£*£");
        setState(() {
          // AudienceList audList =
          //     AudienceList(arrData[1], arrData[2], arrData[3], arrData[4]);
          common.audiencelist.removeWhere((item) => item.userId == arrData[1]);
          // common.audiencelist.remove(audList);
          var arrived = arrData[5] + arrData[1] + arrData[2] + " has Left";
          buildchatzone(arrived, "pinkAccent");
        });
      } else if (tmpmsg.contains("£01sendGift01£*")) {
        var arrData = tmpmsg.split("£*£");
        int giftTempvalue = int.tryParse(arrData[7]) * int.tryParse(arrData[8]);

        if (common.userTypeGlob == "broad") {
          common.bgold += giftTempvalue;
        }
        if (common.broadcastType == "audio") {
          setState(() {
            if (common.userId == arrData[9]) {
              common.gold += giftTempvalue;
            }
          });
          // var temp =
          common.guestData.forEach((item) {
            print(item.userId + ' and ' + arrData[1]);
            if (item.userId == arrData[9]) {
              print("before points");
              print(item.points);
              item.points += giftTempvalue;
              print("after points update");
              print(item.points);
            }
          });
          String json =
              jsonEncode(common.guestData.map((i) => i.toJson()).toList())
                  .toString();
          print(json);
          // common.guestData.indexWhere((item){

          // });
          //  item.userId == arrData[1]);
          print("selected receiver index");
          //     print(temp);
          // common.guestData[temp].points += common.gold;
        } else {
          setState(() {
            common.gold += giftTempvalue;
          });
        }
        if (arrData[5] == "normal") {
          NormalGiftqueue giftqueue =
              NormalGiftqueue(arrData[2], arrData[3], arrData[6], arrData[7]);
          common.normalgiftqueuelist.add(giftqueue);
          // // if (isnormalload == false) {
          loadNormal(setState, common);
          // }
        } else {
          Giftqueue giftqueue = Giftqueue(arrData[3]);
          common.giftqueuelist.add(giftqueue);
          loadAnimation(setState, common);
          // }
        }
        var arrived =
            arrData[4] + arrData[1] + arrData[2] + " has sent " + arrData[3];
        buildchatzone(arrived, "yellow");
      } else if (tmpmsg.contains("£01GuestInvite01£*") &&
          receivedTopic == common.username) {
        print("=============function inside invitation============");
        var arrData = tmpmsg.split("£*£");
        print(arrData);
        print(common.inviteRequest
                .indexWhere((item) => item.userId == arrData[1])
                .toString() +
            " soundar");
        var content = arrData[3] +
            "  Has Sent You Request " +
            common.inviteRequest
                .indexWhere((item) => item.userId == arrData[1])
                .toString() +
            " soundar";
        if (userType == "broad") {
          if (common.inviteRequest
                  .indexWhere((item) => item.userId == arrData[1])
                  .toString() ==
              "-1") {
            InviteRequest queue = InviteRequest(
                arrData[3], arrData[5], arrData[6], arrData[1], arrData[4]);
            print(content);
            setState(() {
              common.inviteRequest.add(queue);
            });
          }
        } else {
          _invitationPopUp(content, arrData[1], "guest", common.broadcastUsername);
        }
      } else if (tmpmsg.contains("£01GuestInviteResponse01£*")) {
        var arrData = tmpmsg.split("£*£");
        if (arrData[1] == "Accepted") {
          if (userId == arrData[2]) {
            addGuest();
          }
        }
      } else if (tmpmsg.contains("£01relationStatus01£*")) {
        var arrData = tmpmsg.split("£*£");
        if (arrData[1] == "unfollow")
          buildchatzone(
              arrData[3] + " has " + arrData[1] + "ed the anchor.", "grey");
        else
          buildchatzone(
              arrData[3] + " has " + arrData[1] + "ed the anchor.", "green");
      } else if (tmpmsg.contains("£01PK!nvIte01£*") &&
          receivedTopic == common.username) {
        print("=============function inside invitation============");
        var arrData = tmpmsg.split("£*£");
        print(arrData);
        var content = arrData[7] + "  Has Sent PK Request";
        print(content);
        print(userId + " and " + arrData[1]);

        if (userId == arrData[1]) {
          _invitationPopUp(content, arrData[1], "pk", arrData[6]);
        }
      } else if (tmpmsg.contains("£01PKInviteResponse01£*")) {
        var arrData = tmpmsg.split("£*£");
        if (receivedTopic == common.username) {
          if (arrData[1] == "Accepted") {
            toast("PK request Accepted", Colors.orange);
          } else {
            toast("PK request rejected", Colors.orange);
          }
        }
      } else if (tmpmsg.contains("£01RemoveGus01£*")) {
        var arrData = tmpmsg.split("£*£");
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        print(common.zego.guest.toString());
        print(common.guestData
            .indexWhere((item) => item.userId == arrData[1])
            .toString());
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        // int pos = common.zego.guest.indexOf(arrData[1]);
        // print(pos.toString());
        // common.zego.guest.removeAt(pos);
        // pos = pos + 1;
        // if (broadcastType != "audio") {
        //   common.zego.playViewWidget.removeAt(pos);
        // }

        int pos =
            common.guestData.indexWhere((item) => item.userId == arrData[1]);
        // common.zego.guest.removeAt(pos);
        pos = pos + 1;
        if (broadcastType != "audio") {
          common.zego.playViewWidget.removeAt(pos);
        }
        setState(() {
          common.guestData.removeWhere((item) => item.userId == arrData[1]);
        });
        if (arrData[1] != userId &&
            arrData[1] != common.broadcasterId &&
            broadcastType != "audio") {
          disposePlay(arrData[1]);
        } else if (arrData[1] == userId) {
          common.camera = false;
          common.guestFlag = false;
          ZegoExpressEngine.instance.stopPublishingStream();
          ZegoExpressEngine.instance.stopPreview();
        }
      } else if (tmpmsg.contains("£01bullet01£*")) {
        var arrData = tmpmsg.split("£*£");
        Bulletqueue giftqueue = Bulletqueue(arrData[1], arrData[5], arrData[3]);
        // setState(() {
        common.bulletqueuelist.add(giftqueue);
        // });
        loadBullet(common);
      } else if (tmpmsg.contains("£01refreshAudience01£*")) {
        var arrData = tmpmsg.split("£*£");
        if (userId != arrData[1]) {
          getAudience();
        }
      } else {
        print("==============LocationJson================");
        print(locationJson);
        if (!tmpmsg.contains("£*£")) buildchatzone(locationJson, "white");
      }
    });
  }

  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
  }

  Future<bool> _invitationPopUp(inviteString, id, type, topic) async {
    print("okoko");
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            content: Builder(builder: (context) {
              return Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Text(
                        inviteString,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          var msgString;
                          switch (type) {
                            case "guest":
                              msgString =
                                  "£01GuestInviteResponse01£*£Accepted£*£" +
                                      id +
                                      "£*£" +
                                      common.name +
                                      "£*£" +
                                      common.username +
                                      "£*£" +
                                      common.profilePic;
                              break;
                            case "pk":
                              msgString =
                                  "£01PKInviteResponse01£*£Accepted£*£" +
                                      id +
                                      "£*£" +
                                      common.name +
                                      "£*£" +
                                      common.username +
                                      "£*£" +
                                      common.profilePic +
                                      "£*£" +
                                      common.broadcastUsername;
                              break;
                            default:
                              msgString =
                                  "£01GuestInviteResponse01£*£Accepted£*£" +
                                      id +
                                      "£*£" +
                                      common.name +
                                      "£*£" +
                                      common.username +
                                      "£*£" +
                                      common.profilePic;
                              break;
                          }
                          common.publishMessage(topic, msgString);
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image(
                            image: AssetImage(
                              "assets/broadcast/Chair.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          var msgString;
                          switch (type) {
                            case "guest":
                              msgString =
                                  "£01GuestInviteResponse01£*£Rejected£*£" +
                                      id +
                                      "£*£" +
                                      common.name +
                                      "£*£" +
                                      common.username +
                                      "£*£" +
                                      common.profilePic;
                              break;
                            case "pk":
                              msgString =
                                  "£01PKInviteResponse01£*£Rejected£*£" +
                                      id +
                                      "£*£" +
                                      common.name +
                                      "£*£" +
                                      common.username +
                                      "£*£" +
                                      common.profilePic +
                                      "£*£" +
                                      common.broadcastUsername;
                              break;
                            default:
                              msgString =
                                  "£01GuestInviteResponse01£*£Rejected£*£" +
                                      id +
                                      "£*£" +
                                      common.name +
                                      "£*£" +
                                      common.username +
                                      "£*£" +
                                      common.profilePic;
                              break;
                          }
                          common.publishMessage(topic, msgString);
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image(
                            image: AssetImage(
                              "assets/broadcast/Close.png",
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
        )) ??
        false;
  }

  addGuest() {
    var params = {
      "action": "addGuest",
      "guest_id": userId,
      "broadcast_id": common.broadcasterId
    };
    makePostRequest("user/guest", jsonEncode(params), 0, context)
        .then((response) {
      var data = jsonDecode(response);
      print(data);
      if (data['status'] == 0) {
        setState(() {
          common.camera = true;
          common.guestFlag = true;
        });
        common.publishMessage(
            broadcastUsername,
            "£01refreshAudience01£*£" +
                userId +
                "£*£" +
                common.name +
                "£*£" +
                common.username +
                "£*£" +
                common.profilePic +
                "£*£" +
                common.level);
        common.zego.setPreview(setState, userId, common.broadcastType);
        common.zego.startPublish(userId);
        GuestData gData = GuestData(userId, common.name, common.username,
            common.profilePic, common.level, 0);
        setState(() {
          common.guestData.add(gData);
        });
      }
    });
  }

  Future<void> _connectClient() async {
    try {
      print('MQTTClientWrapper::Mosquitto client connecting....');
      common.connectionState = MqttCurrentConnectionState.CONNECTING;
      await common.client.connect("rtm", "sjh@mqtt123");
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      common.connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      common.client.disconnect();
    }

    if (common.client.connectionStatus.state == MqttConnectionState.connected) {
      common.connectionState = MqttCurrentConnectionState.CONNECTED;
      print("=========username==============");
      print(common.username);
      subscribeToTopic(common.username);
      if (common.username != broadcastUsername) {
        subscribeToTopic(broadcastUsername);
      }
      if (userType != "broad") {
        var arriveMsg = "£01AudArrive01£*£" +
            userId +
            "£*£" +
            common.name +
            "£*£" +
            common.username +
            "£*£" +
            Uri.encodeFull(common.profilePic) +
            "£*£" +
            common.level +
            "£*£" +
            common.entranceEffect;
        toggleSendChannelMessage(arriveMsg, common);
      }
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${common.client.connectionStatus}');
      common.connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      common.client.disconnect();
    }
  }

  void _setupMqttClient() {
    // buildchatzone('on connect function ' +username.toString());
    common.client = MqttClient.withPort(
        Constants.serverUri, common.username.toString(), Constants.port);
    common.client.logging(on: false);
    common.client.keepAlivePeriod = 20;
    common.client.onDisconnected = _onDisconnected;
    common.client.onConnected = _onConnected;
    common.client.onSubscribed = _onSubscribed;
  }

  void subscribeToTopic(String topicName) {
    // buildchatzone("Subscribing to the $topicName topic");
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    common.client.subscribe(topicName, MqttQos.exactlyOnce);
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    common.subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');
    if (common.client.connectionStatus.returnCode ==
        MqttConnectReturnCode.solicited) {
      print(
          'MQTTClientWrapper::OnDisconnected callback is solicited, this is correct');
    }
    common.connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    common.connectionState = MqttCurrentConnectionState.CONNECTED;
    print(
        'MQTTClientWrapper::OnConnected client callback - Client connection was sucessful');
  }

  void buildchatzone(String string, colors) {
    print('string');
    print(string);
    int txtsize = string.length;
    print(string.substring(2, 8));
    Chatmodel chatmodel = Chatmodel(string.substring(0, 2),
        string.substring(2, 8), string.substring(8, txtsize), colors);
    setState(() {
      common.chatlist.add(chatmodel);
    });
  }

  void switchToAnother(String broadid, String broadcastername) {
    common.client.unsubscribe(common.broadcastUsername);
    common.broadcasterId = broadid;
    subscribeToTopic(broadcastername);
    common.zego.playViewWidget = [];
    common.zego.playViewWidget.clear();
    common.zego.guest = [];
    common.zego.guest.clear();
    addAudience();
  }

  Widget buildInfoList(common) {
    print("chatlis" +
        common.chatlist.length.toString() +
        common.chatlist[0].txtmsg);
    Timer(Duration(milliseconds: 100), () => common.mesagecontroller
            .jumpTo(common.mesagecontroller.position.maxScrollExtent));
    return ListView.builder(
      itemCount: common.chatlist.length,
      controller: common.mesagecontroller,
      itemBuilder: (context, i) {
        Color color;
        switch (common.chatlist[i].color) {
          case "green":
            color = Colors.green;
            break;
          case "red":
            color = Colors.red;
            break;
          case "purple":
            color = Colors.purple;
            break;
          case "pink":
            color = Colors.pink;
            break;
          case "blue":
            color = Colors.blue;
            break;
          default:
            color = Colors.white;
            break;
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: common.chatlist[i].level != ""
              ? Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
            child: Row(
              children: <Widget>[
                MyCircleAvatar(
                  imgUrl: messages1[i]['contactImgUrl'],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print("object");
                        profileviewAudience(common.chatlist[i].gold, context, common);//common.chatlist[i].gold, context, common
                      },
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .6),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Color(0xfff9f9f9),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Text(
                          common.chatlist[i].txtmsg,
                          style: Theme.of(context).textTheme.body1.apply(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15),
              ],
            ),
          )
              : Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              common.chatlist[i].txtmsg,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(color: Colors.white, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  Widget audienceListView(common) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: common.scrollController,
      itemCount: common.audiencelist.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            profileviewAudience(common.audiencelist[index].userId, context, common);
          },
          child: Container(
            margin:EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              border: Border.all(
                color: Colors.transparent,
                width: 1.0,
              ),
              image: DecorationImage(
                alignment:Alignment.center,
                image: NetworkImage(
                  common.audiencelist[index].profilePic,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }

  profileviewAudience(id, context, common) {
    print("userId"+ id);
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
      /*var gender = "Female.png";
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
      print(common.relationData);*/
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Container(
                  height: 350,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 75),
                        height: double.infinity,
                        color: Colors.white,
                      ),
                      Positioned(
                          top: 90,
                          right: 22,
                          child: GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          padding: const EdgeInsets.only(left: 3),
                                          child: Icon(Icons.report, color: Colors.black)
                                      ),
                                      Text(
                                        " Report",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: (){
                              _asyncSimpleDialog(context);
                            },
                          )
                      ),
                      Positioned(
                        top: 25,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                              onTap: () {
                                print("object" + "User Id" + id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(touserid: id,),
                                  ),
                                );
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  image: DecorationImage(
                                    image: NetworkImage(data['profile_pic']),
                                    fit: BoxFit.cover,
                                  ),
                                ),

                              )
                          ),
                        ),
                      ),
                      Positioned(
                        top: 25,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(touserid: id,),
                                  ),
                                );
                              },
                              child: Container(
                                height: 105,
                                width: 105,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  image: DecorationImage(
                                    image: NetworkImage("https://blive.s3.ap-south-1.amazonaws.com/WebpageAsserts/DBeffect/Golden_Dp.webp"),
                                    fit: BoxFit.cover,
                                  ),
                                ),

                              )
                          ),
                        ),
                      ),
                      Positioned(
                        top: 130,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            data['profileName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 160,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            "ID" +
                                ' ' +
                                data['reference_user_id' ] +
                                ' ' +
                                "|" +
                                ' ' +
                                "India",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 190,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: tags.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.black)),
                                margin: const EdgeInsets.only(right: 5),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                                  child: Text(
                                    tags[index],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 230,
                        left: 0,
                        right: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text(  data['friends'],
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,)),
                                      Text("Friends",
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,)),
                                    ],
                                  ),
                                  onPressed: () {

                                  },
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text( data['fans'],
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,)),
                                      Text("Fans",
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,)),
                                    ],
                                  ),
                                  onPressed: () {

                                  },
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text(data['followers'],
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,)),
                                      Text("Followers",
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,)),
                                    ],
                                  ),
                                  onPressed: () {

                                  },
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text(data['over_all_gold'].toString(),
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,)),
                                      Text("B-Gold",
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,)),
                                    ],
                                  ),
                                  onPressed: () {

                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 280,
                        left: 0,
                        right: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white),
                              ),
                              color: Colors.white,
                              label: Text('Call',
                                style: TextStyle(color: Colors.black),),
                              icon: Icon(Icons.call, color:Colors.green,size: 18,),
                              onPressed: () {
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
                            ),
                            RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white),
                              ),
                              color: Colors.white,
                              label: Text('Chat',
                                style: TextStyle(color: Colors.black),),
                              icon: Icon(Icons.message, color:Colors.black,size: 18,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatHome(
                                    ),
                                  ),
                                );
                              },
                            ),
                            RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.deepOrange),
                              ),
                              color: Colors.deepOrange,
                              splashColor: Colors.yellow[200],
                              animationDuration: Duration(seconds: 4),
                              label: Text('Follow',
                                style: TextStyle(color: Colors.white),),
                              icon: Icon(Icons.add, color:Colors.white,size: 18,),
                              onPressed: ()  {

                              },
                            ),
                          ],
                        ),
                      ),
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

  Future<Dialog> _asyncSimpleDialog(BuildContext context) async {
    return await showDialog<Dialog>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('Block'),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('Report'),
              ),
            ],
          );
        });
  }

  Widget broadDataLeft(context, common) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10,
          left: 25,
          child: Container(
              alignment: Alignment.centerRight,
              width: 120,
              height: 50,
              padding: EdgeInsets.only(right: 10, left: 35),
              child: Column(
                children: <Widget>[
                  Text(
                    common.broadcasterProfileName,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: Colors.white, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "ID 125005",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],)
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: GestureDetector(
            onTap: () {
              print("object");
              profileviewAudience(common.broadcasterId, context, common);
            },
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(
                        common.broadprofilePic,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   top: 10,
        //   left: 150,
        //   child: Container(
        //       padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
        //       child: Column(
        //         children: [
        //           Image(
        //             image: AssetImage(
        //               "assets/images/broadcast/Star.png",
        //             ),
        //             width: 35,
        //             height: 35,
        //           ),
        //           Container(
        //             // height: 20,
        //             padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
        //             decoration: BoxDecoration(
        //               color: const Color.fromRGBO(0, 0, 0, 0.50),
        //               borderRadius: BorderRadius.all(
        //                 Radius.circular(50),
        //               ),
        //               border: Border.all(
        //                 width: 1.5,
        //                 style: BorderStyle.solid,
        //                 color: Colors.orange,
        //               ),
        //             ),
        //             child: Text(
        //               "5 X 0",
        //               style: Theme.of(context)
        //                   .textTheme
        //                   .bodyText1
        //                   .copyWith(color: Colors.white, fontSize: 10),
        //             ),
        //           )
        //         ],
        //       )),
        // ),
        Positioned(
          top: 75,
          left: 15,
          child: GestureDetector(
            child: Container(
              width: 60,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.only(left: 0),
              child: Image(
                image: AssetImage(
                  "assets/broadcast/tropy.png",
                ),
                width: 8,
                height: 8,
              ),
            ),
            onTap: (){
              onTrophyClick();
            },
          ),
        ),
        Positioned(
          top: 20,
          left: 165,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.50),
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
              border: Border.all(
                width: 1.5,
                style: BorderStyle.solid,
                color: Colors.orange,
              ),
            ),
            child: Row(
              children: <Widget>[
                Image(
                  image: AssetImage(
                    "assets/broadcast/Coin.png",
                  ),
                  width: 10,
                  height: 10,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  common.gold.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(color: Colors.orange, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _profileview() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            SvgPicture.asset(pk,
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                        onPressed: () {
                          toast("under Development!", Colors.black);
                        },
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            SvgPicture.asset(gallery,
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                        onPressed: () {
                          toast("under Development!", Colors.black);
                        },
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            SvgPicture.asset(music,
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyMusic(
                              ),
                            ),
                          );
                        },
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            SvgPicture.asset(games,
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                        onPressed: () {
                          toast("under Development!", Colors.black);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _share(){
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Image(
                          width: 40.0,
                          height: 40.0,
                          image: AssetImage(
                            'assets/login/Facebook.png',
                          ),
                        ),
                        onPressed: () async {
                          File file = await ImagePicker.pickImage(source: ImageSource.gallery);
                          await SocialSharePlugin.shareToFeedFacebook(
                              path: file.path,
                              onSuccess: (_) {
                                print('FACEBOOK SUCCESS');
                                return;
                              },
                              onCancel: () {
                                print('FACEBOOK CANCELLED');
                                return;
                              },
                              onError: (error) {
                                print('FACEBOOK ERROR $error');
                                return;
                              });
                        },
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Image(
                          width: 40.0,
                          height: 40.0,
                          image: AssetImage(
                            'assets/login/Twitter.png',
                          ),
                        ),
                        onPressed: () async {
                          String url = 'https://flutter.dev/';
                          final text =
                              'Flutter is Google’s portable UI toolkit for building beautiful, natively-compiled applications for mobile, web, and desktop from a single codebase.';
                          final result = await SocialSharePlugin.shareToTwitterLink(
                              text: text,
                              url: url,
                              onSuccess: (_) {
                                print('TWITTER SUCCESS');
                                return;
                              },
                              onCancel: () {
                                print('TWITTER CANCELLED');
                                return;
                              });
                          print(result);
                        },
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Image(
                          width: 40.0,
                          height: 40.0,
                          image: AssetImage(
                            'assets/login/Facebook.png',
                          ),
                        ),
                        onPressed: () async {
                          String url = 'https://flutter.dev/';
                          final quote =
                              'Flutter is Google’s portable UI toolkit for building beautiful, natively-compiled applications for mobile, web, and desktop from a single codebase.';
                          final result = await SocialSharePlugin.shareToFeedFacebookLink(
                            quote: quote,
                            url: url,
                            onSuccess: (_) {
                              print('FACEBOOK SUCCESS');
                              return;
                            },
                            onCancel: () {
                              print('FACEBOOK CANCELLED');
                              return;
                            },
                            onError: (error) {
                              print('FACEBOOK ERROR $error');
                              return;
                            },
                          );

                          print(result);
                        },
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Image(
                          width: 40.0,
                          height: 40.0,
                          image: AssetImage(
                            'assets/login/Insta.png',
                          ),
                        ),
                        onPressed: () async {
                          File file = await ImagePicker.pickImage(source: ImageSource.gallery);
                          await SocialSharePlugin.shareToFeedInstagram(path: file.path);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void chatEnable(context, setState, common) {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      color: Colors.deepOrange,
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
                                "assets/broadcast/BulletMessage.png"),
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
                            image: AssetImage("assets/broadcast/Send.png"),
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

  onTrophyClick(){
    final popup = BeautifulPopup(
      context: context,
      template: TemplateGreenRocket,
    );
    popup.show(
      title: 'Dummy Text',
      content: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. '
          'Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus '
          'et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, '
          'ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.',
      actions: [
       /* popup.button(
          label: 'Close',
          onPressed: Navigator.of(context).pop,
        ),*/
      ],
    );
  }

}
