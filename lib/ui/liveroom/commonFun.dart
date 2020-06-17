import 'dart:convert';
import 'dart:io' as Io;
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/database_hepler.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/constant/models.dart';
import 'package:honeybee/model/AudienceList.dart';
import 'package:honeybee/model/Chatmodel.dart';
import 'package:honeybee/model/Queue.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:honeybee/ui/search_page.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import 'body/zego.dart';

class Common {
  String username = "";
  String entranceEffect = "";
  String broadcasterProfileName;
  String broadprofilePic;
  String level = "";
  String name = "";
  String profilePic = "";
  String userId = "";
  String broadcastUsername = "";
  String userTypeGlob = "";
  String relationData = 'Follow';
  String broadcastType = "";
  String giftUserId="";
  String broadcasterId = "";

  final audiencelist = <AudienceList>[];
  final chatlist = <Chatmodel>[];

  int page = 1;
  int pageLength = 1;
  int animationSelect = 0;
  int normalSelect = 0;
  int idelTime = 0;
  int like = 0;
  int bgold = 0;
  int gold = 0;
  int giftCountTemp;
  int giftCount;
  int giftValue;
  int currentIndex = 0;
  int diamond = 0;
  int c = 0;
  int userrelation = 0;

  double widthScreen;

  bool swipeup = false;
  bool gift = true;
  bool camera = true;
  bool loading1 = false;
  bool loading2 = false;
  bool loading3 = false;
  bool loading4 = false;
  bool loader = true;
  bool animation1Status = false;
  bool animation2Status = false;
  bool animation3Status = false;
  bool arrivedStatus = false;
  bool guestFlag = false;
  bool showheart = false;
  bool pkSession = false;

  Animation normalleft1animation;
  Animation normalleft2animation;
  Animation normalright1animation;
  Animation normalright2animation;
  Animation bullet1animation;
  Animation bullet2animation;
  Animation bullet3animation;
  Animation arrivedMessageAnimation;
  AnimationController menuController;

  MqttClient client;
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  ScrollController scrollController = ScrollController();
  ScrollController mesagecontroller = ScrollController();
  ScrollController audioScrollcontroller = ScrollController();
  TabController giftController;
  SVGAAnimationController animationController;
  AnimationController normalleft1controller;
  AnimationController normalleft2controller;
  AnimationController normalright1controller;
  AnimationController normalright2controller;
  AnimationController bullet1controller;
  AnimationController bullet2controller;
  AnimationController bullet3controller;
  AnimationController arrivedMessageController;
  TextEditingController chatController = TextEditingController();

