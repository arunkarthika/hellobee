import 'dart:convert';
import 'dart:io' as io;
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
import 'package:mqtt_client/mqtt_client.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:screenshot/screenshot.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import 'body/zego.dart';

//class Commonold {
//  String username = "";
//  String entranceEffect = "";
//  String broadcasterProfileName;
//  String broadprofilePic;
//  String level = "";
//  String name = "";
//  String profilePic = "";
//  String userId = "";
//  String broadcastUsername = "";
//  String userTypeGlob = "";
//  String relationData = 'Follow';
//  String broadcastType = "";
//  String giftUserId="";
//  String broadcasterId = "";
//
//  List audiencelist = <AudienceList>[];
//  final chatlist = <Chatmodel>[];
//
//  int page = 1;
//  int pageLength = 1;
//  int animationSelect = 0;
//  int normalSelect = 0;
//  int idelTime = 0;
//  int like = 0;
//  int bgold = 0;
//  int gold = 0;
//  int giftCountTemp;
//  int giftCount;
//  int giftValue;
//  int currentIndex = 0;
//  int diamond = 0;
//  int c = 0;
//  int userrelation = 0;
//
//  double widthScreen;
//
//  bool swipeup = false;
//  bool gift = true;
//  bool camera = true;
//  bool loading1 = false;
//  bool loading2 = false;
//  bool loading3 = false;
//  bool loading4 = false;
//  bool loader = true;
//  bool animation1Status = false;
//  bool animation2Status = false;
//  bool animation3Status = false;
//  bool arrivedStatus = false;
//  bool guestFlag = false;
//  bool showheart = false;
//  bool pkSession = false;
//
//  Animation normalleft1animation;
//  Animation normalleft2animation;
//  Animation normalright1animation;
//  Animation normalright2animation;
//  Animation bullet1animation;
//  Animation bullet2animation;
//  Animation bullet3animation;
//  Animation arrivedMessageAnimation;
//  AnimationController menuController;
//
//  MqttClient client;
//  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
//  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;
//
//  ScrollController scrollController = ScrollController();
//  ScrollController mesagecontroller = ScrollController();
//  ScrollController audioScrollcontroller = ScrollController();
//  TabController giftController;
//  SVGAAnimationController animationController;
//  AnimationController normalleft1controller;
//  AnimationController normalleft2controller;
//  AnimationController normalright1controller;
//  AnimationController normalright2controller;
//  AnimationController bullet1controller;
//  AnimationController bullet2controller;
//  AnimationController bullet3controller;
//  AnimationController arrivedMessageController;
//  TextEditingController chatController = TextEditingController();
//
//  PersistentBottomSheetController controller; // <------ Instance variable
//  final scaffoldKey = GlobalKey<ScaffoldState>(); // <---- Another instance variable
//  List<Person> filteredList = [];
//  ScrollController scrollControllerforbottom = new ScrollController();
//  String filter = "";
//  bool isLoading = false;
//  int pageforbottm = 1;
//  int lastpageforbottom = 0;
//  int heightOfModalBottomSheet=80;
//
//  final Shader linearGradient = LinearGradient(
//    colors: <Color>[Colors.pink, Colors.green],
//  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
//
//  DateTime currentTime = DateTime.now();
//  DateTime currentPassTime = DateTime.now();
//  FocusNode focusNode = FocusNode();
//  ZegoClass zego = ZegoClass();
//  DatabaseHelper db = DatabaseHelper();
//  AudioAppState player = AudioAppState();
//
//  bool comboFlag;
//  bool giftVisible = false;
//
//  var giftNames;
//  var giftMessage;
//  var dispayEffect = "";
//  var dispayEffectName = "";
//  var normalgiftDisplayJson = {};
//  var animationgiftDisplayJson = {};
//  var displaynormal = {};
//  var displayanimaion = {};
//  var displaynormalIcon = {};
//  var displayanimaionIcon = {};
//  var songs = {};
//  var relationImage = Icons.add;
//  var closeContext;
//
//
//  var guestList = {};
//  List comboList = [];
//  List normalGift = [];
//  List animationGift = [];
//  List vipGift = [];
//  List giftqueuelist = <Giftqueue>[];
//  List normalgiftqueuelist = <NormalGiftqueue>[];
//  List bulletqueuelist = <Bulletqueue>[];
//  List arrivedqueuelist = <Arrivedqueue>[];
//  List inviteRequest = <InviteRequest>[];
//  List normalList1 = [];
//  List normalList2 = [];
//  List normalList3 = [];
//  List normalList4 = [];
//  List bullet1List = [];
//  List bullet2List = [];
//  List bullet3List = [];
//  List guestData = <GuestData>[];
//
//  bool textMute = false;
//
//  Common() {
//    print(name);
//  }
//
//  void dataGet() {
//    print("===============first 2==================");
//    CommonFun().getStringData('profileName').then((value) {
//      name = value;
//      CommonFun().getStringData('profile_pic').then((value) {
//        profilePic = value;
//        CommonFun().getStringData('level').then((value) {
//          level = value;
//          CommonFun().getStringData('username').then((value) {
//            username = value;
//            CommonFun().getStringData('diamond').then((value) {
//              diamond = int.tryParse(value);
//              CommonFun().getStringData('entranceEffect').then((value) {
//                entranceEffect = value;
//                CommonFun().getStringData('broadcastUsername').then((value) {
//                  broadcastUsername = value;
//                  CommonFun().getStringData('userType').then((value) {
//                    userTypeGlob = value;
//                    CommonFun().getStringData('user_id').then((value) {
//                      userId = value;
//                      CommonFun().getStringData('broadcasterId').then((value) {
//                        broadcasterId = value;
//                        giftUserId=value;
//                        print(
//                            '---------------------- listData broadcastUsername-------------------------');
//                        print(broadcastUsername);
//                        print(value);
//                        print(broadcasterId);
//                        print(
//                            '---------------------- listData entranceEffect-------------------------');
//                        print(giftUserId);
//                        if (userTypeGlob == "broad") {
//                          broadcasterProfileName = name;
//                          broadprofilePic = profilePic;
//                          CommonFun()
//                              .getStringData('over_all_gold')
//                              .then((value) {
//                            gold = int.tryParse(value);
//                            print("===============first 10==================");
//                          });
//                        }
//                        giftGet();
//                      });
//                    });
//                  });
//                });
//              });
//            });
//          });
//        });
//      });
//    });
//    print("===============first 3==================");
//  }
//
//  giftGet() {
//    print("===============first 4==================");
//    db.getGift().then((onValueres) {
//      normalGift = onValueres[0];
//      print(normalGift);
//      animationGift = onValueres[1];
//      print(animationGift);
//      for (int i = 0; i < normalGift.length; i++) {
//        CommonFun()
//            .hasToDownloadAssets(normalGift[i]['giftLocal'].toString())
//            .then((res) {
//          var giftimagefile = "";
//          if (res) {
//            final bytes = Io.File(normalGift[i]['giftLocal'].toString())
//                .readAsBytesSync();
//            displaynormal[normalGift[i]['name']] = base64Encode(bytes);
//          } else {
//            CommonFun().base46String(normalGift[i]['url']).then((value) {
//              displaynormal[normalGift[i]['name']] = value;
//            });
//          }
//          CommonFun()
//              .hasToDownloadAssets(normalGift[i]['giftIconLocal'].toString())
//              .then((res) {
//            giftimagefile = "";
//            if (res) {
//              final bytes = Io.File(normalGift[i]['giftIconLocal'].toString())
//                  .readAsBytesSync();
//              giftimagefile = base64Encode(bytes);
//            }
//            displaynormalIcon[normalGift[i]['name']] = giftimagefile;
//          });
//        });
//      }
//      for (int i = 0; i < animationGift.length; i++) {
//        CommonFun()
//            .hasToDownloadAssets(animationGift[i]['giftLocal'].toString())
//            .then((res) async {
//          var giftimagefile = "";
//          if (res) {
//            final bytes = Io.File(animationGift[i]['giftLocal'].toString())
//                .readAsBytesSync();
//            displayanimaion[animationGift[i]['name']] = base64Encode(bytes);
//          } else {
//            CommonFun().base46String(animationGift[i]['url']).then((value) {
//              displayanimaion[animationGift[i]['name']] = value;
//            });
//          }
//          CommonFun()
//              .hasToDownloadAssets(animationGift[i]['giftIconLocal'].toString())
//              .then((res) {
//            giftimagefile = "";
//            if (res) {
//              final bytes =
//                  Io.File(animationGift[i]['giftIconLocal'].toString())
//                      .readAsBytesSync();
//              giftimagefile = base64Encode(bytes);
//            }
//            displayanimaionIcon[animationGift[i]['name']] = giftimagefile;
//            CommonFun()
//                .hasToDownloadAssets(animationGift[i]['audioLocal'].toString())
//                .then((res) {
//              var songfile = "";
//              if (res) {
//                songfile = animationGift[i]['audioLocal'];
//              } else {
//                songfile = animationGift[i]['audioURL'];
//              }
//              songs[animationGift[i]['name']] = songfile;
//            });
//          });
//        });
//      }
//      if (animationSelect == 0) {
//        giftMessage = "animation";
//        giftNames = animationGift[0]['name'];
//        giftValue = int.tryParse(animationGift[0]['price']);
//        int flag = int.tryParse(animationGift[0]['comboFlag']);
//        if (flag != 0) {
//          comboFlag = false;
//          var list = animationGift[0]['comboPacks'].split("!")[flag];
//          comboList = list.split(",");
//          giftCountTemp = int.parse(comboList[0]);
//          giftCount = giftCountTemp;
//          print('giftCountTemp1');
//          print(giftCountTemp);
//        } else {
//          comboFlag = true;
//          giftCountTemp = 1;
//          giftCount = 1;
//        }
//      }
//    });
//    print("===============first 5==================");
//  }
//
//  void publishMessage(String topic, String message) {
//    print("inside");
//    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
//    builder.addString(message);
//
//    print('MQTTClientWrapper::Publishing message $message to topic $topic');
//    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
//  }
//
//   removeGuest(userId,context) {
//    var params = {
//      "action": "removeGuest",
//      "guest_id": userId,
//      "broadcast_id": broadcasterId
//    };
//    makePostRequest("user/guest", jsonEncode(params), 0, context)
//        .then((response) {
//      var data = jsonDecode(response);
//      if (data['status'] == 0) {
//        publishMessage(
//            broadcastUsername,
//            "£01RemoveGus01£*£" +
//                userId +
//                "£*£" +
//                name +
//                "£*£" +
//                username +
//                "£*£" +
//                profilePic);
//                // setState(() {
//
//        // });
//      }
//      // Timer(Duration(milliseconds: 500), () {
//      //   Navigator.of(context).pushReplacementNamed('/dashboard');
//      // });
//    });
//  }
//}

