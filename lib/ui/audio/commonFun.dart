
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/database_hepler.dart';
import 'package:honeybee/constant/models.dart';
import 'package:honeybee/constant/zego.dart';
import 'package:honeybee/model/AudienceList.dart';
import 'package:honeybee/model/Chatmodel.dart';
import 'package:honeybee/model/Queue.dart';
import 'package:honeybee/model/sharedPreference.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:base32/base32.dart';

class Common {
  String username = BliveConfig.instance.username;
  String entranceEffect = BliveConfig.instance.entranceEffect;
  String broadcasterProfileName;
  String broadprofilePic;
  String level = BliveConfig.instance.level;
  String name = BliveConfig.instance.name;
  String profilePic = BliveConfig.instance.profilePic;
  String userId = BliveConfig.instance.userId;
  String broadcastUsername = BliveConfig.instance.broadcastUsername;
  String userTypeGlob = BliveConfig.instance.broadcastUsername;
  String relationData = 'Follow';
  String relationImage = "assets/images/audience/Fans.png";
  String broadcastType="";

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
  int diamond = BliveConfig.instance.diamond;
  int c = 0;
  int userrelation = 0;
  int broadcasterId = 0;

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

  Animation normalleft1animation;
  Animation normalleft2animation;
  Animation normalright1animation;
  Animation normalright2animation;
  Animation bullet1animation;
  Animation bullet2animation;
  Animation bullet3animation;
  Animation arrivedMessageAnimation;

  MqttClient client;
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  ScrollController scrollController = ScrollController();
  ScrollController mesagecontroller = ScrollController();
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

  DateTime currentTime = DateTime.now();
  DateTime currentPassTime = DateTime.now();
  FocusNode focusNode = FocusNode();
  ZegoClass zego = ZegoClass();
  DatabaseHelper db = DatabaseHelper();

  bool comboFlag;
  bool giftVisible = false;

  var giftNames;
  var giftMessage;
  var dispayEffect = "";
  var dispayEffectName = "";
  var normalgiftDisplayJson = {};
  var animationgiftDisplayJson = {};
  var displaynormalIcon = {};
  var displayanimaionIcon = {};

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
  List guestData=<GuestData>[];
  Common() {
    print(name);
  }
  void dataGet() async {
    print("===============first 2==================");
    name = await CommonFun().getStringData('profileName');
    profilePic = await CommonFun().getStringData('profile_pic');
    level = await CommonFun().getStringData('level');
    username = await CommonFun().getStringData('username');
    diamond = int.tryParse(await CommonFun().getStringData("diamond"));
    entranceEffect = await CommonFun().getStringData('entranceEffect');
    broadcastUsername = await CommonFun().getStringData('broadcastUsername');
    userTypeGlob = await CommonFun().getStringData('userType');
    userId = await CommonFun().getStringData('user_id');
    broadcasterId =
        int.tryParse(await CommonFun().getStringData('broadcasterId'));

    print(
        '---------------------- listData broadcastUsername-------------------------');
    print(broadcastUsername);
    print(
        '---------------------- listData entranceEffect-------------------------');
    print(userTypeGlob);
    if (userTypeGlob == "broad") {
      broadcasterProfileName = name;
      broadprofilePic = profilePic;
      gold = int.tryParse(await CommonFun().getStringData('over_all_gold'));
    }
    print("===============first 3==================");
  }

  giftGet() {
    print("===============first 4==================");
    db.getGift().then((onValueres) {
      normalGift = onValueres[0];
      animationGift = onValueres[1];
      for (int i = 0; i < normalGift.length; i++) {
        displaynormalIcon[normalGift[i]['name']] = normalGift[i]['gift'];
      }
      for (int i = 0; i < animationGift.length; i++) {
        displayanimaionIcon[animationGift[i]['name']] =
            animationGift[i]['gift'];
      }
      print(animationSelect);
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
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }
}
