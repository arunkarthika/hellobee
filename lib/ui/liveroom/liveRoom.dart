import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/music/main_1.dart';
import 'package:honeybee/ui/liveroom/constants.dart' as Constants;
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/constant/models.dart';
import 'package:honeybee/model/AudienceList.dart';
import 'package:honeybee/model/Chatmodel.dart';
import 'package:honeybee/model/Queue.dart';
import 'package:flutter/material.dart';
import 'package:honeybee/ui/liveroom/personalChat/chat.dart';
import 'package:honeybee/ui/liveroom/profileUi.dart';
import 'package:honeybee/ui/meprofile.dart';
import 'package:honeybee/ui/search_page.dart';
import 'package:honeybee/utils/global.dart';
import 'package:honeybee/widget/mycircleavatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:wakelock/wakelock.dart';
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

  RenderBroadcast createState() =>
      RenderBroadcast(
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

  @override
  void initState() {
    common.connectionState = MqttCurrentConnectionState.DISCONNECTED;
    WidgetsBinding.instance.addObserver(this);
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
    common.audienceController = TabController(length: 2, vsync: this);
    common.audienceContributerController =
        TabController(length: 2, vsync: this);
    common.contributerController = TabController(length: 2, vsync: this);
    Timer(Duration(milliseconds: 500), () {
      ZegoUser user = ZegoUser(userId, common.username);
      ZegoExpressEngine.instance.loginRoom(broadcastUsername, user);
      common.zego.setCallback(setState);
      common.zego.width = MediaQuery
          .of(context)
          .size
          .width
          .ceil()
          .toInt();
      common.zego.height = (MediaQuery
          .of(context)
          .size
          .height
          .ceil()
          .toInt());
      if (userType == 'broad') {
        common.zego.broadOffline = false;
        common.broadcastType = broadcastType;
        common.zego.playViewWidget = [];
        common.zego.setPreview(
            setState, common.broadcasterId.toString(), common.broadcastType);
        common.zego.startPublish(common.broadcasterId.toString());
        getAudience();
        var endPoint = 'user/goLive';
        var params = {
          'action': 'live',
          'broadcast_type': broadcastType,
        };
        makePostRequest(endPoint, jsonEncode(params), 0, context)
            .then((response) {
          common.broadcastType = broadcastType;
          prepareMqttClient();
          Timer(Duration(milliseconds: 500), () {
            onMessage();
          });
          setState(() {
            common.gift = false;
            common.loader = false;
            common.guestFlag = true;
          });
        });
      } else {
        addAudience();
      }
    });
    warningMsg();
    giftControllerFun();
    common.scrollControllerforbottom.addListener(() {
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

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state.toString() == 'AppLifecycleState.paused') {
      common.currentPassTime = DateTime.now();
      if (common.userId == common.broadcasterId ||
          common.guestData.indexWhere((item) => item.userId == common.userId) !=
              -1) {
        common.zego.isUseMic = true;
        onMicMute(common, setState);
      }
    }
    if (state.toString() == 'AppLifecycleState.resumed') {
      common.idelTime += dateTimeDiff(common.currentPassTime);
      if (common.userId == common.broadcasterId ||
          common.guestData.indexWhere((item) => item.userId == common.userId) !=
              -1) {
        common.zego.isUseMic = false;
        onMicMute(common, setState);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    common.menu.dismiss();
    print('inside dispose');
    common.player.stop();
    if (userType == 'broad') {
      common.publishMessage(
          common.broadcastUsername, '£01BroadENded01£*£' + common.userId);
      ZegoExpressEngine.instance.stopPublishingStream();
    } else {
      onWillPopOffline();
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
    common.c = 0;
    common.scrollController.dispose();
    common.chatController.dispose();
    common.giftController.dispose();
    common.animationController.dispose();
    common.normalleft1controller.dispose();
    common.normalleft2controller.dispose();
    common.mesagecontroller.dispose();
    common.bullet1controller.dispose();
    common.bullet2controller.dispose();
    common.bullet3controller.dispose();
    common.arrivedMessageController.dispose();
    common.menuController.dispose();
    common.audioScrollcontroller.dispose();
    common.audienceController.dispose();
    common.audienceContributerController.dispose();
    common.contributerController.dispose();
    common.dayscrollController.dispose();
    common.fullscrollController.dispose();
    common.invitTimeController.dispose();
    common.timerController.dispose();
    common.menu.dismiss();
    WidgetsBinding.instance.removeObserver(this);
    Navigator.of(context).pop(false);

    Timer(Duration(milliseconds: 1200), () {
      if (common.connectionState == MqttCurrentConnectionState.CONNECTED) {
        common.client.disconnect();
      }
      super.dispose();
    });
  }

  disposePlay(streamID) {
    print(common.zego.previewID[streamID]);
    int stream = common.zego.previewID[streamID];
    ZegoExpressEngine.instance.destroyTextureRenderer(stream);
    ZegoExpressEngine.instance.stopPlayingStream(streamID.toString());
  }

  @override
  Widget build(BuildContext context) {
    common.closeContext = context;
    PopupMenu.context = context;
    common.widthScreen = MediaQuery
        .of(context)
        .size
        .width;
    return GestureDetector(
      onDoubleTap: () {},
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
                    : <Widget>[body(), header(), footer()],
              ),
            ),
            onSwipeUp: () {
              print("up");
              switchToAnother(common.prevUserId, common.prevUsername);
            },
            onSwipeDown: () {
              switchToAnother(common.nextUserId, common.nextUsername);
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
          top: MediaQuery
              .of(context)
              .size
              .height / 1.7,
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
            child: SizedBox(
              width: 30,
              height: 30, // specific value

              child: RaisedButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: common.gradient(Icons.menu)),
            )),
        Positioned(
          bottom: 10.0,
          left: 130.0,
          child: common.userTypeGlob == 'broad' || common.guestFlag == true
              ? SizedBox(
            width: 30,
            height: 30, // specific value

            child: RaisedButton(
                onPressed: () {
                  onMicMute(common, setState);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: common.gradient(
                  common.zego.isUseMic ? Icons.mic : Icons.mic_off,
                )),
          )
              : Container(),
        ),
        Positioned(
            bottom: 10.0,
            left: 50.0,
            child: SizedBox(
              width: 30,
              height: 30, // specific value

              child: RaisedButton(
                  onPressed: () {
                    chatEnable(context, setState, common);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: common.gradient(Icons.chat_bubble)),
            )),
        Positioned(
            bottom: 10.0,
            left: 90.0,
            child: SizedBox(
              width: 30,
              height: 30, // specific value

              child: RaisedButton(
                  onPressed: () {
                    _share();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: common.gradient(Icons.share)),
            )),
        Positioned(
          bottom: 5,
          right: 0,
          child: audienceBroadShow(context, common, setState),
        ),
      ],
    );
  }

  Future<bool> onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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
    print('offline');
    if (common.guestFlag == true) {
      common.removeGuest(common.userId, context);
    }
    common.removeAudience(context, common);
    Navigator.of(context).pop();

    return false;
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

            Person person = Person(
                v["profileName"],
                v["user_id"],
                v["level"],
                v['userRelation'],
                v['profile_pic'],
                name,
                icon);
            common.filteredList.add(person);
          }
        }
      });
    });
  }

  getAudienceold() async {
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
        GuestData gData = GuestData(
            k,
            v["profileName"],
            v["username"],
            v["profile_pic"],
            v["level"],
            0,
            0);
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

  dynamic getAudience() {
    setState(() {
      common.loaderInside = true;
    });
    var endPoint = 'user/List';
    var params = 'page=' +
        common.page.toString() +
        '&length=10&action=audience&user_id=' +
        broadcasterId.toString();
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var pic = json.decode(response);
      if (common.page <= common.pageLength) {
        for (var list in pic['body']['audience']['viewers_list']) {
          print(list);
          var audList = AudienceList(list['user_id'], list['profileName'],
              list['username'], list['profile_pic']);
          common.audiencelist.insert(0, audList);
        }
        common.pageLength = pic['body']['audience']['last_page'];
      }
      common.videoMute = pic['body']['audience']['video_muted'];
      common.broadcastType = 'audio';

      common.viewerCount = pic['body']['audience']['audience_count'].toString();
      if (pic['body']['audience']['textMuteList'] == null) {
        pic['body']['audience']['textMuteList'] = [];
      }
      if (pic['body']['audience']['textMuteList'].contains(common.userId)) {
        common.textMute = true;
      }
      common.guestList = pic['body']['audience']['guestList'];
      int gold = pic['body']['audience']['goldRecive'];
      common.starOriginalValue = gold;
      common.starUpdate(gold, setState);
      common.guestList ??= {};
      common.guestList.forEach((k, v) {
        var temp = common.guestData.indexWhere((item) => item.userId == k);
        if (temp == -1) {
          var gData = GuestData(
              k,
              v['profileName'],
              v['username'],
              v['profile_pic'],
              v['level'],
              0,
              v['video_muted']);
          common.guestData.add(gData);
          common.zego.playRemoteStream(k, setState, common.broadcastType);
        } else {
          common.guestData.forEach((item) {
            if (item.userId == v['user_id']) {
              item.videoMute = v['video_muted'];
            }
          });
        }
      });
      setState(() {
        common.loaderInside = false;
        common.guestData = common.guestData;
      });
    });
    print('============== ===============outside===================');
  }

  dateTimeDiff(time) {
    DateTime now = DateTime.now();
    var diff = now
        .difference(time)
        .inSeconds;
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
        userType == "broad"
            ? Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BroadcastEnd(
                    broadcastTime: actualBroadcastingTime.toString(),
                    viewvers: common.audiencelist.length.toString(),
                    like: common.like.toString(),
                    gold: common.bgold.toString(),
                    userId: broadcasterId),
          ),
        )
            : Navigator.of(context).pop();
      });
    }
  }

  addAudienceold() async {
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
          GuestData gData = GuestData(
              k,
              v["profileName"],
              v["username"],
              v["profile_pic"],
              v["level"],
              0,
              0);
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

  dynamic addAudience() {
    setState(() {
      common.loaderInside = true;
    });
    var endPoint = 'user/audiance';
    var params = {
      'action': 'addAudience',
      'length': '10',
      'page': common.page.toString(),
      'user_id': common.broadcasterId
    };
    // ignore: missing_return
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      var temp = pic['body'];
      if (pic['body']['broadCastList']['kickOutList'].contains(common.userId) ||
          pic['body']['broadCastList']['blockList'].contains(common.userId)) {
        Fluttertoast.showToast(msg: "You are not allowed to enter into this room");
        onWillPopOffline();
        return false;
      }
      print("connect" + common.connectionState.toString());
      if (common.connectionState != MqttCurrentConnectionState.CONNECTED) {
        prepareMqttClient();
      }
      print(common.connectionState);
      Timer(Duration(milliseconds: 500), () {
        print(common.connectionState);
        if (common.c == 0) {
          onMessage();
        }
        print(common.connectionState);
        setState(() {
          common.prevUserId = pic['body']['prevUserId'].toString();
          common.nextUserId = pic['body']['nextUserId'].toString();
          common.prevUserId = common.prevUserId == null ||
              common.prevUserId == '' ||
              common.prevUserId == 'false'
              ? ''
              : common.prevUserId;
          common.nextUserId = common.nextUserId == null ||
              common.nextUserId == '' ||
              common.nextUserId == 'false'
              ? ''
              : common.nextUserId;
          common.prevUsername = pic['body']['prevUser'] == null ||
              pic['body']['prevUser'] == '' ||
              pic['body']['prevUser'] == false
              ? ''
              : pic['body']['prevUser'];
          common.nextUsername = pic['body']['nextUser'] == null ||
              pic['body']['nextUser'] == '' ||
              pic['body']['nextUser'] == false
              ? ''
              : pic['body']['nextUser'];
          if (pic['body']['broadCastList']['status'] == 'INACTIVE') {
            common.zego.broadOffline = true;
          }
          if (common.page <= common.pageLength) {
            var broad = temp['broadCastList'];
            for (var list in temp['viewers_list']) {
              var audList = AudienceList(list['user_id'], list['profileName'],
                  list['username'], list['profile_pic']);
              common.audiencelist.insert(0, audList);
            }
            temp['textMuteList'] = temp['textMuteList'] ?? [];
            if (temp['textMuteList']
                .indexWhere((item) => item == common.userId) !=
                -1) {
              common.textMute = true;
            }
            common.broadcasterProfileName = broad['profileName'];
            common.broadcastType = broad['broadcast_type'];
            common.gold = int.tryParse(broad['over_all_gold']);
            common.broadprofilePic = broad['profile_pic'];
            common.giftUserId = broad['user_id'].toString();
            common.giftUsername = broad['username'];
            common.broadcastUsername = broad['username'];
            common.broadcasterId = broad['user_id'];
            common.pageLength = temp['last_page'];
            common.videoMute = temp['video_muted'];
            common.guestList = temp['guestList'];
          }
          common.viewerCount = temp['audience_count'].toString();
          common.guestList ??= {};
          common.zego.playViewWidget = [];
          common.zego.playRemoteStream(
              common.broadcasterId, setState, common.broadcastType);
          common.guestData = [];
          common.guestList.forEach((k, v) {
            var gData = GuestData(
                k,
                v['profileName'],
                v['username'],
                v['profile_pic'],
                v['level'],
                0,
                v['video_muted']);
            common.guestData.add(gData);
            common.zego.playRemoteStream(k, setState, common.broadcastType);
          });
          if (common.broadcastType == 'pk') {
            common.client
                .subscribe(common.guestData[0].username, MqttQos.exactlyOnce);
          }
          common.userrelation = temp['userRelation'];
          common.guestData = common.guestData;

          int gold = pic['body']['goldRecive'];
          common.starOriginalValue = gold;
          common.starUpdate(gold, setState);
          common.gift = true;
          common.camera = false;
          common.loader = false;
          common.guestFlag = false;
          common.loaderInside = false;
          var arriveMsg = '£01getGuestData01£*£' +
              common.userId +
              '£*£' +
              common.name +
              '£*£' +
              common.username +
              '£*£' +
              Uri.encodeFull(common.profilePic) +
              '£*£' +
              common.level +
              '£*£' +
              common.entranceEffect;
          common.publishMessage(common.broadcastUsername, arriveMsg);
        });
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
    common.c++;
    // ignore: missing_return
    common.client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      MqttPublishMessage recMess = c[0].payload;
      var receivedTopic = c[0].topic;
      var locationJson =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      var tmpmsg = locationJson;
      var arrData = tmpmsg.split('£*£');
      print('################################');
      print(tmpmsg);
      print(arrData);
      switch (arrData[0]) {
        case '£01AudArrive01':
          if (!tmpmsg.contains(userId)) {
            var audList =
            AudienceList(arrData[1], arrData[2], arrData[3], arrData[4]);
            common.audiencelist.insert(0, audList);
            var giftqueue = Arrivedqueue(arrData[2], arrData[6]);
            common.arrivedqueuelist.add(giftqueue);
            loadArrived(setState, common);
            var arrived = arrData[5] + arrData[1] + arrData[2] + ' has arrived';
            buildchatzone(arrived, 'blue', receivedTopic);
          }
          break;
        case '£01getGuestData01':
          print(common.userTypeGlob +
              ' globtype ' +
              common.username +
              '==' +
              receivedTopic +
              ' broad type ' +
              common.broadcastType +
              ' printed from ' +
              common.userId);
          if (common.broadcastType != 'solo' &&
              common.username == receivedTopic) {
            var arriveMsg = '£01GuestDataUpdate01£*£' +
                arrData[1] +
                '£*£' +
                jsonEncode(common.guestData.map((i) => i.toJson()).toList())
                    .toString() +
                '£*£' +
                common.pkBroadId +
                '£*£' +
                common.pkBroadUsername +
                '£*£' +
                common.pkgold.toString() +
                '£*£' +
                common.pkRemainingTime.toString();
            common.publishMessage(common.broadcastUsername, arriveMsg);
          }
          break;
        case '£01GuestDataUpdate01':
          if (arrData[1] == common.userId) {
            common.pkBroadId = arrData[3];
            common.pkBroadUsername = arrData[4];
            common.pkgold = int.parse(arrData[5].toString());
            print('common.broadcastType');
            print(common.broadcastType);
            if (arrData[6] != '0' && common.broadcastType == 'pk') {
              // var time = DateTime.parse(arrData[6]).second;
              common.timerController.stop();
              common.timerController = AnimationController(
                  vsync: this,
                  duration: Duration(seconds: int.parse(arrData[6])));
              print(common.timerController.duration);
              common.timerDuration = int.parse(arrData[6]);
              common.timerController.reset();
              common.timerController.forward();
            }
            var jsonData = jsonDecode(arrData[2]);
            for (var gdata in jsonData) {
              common.guestData.forEach((item) {
                if (item.userId == gdata['userId']) {
                  item.points = gdata['points'];
                }
              });
            }
          }
          break;
        case '£01pkChallenge01':
          switch (arrData[1]) {
            case 'Start':
              if (common.username == receivedTopic) {}
              break;
            case 'Accepted':
              if (common.username == receivedTopic) {
                var guestId = common.userId;
                if (common.pkBroadId == common.userId) {
                  guestId = common.guestData[0].userId;
                }
                var duration = int.parse(arrData[6].toString()) * 60;
              }
              break;
            case 'Rejected':
              if (common.username == receivedTopic &&
                  arrData[2] == common.userId) {
                Fluttertoast.showToast(msg: "Guest rejected your PK time request");
              }
              break;
            case 'StartTimer':
              common.pkgold = 0;
              common.guestData[0].points = 0;
              common.timerController.stop();
              var duration = int.tryParse(arrData[2]);
              print('@@@@@@@@@@@@@@@@ common.timerDuration@@@@@@@@@@@@@@');
              print(common.timerDuration);
              common.timerDuration = duration;
              common.pkRemainingTime = duration;
              print('@@@@@@@@@@@@@@@@ common.timerDuration@@@@@@@@@@@@@@');
              print(common.timerDuration);
              print('1common.timerController.duration');
              print(common.timerController.duration);
              common.timerController = AnimationController(
                  vsync: this, duration: Duration(seconds: duration));
              print('2common.timerController.duration');
              print(common.timerController.duration);
              common.timerController.reset();
              print('2common.timerController.duration');
              print(common.timerController.duration);
              common.timerController.forward()
                ..whenComplete(() {
                  if (common.userId == common.pkBroadId) {}
                });
              break;
            case 'End':
              common.showEmoji = true;
              common.pkGuest = false;
              common.pkHost = false;
              if (arrData[2] == 'draw') {
                common.pkGuest = true;
                common.pkHost = true;
              } else {
                if (common.broadcasterId == arrData[3]) {
                  common.pkHost = true;
                } else if (common.guestData[0].userId == arrData[3]) {
                  common.pkGuest = true;
                }
              }
              Timer(Duration(milliseconds: 10000), () {
                common.timerDuration = 0;
                common.pkRemainingTime = 0;
                common.pkgold = 0;
                common.guestData[0].points = 0;
                common.showEmoji = false;
                setState(() {});
              });
              break;
            default:
          }
          break;
        case '£01RemoveAud01':
          print('removeuserid' + userId);
          print(tmpmsg);
          if (!tmpmsg.contains(userId)) {
            print('removeuseridignite' + userId);
            common.audiencelist
                .removeWhere((item) => item.userId == arrData[1]);
            var arrived = arrData[5] + arrData[1] + arrData[2] + ' has Left';
            buildchatzone(arrived, 'pinkAccent', receivedTopic);
          }
          break;
        case '£01kickout01':
          if (arrData[1] == common.userId) {
            Fluttertoast.showToast(msg: "Host Kicked You Out");
            onWillPopOffline();
          }
          break;
        case '£01TextStatus01':
          if (arrData[1] == common.userId) {
            if (arrData[2] == 'textMute') {
              common.textMute = true;
            } else {
              common.textMute = false;
            }
          }
          break;
        case '£01GuestInvite01':
          buildchatzone(
              arrData[6] +
                  arrData[1] +
                  arrData[3] +
                  '  has requested to join the call',
              'yellow',
              receivedTopic);

          if (receivedTopic == common.username) {
            var content = arrData[3] + '  Has Sent You Request';
            if (userType == 'broad') {
              if (common.inviteRequest
                  .indexWhere((item) => item.userId == arrData[1])
                  .toString() ==
                  '-1' &&
                  common.guestData
                      .indexWhere((item) => item.userId == arrData[1])
                      .toString() ==
                      '-1') {
                var queue = InviteRequest(
                    arrData[3], arrData[5], arrData[6], arrData[1], arrData[4]);
                setState(() {
                  common.inviteRequest.add(queue);
                });
              }
            } else {
              _invitationPopUp(
                  content, arrData[1], 'guest', common.broadcastUsername);
            }
          }
          break;
        case '£01sendGift01':
          var giftTempvalue =
              int.tryParse(arrData[7]) * int.tryParse(arrData[8]);
          if (common.broadcastUsername == receivedTopic) {
            if (common.userTypeGlob == 'broad') {
              common.bgold += giftTempvalue;
              common.level = arrData[10];
              CommonFun().saveShare('level', common.level);
            }
            common.pkgold += giftTempvalue;
            common.gold += giftTempvalue;
            common.starOriginalValue += giftTempvalue;
            common.starUpdate(common.starOriginalValue, setState);
          }

          if (common.broadcastType != 'solo') {
            common.guestData.forEach((item) {
              if (item.userId == arrData[9]) {
                item.points += giftTempvalue;
              }
            });
          }
          var arrived =
              arrData[4] + arrData[1] + arrData[2] + ' has sent ' + arrData[3];
          if (arrData[5] == 'normal') {
            var giftqueue =
            NormalGiftqueue(arrData[2], arrData[3], arrData[6], arrData[7]);
            common.normalgiftqueuelist.add(giftqueue);
            loadNormal(setState, common);
            if (int.tryParse(arrData[7]) != 1) {
              arrived = arrData[4] +
                  arrData[1] +
                  arrData[2] +
                  ' has sent ' +
                  arrData[3] +
                  ' X' +
                  arrData[7];
            }
          } else {
            var giftqueue = Giftqueue(arrData[3]);
            common.giftqueuelist.add(giftqueue);
            loadAnimation(setState, common);
          }
          buildchatzone(arrived, 'yellow', receivedTopic);

          break;
        case '£01GuestInviteResponse01':
          if (arrData[1] == 'Accepted') {
            if (userId == arrData[2]) {
              addGuest();
            }
          }
          break;
        case '£01relationStatus01':
          Chatmodel chatmodel;
          if (arrData[1] == 'unfollow') {
            chatmodel = Chatmodel(
                '',
                '',
                arrData[3] + ' has ' + arrData[1] + 'ed the anchor.',
                'grey',
                receivedTopic);
          } else {
            chatmodel = Chatmodel(
                '',
                '',
                arrData[3] + ' has ' + arrData[1] + 'ed the anchor.',
                'green',
                receivedTopic);
          }
          common.chatList.add(chatmodel);

          break;
        case '£01PK!nvIte01':
          if (receivedTopic == common.username) {
            var content = arrData[7] + '  Has Sent PK Request';
            if (userId == arrData[1] && common.pkSession == false) {
              _invitationPopUp(content, arrData[1], 'pk', arrData[6]);
            }
          }
          break;
        case '£01PKInviteResponse01':
          if (receivedTopic == common.username) {
            if (arrData[1] == 'Accepted' && common.pkSession == false) {
              var pkGuest = {
                'userId': arrData[2],
                'idleTime': arrData[6],
                'actualTime': arrData[7],
                'totalTime': arrData[8],
                'username': arrData[4]
              };

              var broadcastingTime = dateTimeDiff(common.currentTime);
              var actualBroadcastingTime = broadcastingTime - common.idelTime;

              var pkBroad = {
                'userId': common.userId,
                'idleTime': common.idelTime,
                'actualTime': actualBroadcastingTime,
                'totalTime': broadcastingTime,
                'username': common.username
              };
              Fluttertoast.showToast(msg: "PK request Accepted");
            } else {
              Fluttertoast.showToast(msg: "PK request rejected");
            }
          } else if (receivedTopic == common.username) {
            common.publishMessage(arrData[4],
                '£01T0aSt01£*£${common.userId}£*£${common
                    .name} is already in PK');
          }
          break;
        case '£01pkSession01':
          common.timerDuration = 0;
          common.pkRemainingTime = 0;
          common.pkgold = 0;
          if (receivedTopic == common.broadcastUsername) {
            if (arrData[1] == 'Start') {
              common.pkSessionId = arrData[3];
              common.client.subscribe(arrData[2], MqttQos.exactlyOnce);
              common.pkBroadId = arrData[4];
              common.pkBroadUsername = arrData[5];
              print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
              print('subscribed to new topic ' + arrData[5]);
            } else {
              disposePlay(common.guestData[0].userId);
              print(
                  '@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ${common.zego.playViewWidget
                      .length}');
              common.client.unsubscribe(arrData[2]);
              common.guestData = [];
              common.zego.playViewWidget.removeAt(1);
              print(
                  '@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ${common.zego.playViewWidget
                      .length}');
              if (common.userTypeGlob == 'broad') {
                common.pkSession = false;
              }
            }
            getAudience();
            print('===============inside==========');
          }
          break;
        case '£01T0aSt01':
          if (receivedTopic == common.username) {
            Fluttertoast.showToast(msg: arrData[2]);
          }
          break;
        case '£01RemoveGus01':
          setState(() {
            common.guestData.removeWhere((item) => item.userId == arrData[1]);
            if (arrData[1] != common.userId) {
              disposePlay(arrData[1]);
            } else if (arrData[1] == common.userId) {
              common.camera = false;
              common.guestFlag = false;
              ZegoExpressEngine.instance.stopPublishingStream();
              ZegoExpressEngine.instance.stopPreview();
            }
          });
          break;
        case '£01bullet01':
          var giftqueue = Bulletqueue(arrData[1], arrData[5], arrData[3]);
          common.bulletqueuelist.add(giftqueue);
          loadBullet(common);
          break;
        case '£01refreshAudience01':
          common.page = 1;
          common.audiencelist = [];
          getAudience();
          break;
        case '£01BroadENded01':
          if (common.closeContext != null) {
            Navigator.of(common.closeContext).pop(false);
          }
          if (receivedTopic == common.broadcastUsername &&
              common.userTypeGlob != 'broad') {
            clearGiftList();
            common.zego.broadOffline = true;
          }
          break;
        default:
          print("CHATRECEIEVE" + tmpmsg);
          if (!tmpmsg.contains('£*£')) {
            buildchatzone(tmpmsg, 'white', receivedTopic);
          }
          break;
      }
      if (arrData[0] == '£01BroadENded01' &&
          receivedTopic == common.broadcastUsername &&
          common.userTypeGlob == 'broad') {
        return false;
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
      builder: (context) =>
          AlertDialog(
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
                        style: Theme
                            .of(context)
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
                              "assets/broadcast/chair.png",
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

  dynamic addGuest() {
    setState(() {
      common.loaderInside = true;
    });
    var params = {
      'action': 'addGuest',
      'guest_id': common.userId,
      'broadcast_id': common.broadcasterId
    };
    makePostRequest('user/guest', jsonEncode(params), 0, context)
        .then((response) {
      var data = jsonDecode(response);
      if (data['status'] == 0) {
        common.guestFlag = true;
        common.loaderInside = false;
        common.publishMessage(
            broadcastUsername,
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
        common.zego.startPublish(userId);
        var gData = GuestData(
            userId,
            common.name,
            common.username,
            common.profilePic,
            common.level,
            0,
            0);
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
      print("connecttothemqtt" +
          "------" +
          common.username +
          "-------" +
          broadcastUsername +
          "-----" +
          userType);
      if (userType != "broad") {
        subscribeToTopic(broadcastUsername);
        audienceArrive();
      } else {
        subscribeToTopic(common.username);
      }
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${common
              .client.connectionStatus}');
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

  void buildchatzone(String string, colors, String topic) {
    print('string');
    print(string);
    int txtsize = string.length;
    print(string.substring(2, 8));
    Chatmodel chatmodel = Chatmodel(string.substring(0, 2),
        string.substring(2, 8), string.substring(8, txtsize), colors, "");
    setState(() {
      common.chatList.add(chatmodel);
    });
  }

  void audienceArrive() {
    var arriveMsg = '£01AudArrive01£*£' +
        common.userId +
        '£*£' +
        common.name +
        '£*£' +
        common.username +
        '£*£' +
        Uri.encodeFull(common.profilePic) +
        '£*£' +
        common.level +
        '£*£' +
        common.entranceEffect;
    common.publishMessage(common.broadcastUsername, arriveMsg);
  }

  void warningMsg() {
    var chatmodel = Chatmodel(
        '',
        '',
        'Warning : We moderate Live Broadcast. Smoking, Vulgarity, Porn, Indecent exposure, child pornographu and abuse or Any copyright infringement is NOT allowed and will be banned. Live broadcasts are monitored 24X7 . Hack or mis-uses subject to account closure,suspension , or permanent Ban  ',
        'grey',
        "");
    common.chatList.add(chatmodel);
  }

  void switchToAnother(broadid, broadcastername) {
    try {
      if (common.guestFlag == false &&
          broadid != '' &&
          broadid != common.broadcasterId &&
          broadid != null &&
          broadcastername != null &&
          broadcastername != '') {
        setState(() {
          common.client.unsubscribe(common.broadcastUsername);

          common.removeAudience(context, common);
          common.player.stop();
          common.loader = true;
          Timer(Duration(milliseconds: 1000), () {
            subscribeToTopic(broadcastername);
            for (final streamID in common.zego.previewID.keys) {
              disposePlay(streamID);
            }
            ZegoExpressEngine.instance.stopPlayingStream(common.broadcasterId);
            common.zego.playViewWidget = [];
            clearGiftList();
            stopAnimation();

            common.broadcasterId = broadid;
            common.broadcastUsername = broadcastername;
            common.page = 1;
            common.audiencelist = [];
            addAudience();
            audienceArrive();

            warningMsg();
          });
        });
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Widget buildInfoList(common) {
    print("chatlis" +
        common.chatList.length.toString() +
        common.chatList[0].txtmsg);
    Timer(
        Duration(milliseconds: 100),
            () =>
            common.mesagecontroller
                .jumpTo(common.mesagecontroller.position.maxScrollExtent));
    return ListView.builder(
      itemCount: common.chatList.length,
      controller: common.mesagecontroller,
      itemBuilder: (context, i) {
        Color color;
        switch (common.chatList[i].color) {
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
          child: common.chatList[i].level != ""
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
                        profileviewAudience(
                            common.chatList[i].gold,
                            context,
                            common); //common.chatList[i].gold, context, common
                      },
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery
                                .of(context)
                                .size
                                .width * .6),
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
                          common.chatList[i].txtmsg,
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1
                              .apply(
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
              common.chatList[i].txtmsg,
              style: Theme
                  .of(context)
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
            onTap: () {
              profileviewAudience(
                  common.audiencelist[index].userId, context, common);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [Colors.redAccent, Colors.orange[300]],
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
                  imgUrl:
                  'https://i.pinimg.com/736x/0b/a9/63/0ba963472e12aefd5b6e903f673405c4.jpg',
                ),
              ),
            ));
      },
    );
  }

  profileviewAudience(id, context, common) {
    print("userId" + id);
    var params = "";
    var genderhide;
    var idhide;
    if (id == common.userId)
      params = "action=quickProfile";
    else
      params = "action=quickProfile&user_id=" + id.toString();
    print(params);
    makeGetRequest("user", params, 0, context).then((response) {
      var res = jsonDecode(response);
      print("quickProfile" + res.toString());
      var data = res['body'];
      var gender = 'Female.png';
      genderhide = int.tryParse(data['is_the_gender_hide'].toString());
      idhide = int.tryParse(data['is_the_user_id_hidden'].toString());
      if (data['gender'] == 'male') gender = 'male.jpg';
      common.userrelation = data['userRelation'];
      common.userrelation ??= 0;
      common.relationData = 'Follow';
      common.relationImage = Icons.add;
      if (common.userrelation == 1) {
        common.relationData = 'Unfollow';
        common.relationImage = Icons.remove;
      } else if (common.userrelation == 3) {
        common.relationImage = Icons.swap_horiz;
        common.relationData = 'Friend';
      }
      common.blockInt = data['block'];
      common.blockIcon = Icons.block;
      common.blockStatus = 'Block';
      if (common.blockInt == 1) {
        common.blockIcon = Icons.radio_button_unchecked;
        common.blockStatus = 'Unblock';
      }
      common.textStatus = 'Text Mute';
      common.textIcon = Icons.speaker_notes;
      common.textInt = data['text'];
      if (common.textInt == 1) {
        common.textStatus = 'Text Unmute';
        common.textIcon = Icons.speaker_notes_off;
      }
      setState(() {
        common.loaderInside = false;
      });
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
                                          padding:
                                          const EdgeInsets.only(left: 3),
                                          child: Icon(Icons.report,
                                              color: Colors.black)),
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
                            onTap: () {
                              Navigator.pop(context);
                              _asyncSimpleDialog(id, common, context);
                            },
                          )),
                      Positioned(
                          top: 90,
                          left: 22,
                          child: common.userTypeGlob == 'broad'
                              ? Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Icon(
                                    common.blockIcon,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                    child: Text(
                                      " " + common.blockStatus,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      userBlockRelation(common.blockInt,
                                          id, common, setState, context);
                                    }),
                              ],
                            ),
                          )
                              : Container()),
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
                                    builder: (context) =>
                                        MeProfile(
                                          touserid: id,
                                        ),
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
                              )),
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
                                    builder: (context) =>
                                        MeProfile(
                                          touserid: id,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 105,
                                width: 105,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://blive.s3.ap-south-1.amazonaws.com/WebpageAsserts/DBeffect/Golden_Dp.webp"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
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
                                data['reference_user_id'] +
                                ' ' +
                                "|" +
                                ' ' +
                                data['country'],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                OutlineButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text("↑Level " + data['level'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                ),
                                OutlineButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text("💎 " + data["diamond"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                ),
                                OutlineButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text("♀ " + data["gender"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                ),
                              ],
                            ),
                          ],
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
                                      Text(data['friends'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text("Friends",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text(data['fans'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text("Fans",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text(data['followers'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text("Followers",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text(data['over_all_gold'].toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text("B-Gold",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
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
                            common.userTypeGlob == 'broad'
                                ? RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white),
                              ),
                              color: Colors.white,
                              label: Text(
                                'Call',
                                style: TextStyle(color: Colors.black),
                              ),
                              icon: Icon(
                                Icons.call,
                                color: Colors.green,
                                size: 18,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                common.publishMessage(
                                    data['username'],
                                    "£01GuestInvite01£*£" +
                                        id +
                                        "£*£" +
                                        common.broadcasterId.toString() +
                                        "£*£" +
                                        data['profileName'] +
                                        "£*£" +
                                        data['username'] +
                                        "£*£" +
                                        data['profile_pic'] +
                                        "£*£" +
                                        data['level']);
                              },
                            )
                                : Container(),
                            RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white),
                              ),
                              color: Colors.white,
                              label: Text(
                                'Chat',
                                style: TextStyle(color: Colors.black),
                              ),
                              icon: Icon(
                                Icons.message,
                                color: Colors.black,
                                size: 18,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(
                                            peerId: data['firebaseUID'] == null
                                                ? "0"
                                                : data['firebaseUID'],
                                            peerAvatar: data['profile_pic'],
                                            peerName: data['profileName'],
                                            peergcm:
                                            data['gcm_registration_id'] == null
                                            ? "0"
                                            : data['gcm_registration_id'],
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
                              label: Text(
                                common.relationData,
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Icon(
                                common.relationImage,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                userRelation(common.userrelation, id, common,
                                    setState, context);
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

  void userRelation(type, id, common, setState, context) {
    setState(() {
      common.loaderInside = true;
    });
    var endPoint = 'user/userRelation';
    var action = '';
    var returnData = '';
    var image = Icons.add;
    var relationInt = 0;
    switch (type) {
      case 0:
        action = 'follow';
        image = Icons.remove;
        returnData = 'Unfollow';
        relationInt = 1;
        break;
      case 1:
        action = 'unfollow';
        image = Icons.add;
        returnData = 'Follow';
        relationInt = 0;
        break;
      case 2:
        action = 'follow';
        image = Icons.swap_horiz;
        returnData = 'Friends';
        relationInt = 3;
        break;
      case 3:
        action = 'unfollow';
        image = Icons.add;
        returnData = 'Follow';
        relationInt = 2;
        break;
      default:
    }
    var params = {
      'action': action,
      'user_id': id.toString(),
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = jsonDecode(response);
      if (data['status'] == 0) {
        var body = data['body'];
        var message = data['body'];
        Fluttertoast.showToast(msg: message);
        CommonFun().saveShare('friends', body['friends']);
        CommonFun().saveShare('followers', body['followers']);
        CommonFun().saveShare('fans', body['fans']);
        if (id == common.broadcasterId) {
          var msgString = '£01relationStatus01£*£' +
              action +
              '£*£' +
              common.userId +
              '£*£' +
              common.name +
              '£*£' +
              common.username +
              '£*£' +
              common.profilePic;
          common.publishMessage(common.broadcastUsername, msgString);
        }
        setState(() {
          common.loaderInside = false;
          common.relationData = returnData;
          common.userrelation = relationInt;
          common.relationImage = image;
        });
      }
    });
  }

  void userBlockRelation(type, id, common, setState, context) {
    setState(() {
      common.loaderInside = true;
    });
    var endPoint = 'user/userRelation';
    var action = '';
    var returnData = '';
    var image = Icons.add;
    var relationInt = 0;
    switch (type) {
      case 0:
        action = 'block';
        image = Icons.radio_button_unchecked;
        returnData = 'Unblock';
        relationInt = 1;
        break;
      case 1:
        action = 'unblock';
        image = Icons.block;
        returnData = 'Block';
        relationInt = 0;
        break;
      default:
    }
    var params = {
      'action': action,
      'user_id': id.toString(),
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = jsonDecode(response);
      var message = data['body'];
      Fluttertoast.showToast(msg: message);
      common.publishMessage(
          common.broadcastUsername,
          '£01kickout01£*£' +
              id +
              '£*£' +
              common.userId +
              '£*£' +
              common.name +
              '£*£' +
              common.username +
              '£*£' +
              common.profilePic);
      setState(() {
        common.loaderInside = false;
        common.blockStatus = returnData;
        common.blockInt = relationInt;
        common.blockIcon = image;
      });
    });
  }

  Future<Dialog> _asyncSimpleDialog(id, common, BuildContext context) async {
    return await showDialog<Dialog>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Its Spam'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Its inApproproate'),
              ),
              common.userTypeGlob == 'broad'
                  ? SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  userKick(
                      common.blockInt, id, common, setState, context);
                },
                child: Text('KickOut'),
              )
                  : Container(),
              common.userTypeGlob == 'broad'
                  ? SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  userTextRelation(
                      common.textInt, id, common, setState, context);
                },
                child: Text(common.textStatus),
              )
                  : Container()
            ],
          );
        });
  }

  void userKick(type, id, common, setState, context) {
    setState(() {
      common.loaderInside = true;
    });
    var endPoint = 'user/userRelation';
    var params = {
      'action': 'kickOut',
      'user_id': id.toString(),
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = jsonDecode(response);
      var message = data['body'];
      Fluttertoast.showToast(msg: message);
      common.publishMessage(
          common.broadcastUsername,
          '£01kickout01£*£' +
              id +
              '£*£' +
              common.userId +
              '£*£' +
              common.name +
              '£*£' +
              common.username +
              '£*£' +
              common.profilePic);
      setState(() {
        common.loaderInside = false;
      });
    });
  }

  void userTextRelation(type, id, common, setState, context) {
    setState(() {
      common.loaderInside = true;
    });
    var endPoint = 'user/userRelation';
    var action = '';
    var returnData = '';
    var image = Icons.speaker_notes;
    var relationInt = 0;
    switch (type) {
      case 0:
        action = 'textMute';
        image = Icons.speaker_notes_off;
        returnData = 'Text Unmute';
        relationInt = 1;
        break;
      case 1:
        action = 'textUnmute';
        image = Icons.speaker_notes;
        returnData = 'Text Mute';
        relationInt = 0;
        break;
      default:
    }
    var params = {
      'action': action,
      'user_id': id.toString(),
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = jsonDecode(response);
      var message = data['body'];
      Fluttertoast.showToast(msg: message);
      common.publishMessage(
          common.broadcastUsername,
          '£01TextStatus01£*£' +
              id +
              '£*£' +
              action +
              '£*£' +
              common.userId +
              '£*£' +
              common.name +
              '£*£' +
              common.username +
              '£*£' +
              common.profilePic);
      setState(() {
        common.loaderInside = false;
        common.textStatus = returnData;
        common.textInt = relationInt;
        common.textIcon = image;
      });
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: Colors.white, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "ID " + common.broadcasterId.toString(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )),
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
            onTap: () {
              onTrophyClick();
            },
          ),
        ),
        Positioned(
          top: 20,
          left: 165,
          child: GestureDetector(
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: Colors.orange, fontSize: 14),
                  ),
                ],
              ),
            ),
            onTap: () {
              /* getContributorslist(common, context, common.audienceSetState, common.fullcontpage);*/
              common.pageforbottm = 1;
              common.lastpageforbottom = 1;
              common.contributerType = 'all';
              showaudience(context, common, setState);
            },
          ),
        ),
      ],
    );
  }

  void showaudience(context, common, setState) {
    setState(() {
      common.loaderInside = true;
    });
    var endPoint = 'user/List';
    var params = 'page=' +
        common.pageforbottm.toString() +
        '&length=10&action=audience&user_id=' +
        common.broadcasterId.toString();
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      common.filteredList = [];
      common.lastpageforbottom = pic['body']['last_page'];
      var res = pic['body']['audience']['viewers_list'];
      if (res.length > 0) {
        for (dynamic v in res) {
          var relation = v['userRelation'];
          relation = relation ?? 0;
          var icon = Icons.add;
          var name = 'Follow';
          if (relation == 1) {
            name = 'Unfollow';
            icon = Icons.remove;
          } else if (relation == 3) {
            name = 'Friend';
            icon = Icons.swap_horiz;
          }
          var person = Person(
              v['profileName'],
              v['user_id'],
              v['level'],
              v['userRelation'],
              v['profile_pic'],
              name,
              icon);
          common.filteredList.add(person);
        }
        var endPoint = 'user/List';
        var params = 'page=' +
            common.pageforbottm.toString() +
            '&length=10&type=' +
            common.contributerType +
            '&action=topFans&user_id=' +
            common.broadcasterId.toString();
        makeGetRequest(endPoint, params, 0, context).then((response) {
          setState(() {
            common.loaderInside = false;
          });
          var data = (response).trim();
          var pic = json.decode(data);
          common.fullContList = pic['body']['full_Data'];
          common.dayContList = pic['body']['day_Data'];
          common.fullcontpageLength = pic['body']['full_page'];
          common.daycontpageLength = pic['body']['day_page'];
          showModalBottomSheet(
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
            barrierColor: Colors.white.withOpacity(0.0),
            context: context,
            builder: (BuildContext context) {
              common.closeContext = context;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  common.audienceSetState = setState;
                  return Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: TabBar(
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        'Audience',
                                        style: Theme
                                            .of(context)
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
                                        'Contributors',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                  controller:
                                  common.audienceContributerController,
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              flex: 10,
                              child: TabBarView(
                                controller:
                                common.audienceContributerController,
                                children: <Widget>[
                                  ListView.builder(
                                    controller:
                                    common.scrollControllerforbottom,
                                    shrinkWrap: true,
                                    itemCount: common.filteredList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                if (common.userId !=
                                                    common.filteredList[index]
                                                        .userid) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullProfile(
                                                              userId: common
                                                                  .filteredList[
                                                              index]
                                                                  .userid),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    common.filteredList[index]
                                                        .profilepic),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets.all(3.0),
                                              width: 80,
                                              height: 40,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: <Widget>[
                                                  Text(
                                                    common.filteredList[index]
                                                        .personFirstName,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    'ID - ' +
                                                        common
                                                            .filteredList[index]
                                                            .userid,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                        color: Colors.amber,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 2, 5, 2),
                                              decoration: BoxDecoration(
                                                  color: Colors.pink,
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          50.0))),
                                              child: Text(
                                                '⭐ ' +
                                                    common.filteredList[index]
                                                        .lvl,
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            RaisedButton(
                                              onPressed: () {
                                                userRelationbtm(
                                                    common.filteredList[index]
                                                        .userrelation,
                                                    common.filteredList[index]
                                                        .userid,
                                                    index,
                                                    setState,
                                                    common,
                                                    context);
                                              },
                                              textColor: Colors.white,
                                              color: Colors.transparent,
                                              padding:
                                              const EdgeInsets.all(0.0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      80.0)),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 1, 5, 1),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(50)),
                                                  gradient: LinearGradient(
                                                      begin:
                                                      Alignment.centerLeft,
                                                      end:
                                                      Alignment.centerRight,
                                                      colors: [
                                                        Color(0xFFEC008C),
                                                        Color(0xFFFC6767)
                                                      ]),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      common.filteredList[index]
                                                          .icon,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      common.filteredList[index]
                                                          .relationName,
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: TabBar(
                                              tabs: [
                                                Tab(
                                                  child: Text(
                                                    'Day List',
                                                    style: Theme
                                                        .of(context)
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
                                                    'Full List',
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              controller:
                                              common.contributerController,
                                              onTap: (index) {
                                                if (index == 0) {
                                                  common.contributerType =
                                                  'day';
                                                }
                                                if (index == 1) {
                                                  common.contributerType =
                                                  'full';
                                                }
                                              },
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: TabBarView(
                                            controller:
                                            common.contributerController,
                                            children: <Widget>[
                                              contributerList(
                                                  common.dayContList,
                                                  common.dayscrollController,
                                                  common),
                                              contributerList(
                                                  common.fullContList,
                                                  common.fullscrollController,
                                                  common)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      common.loaderInside == true
                          ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : Container(),
                    ],
                  );
                },
              );
            },
          ).whenComplete(() {
            common.closeContext = null;
          });
        });
      }
    });
  }

  Widget contributerList(list, scrollController, common) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (common.userId != list[index]['user_id']) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullProfile(userId: list[index]['user_id']),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(list[index]['profilePic']),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      list[index]['profileName'],
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.white, fontSize: 10),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'ID - ' + list[index]['reference_user_id'],
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.amber, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.all(Radius.circular(50.0))),
                child: Text(
                  '⭐ ' + list[index]['level'],
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white, fontSize: 12),
                ),
              ),
              Row(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/broadcast/Gold.png',
                    ),
                    width: 10,
                    height: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    list[index]['gold'].toString(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /*dynamic getContributorslist(common, context, setState, page) {
    var endPoint = 'user/List';
    var params = 'page=' +
        page.toString() +
        '&length=10&type=' +
        common.contributerType +
        '&action=topFans&user_id=' +
        common.broadcasterId.toString();
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      common.lastpageforbottom = pic['body']['last_page'];
      if (common.contributerType == 'all' || common.contributerType == 'full') {
        if (pic['body']['full_Data'].length > 0) {
          common.fullContList = List.from(common.fullContList)
            ..addAll(pic['body']['full_Data']);
        }
      }
      if (common.contributerType == 'all' || common.contributerType == 'day') {
        if (pic['body']['day_Data'].length > 0) {
          common.dayContList = List.from(common.dayContList)
            ..addAll(pic['body']['day_Data']);
        }
      }
      setState(() {});
    });
  }*/

  _share() {
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
                          File file = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
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
                          final result =
                          await SocialSharePlugin.shareToTwitterLink(
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
                          final result =
                          await SocialSharePlugin.shareToFeedFacebookLink(
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
                          File file = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          await SocialSharePlugin.shareToFeedInstagram(
                              path: file.path);
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
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),
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
                            sendGift(
                                "bulletMessage",
                                common.chatController.text,
                                1,
                                0,
                                setState,
                                context,
                                common);
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

  onTrophyClick() {
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

  dynamic clearGiftList() {
    common.chatList = [];
    common.guestData = [];
    common.vipGift = [];
    common.giftqueuelist = [];
    common.normalgiftqueuelist = [];
    common.bulletqueuelist = [];
    common.arrivedqueuelist = [];
    common.inviteRequest = [];
    common.normalList1 = [];
    common.normalList2 = [];
    common.normalList3 = [];
    common.normalList4 = [];
    common.bullet1List = [];
    common.bullet2List = [];
    common.bullet3List = [];
  }

  dynamic stopAnimation() {
    try {
      common.animationController.stop();
      common.normalleft1controller.stop();
      common.normalleft2controller.stop();
      common.bullet1controller.stop();
      common.bullet2controller.stop();
      common.bullet3controller.stop();
      common.arrivedMessageController.stop();
      common.timerController.stop();
    } catch (e) {}
  }
}