class Common {
  Common();

  String username = '';
  String entranceEffect = '';
  String broadcasterProfileName;
  String broadprofilePic;
  String level = '';
  String name = '';
  String profilePic = '';
  String userId = '';
  String broadcastUsername = '';
  String userTypeGlob = '';
  String relationData = 'Follow';
  String broadcastType = '';
  String giftUserId = '';
  String broadcasterId = '';
  String prevUserId = '';
  String nextUserId = '';
  String prevUsername = '';
  String nextUsername = '';
  String contributerType = 'all';
  String targetTime = '';
  String achivedTime = '';
  String viewerCount = '';
  String starCount = '';
  String blockStatus = '';
  String textStatus = '';
  String pkSessionId = '';
  String pkBroadId = '';
  String pkBroadUsername = '';
  String giftUsername = '';
  String achiveGold = '';

  int pageforbottm = 1;
  int lastpageforbottom = 1;
  int page = 1;
  int pageLength = 1;
  int pkpage = 1;
  int pkpageLength = 1;
  int daycontpage = 1;
  int daycontpageLength = 1;
  int fullcontpage = 1;
  int fullcontpageLength = 1;
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
  int blockInt = 0;
  int starOriginalValue = 0;
  int textInt = 0;
  int videoMute = 0;
  int pkgold = 0;
  int timerDuration = 0;
  int pkRemainingTime = 0;

