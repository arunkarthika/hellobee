
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/constant.dart' as Constants;
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/constant/models.dart';
import 'package:honeybee/model/AudienceList.dart';
import 'package:honeybee/model/Chatmodel.dart';
import 'package:honeybee/model/Queue.dart';
import 'package:honeybee/model/sharedPreference.dart';
import 'package:honeybee/music/main_1.dart';
import 'package:honeybee/ui/audio/commonFun.dart';
import 'package:honeybee/ui/audio/footer.dart';
import 'package:honeybee/ui/broadcastEnd.dart';
import 'package:honeybee/ui/editprofile.dart';
import 'package:honeybee/utils/global.dart';
import 'package:honeybee/utils/string.dart';
import 'package:honeybee/widget/mycircleavatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class AudioCall extends StatefulWidget {
  AudioCall({
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

  MyAudioCall createState() => MyAudioCall(
    userId: userId1,
    broadcastUsername: username1,
    userType: userType1,
    broadcastType: broadcastType1,
    broadcasterId: broadcasterId1,
  );
}

class MyAudioCall extends State<AudioCall> with
    TickerProviderStateMixin, WidgetsBindingObserver {
  MyAudioCall({
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

  final List tags = [
    "↑Lv 10",
    '🌝 Happy face',
    "💎 50K",
    "♀ Male",
    "💐 Life style🤳",
    "Bio: 😚 Forget Whoe Forgets U 👍"
  ];

  FocusNode _focusNode = FocusNode();
  ScrollController _controller = ScrollController();
  final _channelMessageController = TextEditingController();
  String _platformVersion = 'Unknown';

  final String pk = 'assets/liveroom/pk.svg';
  final String gallery = 'assets/liveroom/gallery.svg';
  final String music = 'assets/liveroom/music.svg';
  final String games = 'assets/liveroom/games.svg';
  final String heart = 'assets/liveroom/heart.svg';

  @override
  void initState() {
      super.initState();
      Wakelock.enable();

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ));

      String sname = BliveConfig.instance.name;
      CommonFun().saveShare('broadcasterId', broadcasterId);
      CommonFun().saveShare('broadcastUsername', broadcastUsername);
      CommonFun().saveShare('userType', userType);
      common.dataGet();
      common.giftGet();
      common.animationController = SVGAAnimationController(vsync: this);
      common.giftController = TabController(length: 2, vsync: this);

      ZegoExpressEngine.instance.startPublishingStream(broadcasterId);
      ZegoExpressEngine.instance.startPlayingStream(broadcasterId);

      Timer(Duration(milliseconds: 500), () {
        prepareMqttClient();
        print("Yeah, this line is printed after 1 seconds");
        ZegoUser user = ZegoUser(userId, common.username);
        ZegoExpressEngine.instance.loginRoom(broadcastUsername, user);

        common.zego.setCallback(setState);

        common.zego.width = MediaQuery.of(context).size.width.ceil().toInt() + 50;
        common.zego.height = (MediaQuery.of(context).size.height.ceil().toInt()) + 50;

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

      Chatmodel chatmodel =
      Chatmodel("", "", "Warning : Lorem Ipsum is simply dummy text of the printing and "
          "typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
          "when an unknown printer took a galley of type and scrambled it "
          "to make a type specimen book");
      common.chatlist.add(chatmodel);
    }

    @override
    void dispose() {
      if (userType == "broad") {
        ZegoExpressEngine.instance.stopPublishingStream();
      }
      _controller.dispose();
      _focusNode.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Image(
                image: AssetImage(
                  "assets/broadcast/AudioBG.jpg",
                ),
                fit: BoxFit.fill,
              ),
            ),

           // Audio Stroy

            /*Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: AudioStory(),
                     *//* child: audienceListView(common),*//*
                    ),
                  ],
                )),*/

            Positioned(
              top: 95,
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
                  Fluttertoast.showToast(msg: profileSuccess);
                },
              ),
            ),

            Positioned(
              top: 90,
              right: 15,
              child: SingleChildScrollView(
                child: Container(
                  width: 250,
                  height: 45,
                  child: _audienceListView(common),
                ),
              ),
            ),

            Positioned(
              top: 85,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                height: 200,
                child: GridView.count(
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 4,
                  children: List.generate(8, (index) {
                   /* return GridTile(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://i.pinimg.com/736x/0b/a9/63/0ba963472e12aefd5b6e903f673405c4.jpg",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text(
                              "Robert",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: Colors.white, fontSize: 14),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.0),
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                border: Border.all(color: Colors.pink),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 3),
                         `           child: SvgPicture.asset(heart,
                                      width: 10.0,
                                      height: 10.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                   Text(
                                    " 0",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );*/
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (common.userTypeGlob == "broad") {
                              print("broad");
                            }
                          },
                          child: common.guestData.length > index
                              ? Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(
                                image: NetworkImage(
                                  common.guestData[index].image,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                              : Container(
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
                            "name",//common.guestData[index].name
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.white),
                          ),
                        )
                            : Container(),
                        common.guestData.length > index
                            ? Container(
                          child: Text(
                            "name",//common.guestData[index].name
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.white),
                          ),
                        )
                            : Container(),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Visibility(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 55,
              child: Container(
                alignment: Alignment.centerRight,
                width: 100,
                height: 50,
                padding: EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
//                        "sangeeth",
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
              top: 45,
              right: 15,
              child: GestureDetector(
               onTap: userType != "broad" ? onWillPopOffline : _onWillPop,
                child: Image(
                  image: AssetImage(
                    "assets/broadcast/Close.png",
                  ),
                  width: 15,
                  height: 15,
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  profileview(context);
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
                            "https://i.pinimg.com/736x/0b/a9/63/0ba963472e12aefd5b6e903f673405c4.jpg",
                           // common.broadprofilePic,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 165,
              child: GestureDetector(
                onTap: () {
                 contributorsList1();
                },
                child: Container(
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                height: 20,
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
                      width: 10,
                    ),
                    Text(
//                      common.gold.toString(),
                    "0",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Colors.orange, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 10,
              right: 50,
              // width: MediaQuery.of(context).size.width,
              child: Container(
                alignment: Alignment.center,
                // color: Colors.red,
                height: 300,
                // width: 200,
                // width: double.infinity,
                child: _buildInfoList(common),
              ),
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
                onTap: () => _profileview(),
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
                    "assets/broadcast/Gift.png",
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
        ),
      ),
    );
  }

  Future<bool> _invitationPopUp(inviteString, id) async {
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
                      // print("accepted");
                      common.publishMessage(
                        broadcastUsername,
                        "£01GuestInviteResponse01£*£Accepted£*£" +
                            id +
                            "£*£" +
                            common.name +
                            "£*£" +
                            common.username +
                            "£*£" +
                            common.profilePic,
                      );
                      Navigator.of(context).pop(false);
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
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      // print("rejected");
                      common.publishMessage(
                          broadcastUsername,
                          "£01GuestInviteResponse01£*£Rejected£*£" +
                              id +
                              "£*£" +
                              common.name +
                              "£*£" +
                              common.username +
                              "£*£" +
                              common.profilePic);
                      // _client.refuseRemoteInvitation(inviteString);
                      Navigator.of(context).pop(false);
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
              ],
            ),
          );
        }),
      ),
    )) ??
        false;
  }

  void onMessage() {
    common.client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      MqttPublishMessage recMess = c[0].payload;
      String receivedTopic = c[0].topic;
      String newLocationJson =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print("MQTTClientWrapper::GOT A NEW MESSAGE $newLocationJson");

      var tmpmsg = newLocationJson;
      if (tmpmsg.contains("£01AudArrive01£*") && !tmpmsg.contains(userId)) {
        var arrData = tmpmsg.split("£*£");
        setState(() {
          AudienceList audList =
          AudienceList(arrData[1], arrData[2], arrData[3], arrData[4]);
          common.audiencelist.insert(0, audList);
          Arrivedqueue giftqueue = Arrivedqueue(arrData[2], arrData[6]);
          common.arrivedqueuelist.add(giftqueue);
          loadArrived(setState, common);
          var arrived = arrData[5] + arrData[1] + arrData[2] + " has arrived";
          buildchatzone(arrived);
        });
      } else if (tmpmsg.contains("£01RemoveAud01£*") &&
          !tmpmsg.contains(userId)) {
        var arrData = tmpmsg.split("£*£");
        setState(() {
          common.audiencelist.removeWhere((item) => item.userId == arrData[1]);
          var arrived = arrData[5] + arrData[1] + arrData[2] + " has Left";
          buildchatzone(arrived);
        });
      } else if (tmpmsg.contains("£01sendGift01£*")) {
        var arrData = tmpmsg.split("£*£");
        if (arrData[5] == "normal") {
          NormalGiftqueue giftqueue =
          NormalGiftqueue(arrData[2], arrData[3], arrData[6], arrData[7]);
          common.normalgiftqueuelist.add(giftqueue);
          loadNormal(setState, common);
        } else {
          Giftqueue giftqueue = Giftqueue(arrData[3]);
          common.giftqueuelist.add(giftqueue);
          loadAnimation(setState, common);
        }
        var arrived =
            arrData[4] + arrData[1] + arrData[2] + " has sent " + arrData[3];
        buildchatzone(arrived);
      } else if (tmpmsg.contains("£01GuestInvite01£*") &&
          receivedTopic == common.username) {
        print("=============function inside invitation============");
        var arrData = tmpmsg.split("£*£");
        print(arrData);
        var content = arrData[3] + "  Has Sent You Request";
        if (userType == "broad") {
          InviteRequest queue = InviteRequest(
              arrData[3], arrData[5], arrData[6], arrData[1], arrData[4]);
          print(content);
          setState(() {
            common.inviteRequest.add(queue);
          });
        } else {
          _invitationPopUp(content, arrData[1]);
        }
      } else if (tmpmsg.contains("£01GuestInviteResponse01£*")) {
        var arrData = tmpmsg.split("£*£");
        if (arrData[1] == "Accepted") {
          if (userId == arrData[2]) {
            addGuest();
          }
        }
      } else if (tmpmsg.contains("£01RemoveGus01£*")) {
        var arrData = tmpmsg.split("£*£");
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        print(common.zego.guest.toString());
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        int pos = common.zego.guest.indexOf(arrData[1]);
        print(pos.toString());
        common.zego.guest.removeAt(pos);
        pos = pos + 1;
        if (broadcastType != "audio") {
          common.zego.playViewWidget.removeAt(pos);
        }
        setState(() {
          common.guestData.removeWhere((item) => item.userId == arrData[1]);
        });
        if (arrData[1] != userId && broadcastType != "audio") {
          disposePlay(arrData[1]);
        } else {
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
        print("==============newLocationJson================");
        print(newLocationJson);
        if (!tmpmsg.contains("£*£")) buildchatzone(newLocationJson);
      }
    });
  }

  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
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
      // buildchatzone('username ' +username+ ' broadcastUsername '+broadcastUsername);
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
      // print('MQTTClientWrapper::Mosquitto client connected ' +username);
      // buildchatzone('MQTTClientWrapper::Mosquitto client connected ' +username);
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

  getAudience() async {
    print("******************Audience*********************");
    print("8888888888888888"+ broadcasterId.toString());
    String endPoint = "user/List";
    String params = "page=" +
        common.page.toString() + "&length=10&action=audience&user_id=" +
        broadcasterId.toString();
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      print(pic);
      if (common.page <= common.pageLength) {
        print("*****************Audience +++++++**********************");
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
        GuestData gData = new GuestData(
            k, v["profileName"], v["username"], v["profile_pic"], v["level"]);
        common.guestData.add(gData);
        print('Key=$k, Value=$v');
        if (!common.zego.guest.contains(k)) {
          common.zego.guest.add(k);
          if (k != userId)
            common.zego.playRemoteStream(k, setState, common.broadcastType);
        }
      });
      setState(() {
        common.guestData = common.guestData;
      });
      print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
      print(common.zego.guest.toString());
      print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
    });
  }

  Future<bool> onWillPopOffline() async {
    if (common.guestFlag == true) {
      /*removeGuest();*/
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
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    });
    return Future.value(true);
  }

  Future<bool> _onWillPop() async {
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
            ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BroadcastEnd(
                  broadcastTime: actualBroadcastingTime.toString(),
                  viewvers: common.audiencelist.length.toString(),
                  like: common.like.toString(),
                  gold: common.bgold.toString(),
                  userId: broadcasterId),
            ))
            : Navigator.of(context).pushReplacementNamed('/dashboard');
      });
    }
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
                              // Replace with a Row for horizontal icon + text
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

  contributorsList(BuildContext context){
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: 350,
                child: Stack(
                  children: <Widget>[
                     ListView(
                      padding: EdgeInsets.all(0),
                      children: [
                        ListTile(
                          selected:true,
                          leading: CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
                          ),
                          title: Text("Name 1"),
                          subtitle: Text(" ID 150122"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
                          ),
                          title: Text("Name 2"),
                          subtitle: Text(" ID 100122"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading:CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
                          ),
                          title: Text("Name 3"),
                          subtitle: Text(" ID 102122"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://cdn.pixabay.com/photo/2015/02/04/08/03/baby-623417_960_720.jpg"),
                          ),
                          title: Text("Name 4"),
                          subtitle: Text(" ID 100122"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
                          ),
                          title: Text("Name 5"),
                          subtitle: Text(" ID 100016"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading:CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
                          ),
                          title: Text("Name 6"),
                          subtitle: Text(" ID 100356"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading:CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
                          ),
                          title: Text("Name 7"),
                          subtitle: Text(" ID 100045"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading:CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
                          ),
                          title: Text("Name 8"),
                          subtitle: Text(" ID 100754"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading:CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
                          ),
                          title: Text("Name 9"),
                          subtitle: Text(" ID 100098"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading:CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
                          ),
                          title: Text("Name 10"),
                          subtitle: Text(" ID 100854"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading:CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
                          ),
                          title: Text("Name 11"),
                          subtitle: Text(" ID 100583"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            profileview(context);
                          },
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                            NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
                          ),
                          title: Text("Name 12"),
                          subtitle: Text(" ID 100560"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  contributorsList1(){
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
//        popup.button(
//          label: 'Close',
//          onPressed: Navigator.of(context).pop,
//        ),
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
  }

  /*Widget _buildInfoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: messages1.length,
      itemBuilder: (ctx, i) {
        if (messages1[i]['status'] == MessageType.received) {
          return ReceivedMessagesWidget1(i: i);
        } else {
          return ReceivedMessagesWidget1(i: i);
        }
      },
    );
  }*/

  Widget _buildInfoList(common) {
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
            /*decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.30),
              borderRadius: BorderRadius.circular(30.0),
            ),*/
           /* child: Row(
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
                                .subtitle
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
                        .subtitle
                        .copyWith(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),*/
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
                        profileview(context);//common.chatlist[i].gold, context, common
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
                        /*"${messages1[i]['message']}",*/
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

  /*void socialShare() {
      Column(
        children: <Widget>[
          Center(
            child: Text('Running on: $_platformVersion\n'),
          ),
          RaisedButton(
            child: Text('Share to Instagram'),
            onPressed: () async {
              File file = await ImagePicker.pickImage(source: ImageSource.gallery);
              await SocialSharePlugin.shareToFeedInstagram(path: file.path);
            },
          ),
          RaisedButton(
            child: Text('Share to Facebook'),
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
          RaisedButton(
            child: Text('Share to Facebook Link'),
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
          RaisedButton(
            child: Text('Share to Twitter'),
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
        ],
      );
      _focusNode.requestFocus();
    }*/

  void _log(String info) {
      print("rtmmsg" + info.toString());
    }

  _toggleSendChannelMessage(text) async {
      if (text.isEmpty) {
        _log('Please input text to send.');
        return;
      }
      try {
        _channelMessageController.text = "";
        _log('Send channel message success.');
      } catch (errorCode) {
        _log('Send channel message error: ' + errorCode.toString());
      }
    }

  void buildchatzone(String string) {
    print('string');
    print(string);
    int txtsize = string.length;
    print(string.substring(2, 8));
    Chatmodel chatmodel = Chatmodel(string.substring(0, 2),
        string.substring(2, 8), string.substring(8, txtsize));
    setState(() {
      common.chatlist.add(chatmodel);
    });
  }

  toggleSendChannelMessage(text, common) async {
    // String text = _channelMessageController.text;
    if (text.isEmpty) {
      // _log('Please input text to send.');
      return;
    }
    try {
      var message = common.level + common.userId + common.name + " : " + text;
      print("message");
      print(message);
      common.publishMessage(common.broadcastUsername, message);

      // await _channel.sendMessage(AgoraRtmMessage.fromText(message))
      // _log('Send channel message success.');
    } catch (errorCode) {
      // _log('Send channel message error: ' + errorCode.toString());
    }
  }

  void loadBullet(common) async {
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

  addAudience() async {
    String endPoint = "user/audiance";
    var params = {
      "action": "addAudience",
      "length": "10",
      "page": common.page.toString(),
      "user_id": broadcasterId
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
          common.pageLength = pic['body']['last_page'];
          print("gggggggggguestgggggggggg");
          print(pic['body']['guestList']);
          common.guestList = pic['body']['guestList'];
        }
        if (common.guestList == null) common.guestList = {};

        common.zego.playViewWidget.clear();
        common.zego
            .playRemoteStream(broadcasterId, setState, common.broadcastType);

        common.guestData = [];
        common.guestData.clear();
        common.guestList.forEach((k, v) {
          GuestData gData = new GuestData(
              k, v["profileName"], v["username"], v["profile_pic"], v["level"]);
          common.guestData.add(gData);
          print('Key=$k, Value=$v');
          if (!common.zego.guest.contains(k)) {
            common.zego.guest.add(k);
            if (k != userId)
              common.zego.playRemoteStream(k, setState, common.broadcastType);
          }
        });
        setState(() {
          common.guestData = common.guestData;
        });

        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        print(common.zego.guest.toString());
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        print('ofter fun');
        common.gift = true;
        common.camera = false;
        common.loader = false;
        common.guestFlag = false;
      });
    });
  }

  void giftControllerFun() {
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

  disposePlay(streamID) {
    print("inside dispose play");
    print(common.zego.previewID[streamID]);
    int stream = common.zego.previewID[streamID];
    ZegoExpressEngine.instance.destroyTextureRenderer(stream);
    ZegoExpressEngine.instance.stopPlayingStream(streamID.toString());
    print("end of inside dispose play");
  }

  dateTimeDiff(time) {
    DateTime now = DateTime.now();
    var diff = now.difference(time).inSeconds;
    return diff;
  }

  addGuest() {
    var params = {
      "action": "addGuest",
      "guest_id": userId,
      "broadcast_id": broadcasterId
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
        GuestData gData = new GuestData(userId, common.name, common.username,
            common.profilePic, common.level);
        setState(() {
          common.guestData.add(gData);
        });
      }
    });
  }

  removeGuest() {
    var params = {
      "action": "removeGuest",
      "guest_id": userId,
      "broadcast_id": broadcasterId
    };
    makePostRequest("user/guest", jsonEncode(params), 0, context)
        .then((response) {
      var data = jsonDecode(response);
      if (data['status'] == 0) {
        common.publishMessage(
            broadcastUsername,
            "£01RemoveGus01£*£" +
                userId +
                "£*£" +
                common.name +
                "£*£" +
                common.username +
                "£*£" +
                common.profilePic);
      }
      Timer(Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      });
    });
  }

  profileview(BuildContext context) {
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
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://i.pinimg.com/736x/0b/a9/63/0ba963472e12aefd5b6e903f673405c4.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Amelia',
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
                              '100025'+
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
                                    Text("12K",
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
                                    Text("13K",
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
                                    Text("9k",
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
                                    Text("102K",
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
                            label: Text('Chat',
                              style: TextStyle(color: Colors.black),),
                            icon: Icon(Icons.message, color:Colors.black,size: 18,),
                            onPressed: () {

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

  Widget _audienceListView(common) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: common.scrollController,
      itemCount: common.audiencelist.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () =>
              Fluttertoast.showToast(msg: exit_warning),
              /*profileview1(common.audiencelist[index].userId, context, common)*/
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              border: Border.all(
                color: Colors.red,
                width: 1.0,
              ),
              image: DecorationImage(
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
                                    .subtitle
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
                                    .subtitle
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
                                      .subtitle
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
                                      .subtitle
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
                                      .subtitle
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
                                      .subtitle
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

  Widget arrivedShow(common) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
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
                                          .subtitle
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

  Widget showAnimationGift(common) {
    return Container(
      // color: Colors.amber,
      width: double.infinity,
      height: double.infinity,
      child: SVGAImage(common.animationController),
    );
  }

}