  PersistentBottomSheetController controller; // <------ Instance variable
  final scaffoldKey = GlobalKey<ScaffoldState>(); // <---- Another instance variable
  List<Person> filteredList = [];
  ScrollController scrollControllerforbottom = new ScrollController();
  String filter = "";
  bool isLoading = false;
  int pageforbottm = 1;
  int lastpageforbottom = 0;
  int heightOfModalBottomSheet=80;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.pink, Colors.green],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  DateTime currentTime = DateTime.now();
  DateTime currentPassTime = DateTime.now();
  FocusNode focusNode = FocusNode();
  ZegoClass zego = ZegoClass();
  DatabaseHelper db = DatabaseHelper();
  AudioAppState player = AudioAppState();

  bool comboFlag;
  bool giftVisible = false;

  var giftNames;
  var giftMessage;
  var dispayEffect = "";
  var dispayEffectName = "";
  var normalgiftDisplayJson = {};
  var animationgiftDisplayJson = {};
  var displaynormal = {};
  var displayanimaion = {};
  var displaynormalIcon = {};
  var displayanimaionIcon = {};
  var songs = {};
  var relationImage = Icons.add;

  var guestList = {};
  List comboList = [];
  List normalGift = [];
  List animationGift = [];
  List vipGift = [];
  List giftqueuelist = <Giftqueue>[];
  List normalgiftqueuelist = <NormalGiftqueue>[];
  List bulletqueuelist = <Bulletqueue>[];
  List arrivedqueuelist = <Arrivedqueue>[];
  List inviteRequest = <InviteRequest>[];
  List normalList1 = [];
  List normalList2 = [];
  List normalList3 = [];
  List normalList4 = [];
  List bullet1List = [];
  List bullet2List = [];
  List bullet3List = [];
  List guestData = <GuestData>[];

  Common() {
    print(name);
  }

  void dataGet() {
    print("===============first 2==================");
    CommonFun().getStringData('profileName').then((value) {
      name = value;
      CommonFun().getStringData('profile_pic').then((value) {
        profilePic = value;
        CommonFun().getStringData('level').then((value) {
          level = value;
          CommonFun().getStringData('username').then((value) {
            username = value;
            CommonFun().getStringData('diamond').then((value) {
              diamond = int.tryParse(value);
              CommonFun().getStringData('entranceEffect').then((value) {
                entranceEffect = value;
                CommonFun().getStringData('broadcastUsername').then((value) {
                  broadcastUsername = value;
                  CommonFun().getStringData('userType').then((value) {
                    userTypeGlob = value;
                    CommonFun().getStringData('user_id').then((value) {
                      userId = value;
                      CommonFun().getStringData('broadcasterId').then((value) {
                        broadcasterId = value;
                        giftUserId=value;
                        print(
                            '---------------------- listData broadcastUsername-------------------------');
                        print(broadcastUsername);
                        print(value);
                        print(broadcasterId);
                        print(
                            '---------------------- listData entranceEffect-------------------------');
                        print(giftUserId);
                        if (userTypeGlob == "broad") {
                          broadcasterProfileName = name;
                          broadprofilePic = profilePic;
                          CommonFun()
                              .getStringData('over_all_gold')
                              .then((value) {
                            gold = int.tryParse(value);
                            print("===============first 10==================");
                          });
                        }
                        giftGet();
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
    print("===============first 3==================");
  }

  giftGet() {
    print("===============first 4==================");
    db.getGift().then((onValueres) {
      normalGift = onValueres[0];
      print(normalGift);
      animationGift = onValueres[1];
      print(animationGift);
      for (int i = 0; i < normalGift.length; i++) {
        CommonFun()
            .hasToDownloadAssets(normalGift[i]['giftLocal'].toString())
            .then((res) {
          var giftimagefile = "";
          if (res) {
            final bytes = Io.File(normalGift[i]['giftLocal'].toString())
                .readAsBytesSync();
            displaynormal[normalGift[i]['name']] = base64Encode(bytes);
          } else {
            CommonFun().base46String(normalGift[i]['url']).then((value) {
              displaynormal[normalGift[i]['name']] = value;
            });
          }
          CommonFun()
              .hasToDownloadAssets(normalGift[i]['giftIconLocal'].toString())
              .then((res) {
            giftimagefile = "";
            if (res) {
              final bytes = Io.File(normalGift[i]['giftIconLocal'].toString())
                  .readAsBytesSync();
              giftimagefile = base64Encode(bytes);
            }
            displaynormalIcon[normalGift[i]['name']] = giftimagefile;
          });
        });
      }
      for (int i = 0; i < animationGift.length; i++) {
        CommonFun()
            .hasToDownloadAssets(animationGift[i]['giftLocal'].toString())
            .then((res) async {
          var giftimagefile = "";
          if (res) {
            final bytes = Io.File(animationGift[i]['giftLocal'].toString())
                .readAsBytesSync();
            displayanimaion[animationGift[i]['name']] = base64Encode(bytes);
          } else {
            CommonFun().base46String(animationGift[i]['url']).then((value) {
              displayanimaion[animationGift[i]['name']] = value;
            });
          }
          CommonFun()
              .hasToDownloadAssets(animationGift[i]['giftIconLocal'].toString())
              .then((res) {
            giftimagefile = "";
            if (res) {
              final bytes =
                  Io.File(animationGift[i]['giftIconLocal'].toString())
                      .readAsBytesSync();
              giftimagefile = base64Encode(bytes);
            }
            displayanimaionIcon[animationGift[i]['name']] = giftimagefile;
            CommonFun()
                .hasToDownloadAssets(animationGift[i]['audioLocal'].toString())
                .then((res) {
              var songfile = "";
              if (res) {
                songfile = animationGift[i]['audioLocal'];
              } else {
                songfile = animationGift[i]['audioURL'];
              }
              songs[animationGift[i]['name']] = songfile;
            });
          });
        });
      }
      if (animationSelect == 0) {
        giftMessage = "animation";
        giftNames = animationGift[0]['name'];
        giftValue = int.tryParse(animationGift[0]['price']);
        int flag = int.tryParse(animationGift[0]['comboFlag']);
        if (flag != 0) {
          comboFlag = false;
          var list = animationGift[0]['comboPacks'].split("!")[flag];
          comboList = list.split(",");
          giftCountTemp = int.parse(comboList[0]);
          giftCount = giftCountTemp;
          print('giftCountTemp1');
          print(giftCountTemp);
        } else {
          comboFlag = true;
          giftCountTemp = 1;
          giftCount = 1;
        }
      }
    });
    print("===============first 5==================");
  }

  void publishMessage(String topic, String message) {
    print("inside");
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic $topic');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

   removeGuest(userId,context) {
    var params = {
      "action": "removeGuest",
      "guest_id": userId,
      "broadcast_id": broadcasterId
    };
    makePostRequest("user/guest", jsonEncode(params), 0, context)
        .then((response) {
      var data = jsonDecode(response);
      if (data['status'] == 0) {
        publishMessage(
            broadcastUsername,
            "£01RemoveGus01£*£" +
                userId +
                "£*£" +
                name +
                "£*£" +
                username +
                "£*£" +
                profilePic);
                // setState(() {
         
        // });
      }
      // Timer(Duration(milliseconds: 500), () {
      //   Navigator.of(context).pushReplacementNamed('/dashboard');
      // });
    });
  }
}

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class AudioAppState {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  AudioAppState() {
    initAudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
  }

  Future playURL(kUrl) async {
    await audioPlayer.play(kUrl);
    playerState = PlayerState.playing;
  }

  Future playLocal(kUrl) async {
    await audioPlayer.play(kUrl, isLocal: true);
    playerState = PlayerState.playing;
  }

  Future pause() async {
    await audioPlayer.pause();
    playerState = PlayerState.paused;
  }

  Future stop() async {
    print("stop");
    await audioPlayer.stop();
    playerState = PlayerState.stopped;
    position = Duration();
  }

  Future mute(bool muted) async {
    await audioPlayer.setVolume(0.0);
  }

  void onComplete() {
    print("oncomplete");
  }
}