  double widthScreen;
  double reciveGoldTarget = 0.0;
  double broadTimeTarget = 0.0;
  double shareTarget = 0.0;
  double starValue = 0.0;

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
  bool comboFlag;
  bool giftVisible = false;
  bool textMute = false;
  bool contributerLoader = true;
  bool loaderInside = false;
  bool pkHost = true;
  bool pkGuest = true;
  bool showEmoji = false;

  Animation normalleft1animation;
  Animation normalleft2animation;
  Animation bullet1animation;
  Animation bullet2animation;
  Animation bullet3animation;
  Animation arrivedMessageAnimation;
  AnimationController menuController;

  AnimationController normalleft1controller;
  AnimationController normalleft2controller;
  AnimationController normalright1controller;
  AnimationController normalright2controller;
  AnimationController bullet1controller;
  AnimationController bullet2controller;
  AnimationController bullet3controller;

  MqttClient client;
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  ScrollController scrollController = ScrollController();
  ScrollController mesagecontroller = ScrollController();
  ScrollController audioScrollcontroller = ScrollController();
  ScrollController scrollControllerforbottom = ScrollController();
  ScrollController dayscrollController = ScrollController();
  ScrollController fullscrollController = ScrollController();
  ScrollController pkscrollController = ScrollController();
  ScreenshotController screenshotController = ScreenshotController();
  TabController giftController;
  TabController audienceController;
  Animation normalright2animation;

