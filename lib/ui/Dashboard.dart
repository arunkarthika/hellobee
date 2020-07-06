import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/database_hepler.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/constant/permision.dart';
import 'package:honeybee/model/car.dart';
import 'package:honeybee/model/gift.dart';
import 'package:honeybee/ui/editMeprofile.dart';
import 'package:honeybee/ui/insta/main12.dart';
import 'package:honeybee/ui/liveroom/commonFun.dart';
import 'package:honeybee/ui/liveroom/liveRoom.dart';
import 'package:honeybee/ui/liveroom/profileUi.dart';
import 'package:honeybee/ui/message.dart';
import 'package:honeybee/ui/profile.dart';
import 'package:honeybee/utils/string.dart';
import 'dart:async';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';
import 'package:path/path.dart' as p;

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePage();
  }
}

class HomePage extends State<Dashboard> with TickerProviderStateMixin {
  String api = 'https://blive.s3.ap-south-1.amazonaws.com';
  String _appDocsDir;

  TabController controller, bottomController;

  var currentCar = carList.cars[0];

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Live"),
    new Tab(text: "New"),
    new Tab(text: "Latest"),
    new Tab(text: "Hot"),
    new Tab(text: "battle"),
    new Tab(text: "Popular"),
    new Tab(text: "Games")
  ];

  TabController _tabController;

  int merge = 0;
  int page = 1;
  int currentPage = 0;
  List oldList = [];
  var listData = {};
  var userName;
  var userId;
  var profilePic;
  int pageIndex = 0;
  var giftVersion;
  DateTime currentBackPressTime;
  ScrollController activescrollController = ScrollController();
  List giftData = [];
  List banner = [];
  List solo = [];
  List audio = [];
  List activeList = [];
  List storyList = [];
  List giftList = <String>[];
  var db = DatabaseHelper();
  List listDataId = [];
  String globalType = "all";
  String country = "";
  String city = "";
  Common common = Common();

  int pageLength = 0;

  void path() async {
    if (_appDocsDir == null) {
      _appDocsDir = (await getApplicationDocumentsDirectory()).path;
    }
  }

  Future<bool> _hasToDownloadAssets(String name, String _appDocsDir) async {
    var file = File('$_appDocsDir/$name.zip');
    return !(await file.exists());
  }

  Future<void> _downloadAssets(String name) async {
    if (!await _hasToDownloadAssets(name, _appDocsDir)) {
      return;
    }
    var zippedFile =
    await _downloadFile('$api/$name.zip', '$name.zip', _appDocsDir);

    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);

    for (var file in archive) {
      var filename = '$_appDocsDir/${file.name}';
      if (file.isFile) {
        var outFile = File(filename);
        print('File Extract Here:: ' + outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }

  Future<File> _downloadFile(String url, String filename,
      String _appDocsDir) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$_appDocsDir/$filename');
    return file.writeAsBytes(req.bodyBytes);
  }

//Gift Download Prosess End

  _storagepermissionstore() async {
    var storageStatus = await PermissionFun().storagePermision();
    if (storageStatus.toString() != "PermissionStatus.granted") {
      toast("Please Allow the Permission", Colors.red);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    bottomController.dispose();
    _tabController.dispose();
    activescrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Wakelock.disable();
    path();
    dataGet();
    story();

    _tabController = new TabController(vsync: this, length: tabs.length);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.deepOrange,
      statusBarBrightness: Brightness.dark,
    ));

    _storagepermissionstore();
    controller = TabController(length: 3, vsync: this);
    bottomController = TabController(length: 4, vsync: this);
    bottomController.addListener(_handleTabSelection);

    activescrollController.addListener(() {
      if (activescrollController.position.pixels ==
          activescrollController.position.maxScrollExtent) {
        if (page <= pageLength) {
          page++;
          dataProccessor(0, "audio");
        }
      }
    });

    dataProccessor(0, "audio");
    ZegoExpressEngine.createEngine(
        1263844657,
        '6fd98a7be6002228918436de65cff64556cc4fb01c88b266f6b3904cd83692e6',
        true,
        ZegoScenario.General,
        enablePlatformView: false);
    super.initState();

  }

  void dataGet() async {
    print(await CommonFun().getStringData('bearer'));
    print(await CommonFun().getStringData('token'));
    userName = await CommonFun().getStringData('username');
    userId = await CommonFun().getStringData('user_id');
    profilePic = await CommonFun().getStringData('profile_pic');
    giftVersion = await CommonFun().getStringData('giftVersion');
    country = await CommonFun().getStringData('country');
    city = await CommonFun().getStringData('city');
  }

  void _handleTabSelection() {
    setState(() {});
  }

  dataProccessor(loader, type) {
    String endPoint = "user/liveStatus";
    String params = "type=" +
        "audio" +
        "&page=" +
        page.toString() +
        "&length=10&&geo=all&country=India&city=Erode";
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      var d2 = jsonDecode(data);
      if (d2['status'] == 0) {
        int bodyLength = d2['body']['active_user_details'].length;
        if (bodyLength != 0) {
          setState(() {
            if (type == "audio") {
              activeList = List.from(activeList)
                ..addAll(d2['body']['active_user_details']['audioLists']);
              pageLength = d2['body']['last_page'];
            }
            merge = 1;
          });
        }
        Timer(Duration(milliseconds: 500), () {
          dataSlider();
          Timer(Duration(milliseconds: 500), () {
            if (d2['body']['giftVersion'] != giftVersion) {
              CommonFun().saveShare('giftVersion', d2['body']['giftVersion']);
              giftVersion = d2['body']['giftVersion'];
              makeGetRequest("user/List",
                  "user_id=" + "100001" + "&action=giftList", 0, context)
                  .then((response) {
                var data = jsonDecode(response);
                giftData = data['body']['giftList']['gift_list']['all'];
                db.deleteGift();
                _downloadAssets('GIFT');
                for (int i = 0; i < giftData.length; i++) {
                  var urlextension = p.extension(giftData[i]["url"]);
                  var gift = giftData[i]["name"] + urlextension;
                  urlextension = p.extension(giftData[i]["icon"]);
                  var giftIcon = giftData[i]["name"] + urlextension;
                  urlextension = p.extension(giftData[i]["audio"]);
                  var audio = giftData[i]["name"] + urlextension;
                  var user = Gift(
                      giftData[i]["id"],
                      giftData[i]["url"],
                      giftData[i]["name"],
                      giftData[i]["price"],
                      giftData[i]["type"],
                      giftData[i]["icon"],
                      giftData[i]["combo_flag"],
                      giftData[i]["combo_packs"],
                      '$_appDocsDir/svga/$gift',
                      '$_appDocsDir/webp/$giftIcon',
                      '$_appDocsDir/audio/$audio',
                      giftData[i]["audio"]);
                  db.saveGift(user);
                }
              });
            }
            Timer(Duration(milliseconds: 500), () {
              var params = "action=quickProfile";
              makeGetRequest("user", params, 0, context).then((response) {
                var res = jsonDecode(response);
                var entryList = res['body'].entries.toList();
                for (int j = 0; j < entryList.length; j++) {
                  CommonFun().saveShare(
                      entryList[j].key, entryList[j].value.toString());
                }
              });
            });
          });
        });
        if (loader == 1) {
          Completer<Null> completer = Completer<Null>();
          completer.complete();
        }
      } else if (d2['status'] == 1 && d2['message'] == "Session Expiry") {
        dataProccessor(0, "audio");
      }
    });
  }

  dataSlider() {
    String endPoint = "system/banner"; //'appVersion';
    String params = "";
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      print(response);
      var d2 = jsonDecode(data);
      if (d2['status'] == 0) {
        setState(() {
          banner = d2['body'];
        });
      }
    });
  }

  imageConver(url) async {
    var data = await CommonFun().base46String(url);
    return data;
  }

  Future<List<Gift>> getUser() {
    return db.getGift();
  }

  Future<Null> refreshFun() async {
    setState(() {
      activeList = [];
      page = 1;
      pageLength = 1;
      dataProccessor(1, "audio");
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orangeAccent,
        accentColor: Colors.deepOrangeAccent,
        textTheme: GoogleFonts.firaSansCondensedTextTheme(
          Theme
              .of(context)
              .textTheme,
        ),
      ),
      routes: <String, WidgetBuilder>{'/dashboard': (context) => Dashboard()},
      home: WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Image(
                  image: AssetImage('assets/dashboard/Golive.png'),
                  width: 75,
                  height: 75),
              onPressed: () async {
                var camstatus = await PermissionFun().cameraPermision();
                var micstatus = await PermissionFun().micPermision();
                if (camstatus.toString() == "PermissionStatus.granted" &&
                    micstatus.toString() == "PermissionStatus.granted") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LiveRoom(
                              userId1: userId,
                              broadcasterId1: userId,
                              username1: userName,
                              userType1: "broad",
                              broadcastType1: "audio"),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(msg: permission_warning);
                }
              },
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
            body: TabBarView(
              children: <Widget>[
                Scaffold(
                  backgroundColor: Colors.orangeAccent[100],
                  appBar: new AppBar(
                    backgroundColor: Colors.orangeAccent[100],
                    title: new TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: new BubbleTabIndicator(
                        indicatorHeight: 25.0,
                        indicatorColor: Colors.deepOrange,
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      ),
                      tabs: tabs,
                      controller: _tabController,
                    ),
                  ),
                  body: Column(
                    children: <Widget>[
//                      Story(),
                      Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.only(top: 5.0),
                        child: storyListView(),
                      ),
                      Container(
                        width: double.infinity,
                        height: 120,
                        margin: EdgeInsets.all(5),
                        child: Card(
                          margin: EdgeInsets.only(top: 0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: CarouselSlider.builder(
                            itemCount: banner.length,
                            itemBuilder: (BuildContext context, int i) {
                              if (banner.length == 0) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        banner[i]['image'],
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              }
                            },
                            options: CarouselOptions(
                              height: double.infinity,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              enlargeCenterPage: false,
                              autoPlayInterval: Duration(seconds: 2),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView(
                                  children: <Widget>[
                                    offerDetails(85),
                                  ],
                                ),
                              )
                            ],
                          ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: tabs.map((Tab tab) {
                            switch (tab.text) {
                              case "Live":
                                break;
                              case "New":
                                break;
                              case "Latest":
                                break;
                              case "Hot":
                                break;
                              default:
                                break;
                            }

                            return new Center(
                              child: RefreshIndicator(
                                child: Container(
                                  child: dispyActive(
                                      activeList, activescrollController),
                                ),
                                onRefresh: refreshFun,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(child: Fluttergram()),
                Center(child: ChatHome()),
                Center(child: Profile()),
              ],
              controller: bottomController,
            ),
            bottomNavigationBar: BottomAppBar(
//              color: Colors.orangeAccent[100],
              elevation: 40.0,
//              shape: CircularNotchedRectangle(),
              child: TabBar(
                tabs: [
                  Tab(
                    child: Container(
                      child: bottomController.index == 0
                          ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.deepOrangeAccent,
                          backgroundImage:
                          AssetImage('assets/dashboard/Home.png'),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset('assets/dashboard/Home.png'),
                      ),
                      width: bottomController.index == 0 ? 40 : 30,
                      height: bottomController.index == 0 ? 40 : 30,
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: bottomController.index == 1
                          ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.deepOrangeAccent,
                          backgroundImage:
                          AssetImage('assets/dashboard/Photo.png'),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:
                        Image.asset('assets/dashboard/Photo.png'),
                      ),
                      width: bottomController.index == 1 ? 40 : 30,
                      height: bottomController.index == 1 ? 40 : 30,
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: bottomController.index == 2
                          ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.deepOrangeAccent,
                          backgroundImage:
                          AssetImage('assets/dashboard/Message.png'),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:
                        Image.asset('assets/dashboard/Message.png'),
                      ),
                      width: bottomController.index == 2 ? 40 : 30,
                      height: bottomController.index == 2 ? 40 : 30,
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: bottomController.index == 3
                          ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.deepOrangeAccent,
                          backgroundImage:
                          AssetImage('assets/dashboard/Profile.png'),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:
                        Image.asset('assets/dashboard/Profile.png'),
                      ),
                      width: bottomController.index == 3 ? 40 : 30,
                      height: bottomController.index == 3 ? 40 : 30,
                    ),
                  ),
                ],
                controller: bottomController,
                onTap: (indexs) {
                  print(indexs);
                  setState(() {
                    pageIndex = indexs;
                  });
                },
                indicatorColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget dispyActive(list, viewController) {
    return list.length != 0
        ? Container(
      width: double.infinity,
      height: double.infinity,
      child: GridView.count(
        controller: viewController,
        padding: const EdgeInsets.all(2),
        primary: false,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        children: List.generate(
          list.length,
              (index) {
            var live = 'Live';
            var data = list[index];
            if (data['status'] == 0) {
              live = 'offline';
            }
            return Container(
              margin:
              EdgeInsets.only(top: 1, bottom: 1, left: 1, right: 1),
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(data['profile_pic']),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [
                      0.3,
                      0.9
                    ],
                    colors: [
                      Colors.black,
                      Colors.orangeAccent,
                    ]),
              ),
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      var camstatus =
                      await PermissionFun().cameraPermision();
                      var micstatus =
                      await PermissionFun().micPermision();
                      if (camstatus.toString() ==
                          "PermissionStatus.granted" &&
                          micstatus.toString() ==
                              "PermissionStatus.granted") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LiveRoom(
                                  userId1: userId,
                                  broadcasterId1: data["user_id"].toString(),
                                  username1: data["username"],
                                  userType1: "audience",
                                  broadcastType1: "none",
                                ),
                          ),
                        );
                      }
                    },
                  ),
                  Positioned(
                    left: 1,
                    bottom: -2,
                    right: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ])),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 10, 2, 10),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          data['profileName'],
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    left: 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent[100],
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Text(
                          live,
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(
                              color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent[100],
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Text(
                          data['viewer_count'].toString()=="null"?"0":data['viewer_count'].toString(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(
                              color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

//                  Positioned( top: 2,
//                    right: 15,
//                    child: Container(
//                      width: 30,
//                decoration: BoxDecoration(
//                color: Colors.orangeAccent[100],
//                borderRadius: BorderRadius.circular(30.0),
//                ),
//                      child: Row(
//                        children: <Widget>[
//                          Container(
//                            width: 10,
//                            alignment: Alignment.center,
//                            child: Image(
//                              image: AssetImage(
//                                "assets/images/dashboard/Group3.png",
//                              ),
//                              width: 15,
//                              height: 15,
//                            ),
//                          ),
//                          Container(
//                            alignment: Alignment.center,
//
//                            child: Text(
//                              data['viewer_count'],
//                              style: Theme
//                                  .of(context)
//                                  .textTheme
//                                  .subtitle1
//                                  .copyWith(
//                                  color: Colors.black, fontSize: 8),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
                ],
              ),
            );
          },
        ),
      ),
    )
        : Container();
  }

  Future<bool> _onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }

  offerDetails(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              height: sheetItemHeight,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: currentCar.offerDetails.length,
                itemBuilder: (context, index) {
                  return ListItem(
                    sheetItemHeight: sheetItemHeight,
                    mapVal: currentCar.offerDetails[index],
                  );
                },
              ),
            )
          ],
        ),
      ),

    );
  }

  Widget storyListView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: storyList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            storyViewProfile(storyList[index]['user_id'], context, common);
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
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
                alignment: Alignment.center,
                image: NetworkImage(
                  storyList[index]['profile_pic'],
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  storyViewProfile(id, context, common) {
    var params = "";
    if (id == common.userId)
      params = "action=quickProfile";
    else
      params = "action=quickProfile&user_id=" + id.toString();
    print(params);
    makeGetRequest("user", params, 0, context).then((response) {
      var res = jsonDecode(response);
      var data = res['body'];
      print(data);
      print(data['profile_pic']);
      var gender = "Female.png";
      if (data['gender'] == "male") gender = "male.jpg";
      common.userrelation = data['userRelationship'];
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(
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

  void story() {
     String endPoint = "test/topStories";
      var params = "";
      params = "";
      print(params);
      makeGetRequest(endPoint, params, 0, context).then((response) {
        var data = (response).trim();
        var d2 = jsonDecode(data);
        if (d2['status'] == 0) {
          int bodyLength = d2['body']['topstory'].length;
          if (bodyLength != 0) {
            setState(() {
              storyList = List.from(storyList)
                  ..addAll(d2['body']['topstory']);
            });
          }

        } else if (d2['status'] == 1 && d2['message'] == "Session Expiry") {
          story();
        }
      });
    }
  }

class ListItem extends StatelessWidget {
  final double sheetItemHeight;
  final Map mapVal;

  ListItem({this.sheetItemHeight, this.mapVal});

  @override
  Widget build(BuildContext context) {
    var innerMap;
    bool isMap;
    if (mapVal.values.elementAt(0) is Map) {
      innerMap = mapVal.values.elementAt(0);
      isMap = true;
    } else {
      innerMap = mapVal;
      isMap = false;
    }
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: sheetItemHeight,
      height: sheetItemHeight,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrangeAccent],
          ),
          color: Color(0xff8d7bef),
        borderRadius: BorderRadius.circular(15),
      ),
      //
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          mapVal.keys.elementAt(0),
          isMap
              ? Text(innerMap.keys.elementAt(0),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, letterSpacing: 1.2, fontSize: 11))
              : Container(),
          Text(
            innerMap.values.elementAt(0),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