  TabController audienceContributerController;
  TabController contributerController;
  SVGAAnimationController animationController;
  AnimationController timerController;
  AnimationController invitTimeController;

  Animation normalright1animation;
  AnimationController arrivedMessageController;
  TextEditingController chatController = TextEditingController();

  DateTime currentTime = DateTime.now();
  DateTime currentPassTime = DateTime.now();
  FocusNode focusNode = FocusNode();
  ZegoClass zego = ZegoClass();
  DatabaseHelper db = DatabaseHelper();
  AudioAppState player = AudioAppState();
  GlobalKey btnKey = GlobalKey();

  var menu = PopupMenu();
  var giftNames;
  var giftMessage;
  var dbEffect = '';
  var dispayEffect = '';
  var dispayEffectName = '';
  var normalgiftDisplayJson = {};
  var animationgiftDisplayJson = {};
  var displaynormal = {};
  var displayanimaion = {};
  var displaynormalIcon = {};
  var displayanimaionIcon = {};
  var songs = {};
  var guestList = {};
  var closeContext;

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
  List audiencelist = <AudienceList>[];
  List chatList = <Chatmodel>[];
  List filteredList = [];
  List dayContList = [];
  List fullContList = [];

  Color starColor;

  IconData blockIcon = Icons.block;
  IconData relationImage = Icons.add;
  IconData textIcon = Icons.speaker_notes;

  StateSetter audienceSetState;

  void dataGet() {
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
              CommonFun().getStringData('dpEffects').then((value) {
                dbEffect = value;
                CommonFun().getStringData('entranceEffect').then((value) {
                  entranceEffect = value;
                  CommonFun().getStringData('broadcastUsername').then((value) {
                    broadcastUsername = value;
                    CommonFun().getStringData('userType').then((value) {
                      userTypeGlob = value;
                      CommonFun().getStringData('user_id').then((value) {
                        userId = value;
                        CommonFun()
                            .getStringData('broadcasterId')
                            .then((value) {
                          broadcasterId = value;
                          giftUserId = value;
                          if (userTypeGlob == 'broad') {
                            broadcasterProfileName = name;
                            broadprofilePic = profilePic;
                            CommonFun()
                                .getStringData('over_all_gold')
                                .then((value) {
                              gold = int.tryParse(value);
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
    });
  }

  dynamic giftGet() {
    db.getGift().then((onValueres) {
      print(onValueres);
      normalGift = onValueres[0];
      animationGift = onValueres[1];
      for (var i = 0; i < normalGift.length; i++) {
        CommonFun()
            .hasToDownloadAssets(normalGift[i]['giftLocal'].toString())
            .then((res) {
          if (res) {
            final bytes = io.File(normalGift[i]['giftLocal'].toString())
                .readAsBytesSync();
            displaynormal[normalGift[i]['name']] = base64Encode(bytes);
          } else {
            CommonFun().base46String(normalGift[i]['url']).then((value) {
              displaynormal[normalGift[i]['name']] = value;
            });
            CommonFun().downloadFile(
                normalGift[i]['url'], normalGift[i]['giftLocal'].toString());
          }
          CommonFun()
              .hasToDownloadAssets(normalGift[i]['giftIconLocal'].toString())
              .then((res) {
            if (res) {
              final bytes = io.File(normalGift[i]['giftIconLocal'].toString())
                  .readAsBytesSync();
              displaynormalIcon[normalGift[i]['name']] = base64Encode(bytes);
            } else {
              CommonFun().base46String(normalGift[i]['icon']).then((value) {
                displaynormalIcon[normalGift[i]['name']] = value;
              });
              CommonFun().downloadFile(normalGift[i]['icon'],
                  normalGift[i]['giftIconLocal'].toString());
            }
          });
        });
      }
      for (var i = 0; i < animationGift.length; i++) {
        CommonFun()
            .hasToDownloadAssets(animationGift[i]['giftLocal'].toString())
            .then((res) {
          if (res) {
            final bytes = io.File(animationGift[i]['giftLocal'].toString())
                .readAsBytesSync();
            displayanimaion[animationGift[i]['name']] = base64Encode(bytes);
          } else {
            CommonFun().base46String(animationGift[i]['url']).then((value) {
              displayanimaion[animationGift[i]['name']] = value;
            });
            CommonFun().downloadFile(animationGift[i]['url'],
                animationGift[i]['giftLocal'].toString());
          }
          CommonFun()
              .hasToDownloadAssets(animationGift[i]['giftIconLocal'].toString())
              .then((res) {
            if (res) {
              final bytes =
                  io.File(animationGift[i]['giftIconLocal'].toString())
                      .readAsBytesSync();
              displayanimaionIcon[animationGift[i]['name']] =
                  base64Encode(bytes);
            } else {
              CommonFun().base46String(animationGift[i]['icon']).then((value) {
                displayanimaionIcon[animationGift[i]['name']] = value;
              });
              CommonFun().downloadFile(animationGift[i]['icon'],
                  animationGift[i]['giftIconLocal'].toString());
            }
            CommonFun()
                .hasToDownloadAssets(animationGift[i]['audioLocal'].toString())
                .then((res) {
              var songfile = '';
              if (res) {
                songfile = animationGift[i]['audioLocal'];
              } else {
                songfile = animationGift[i]['audioURL'];
                CommonFun().downloadFile(animationGift[i]['audioURL'],
                    animationGift[i]['audioLocal'].toString());
              }
              songs[animationGift[i]['name']] = songfile;
            });
          });
        });
      }
      if (animationSelect == 0) {
        giftMessage = 'animation';
        giftNames = animationGift[0]['name'];
        giftValue = int.tryParse(animationGift[0]['price']);
        comboFlag = true;
        giftCountTemp = 1;
        giftCount = 1;
      }
    });
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  dynamic removeGuest(userId, context) {
    var params = {
      'action': 'removeGuest',
      'guest_id': userId,
      'broadcast_id': broadcasterId
    };
    makePostRequest('user/guest', jsonEncode(params), 0, context)
        .then((response) {
      var data = jsonDecode(response);
      if (data['status'] == 0) {
        publishMessage(
            broadcastUsername,
            '£01RemoveGus01£*£' +
                userId +
                '£*£' +
                name +
                '£*£' +
                username +
                '£*£' +
                profilePic);
      }
    });
  }

  dynamic starUpdate(gold, setState) {
    starCount = '1';
    var goldRange = 100;
    if (gold <= 100) {
      starCount = '1';
      goldRange = 100;
      starColor = Colors.pinkAccent[100];
    } else if (gold > 100 && gold <= 300) {
      goldRange = 300;
      starCount = '2';
      starColor = Colors.blueAccent;
    } else if (gold > 300 && gold <= 900) {
      goldRange = 900;
      starCount = '3';
      starColor = Colors.cyan;
    } else if (gold > 900 && gold <= 2700) {
      goldRange = 2700;
      starCount = '4';
      starColor = Colors.purpleAccent;
    } else if (gold > 2700 && gold <= 8100) {
      goldRange = 8100;
      starCount = '5';
      starColor = Colors.greenAccent;
    } else {
      goldRange = 8100;
      starCount = '5';
      starColor = Colors.greenAccent;
    }
    var tempgold = gold / goldRange;
    if (tempgold > 1.0) {
      tempgold = 1.0;
    }
    starValue = tempgold.toDouble();
    setState(() {});
  }

  Widget gradient(IconData iconData) {

    return Ink(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
          colors: [Colors.red, Colors.orangeAccent], // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
      ),
      child: Container(
        constraints: const BoxConstraints(minWidth: 30.0, minHeight: 30.0),
        // min sizes for Material buttons
        alignment: Alignment.center,
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }

  dynamic removeAudience(context, common) {
    var endPoint = 'user/audiance';
    var params = {
      'action': 'removeAudience',
      'length': '10',
      'page': page.toString(),
      'user_id': broadcasterId
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      audiencelist.removeWhere((item) => item.userId == userId);
      var arriveMsg = '£01RemoveAud01£*£' +
          userId +
          '£*£' +
          name +
          '£*£' +
          username +
          '£*£' +
          Uri.encodeFull(profilePic) +
          '£*£' +
          level;
      common.publishMessage(common.broadcastUsername, arriveMsg);
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
