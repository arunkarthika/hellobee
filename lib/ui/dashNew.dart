
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/database_hepler.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/constant/permision.dart';
import 'package:honeybee/model/gift.dart';
import 'package:honeybee/ui/audio.dart';
import 'package:honeybee/ui/profile.dart';
import 'package:honeybee/ui/story.dart';
import 'package:honeybee/ui/webView.dart';
import 'package:honeybee/utils/string.dart';
import 'dart:async';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';
import 'package:path/path.dart' as p;

class DashboardNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePage();
  }
}

class HomePage extends State<DashboardNew> with TickerProviderStateMixin {
  String api = 'https://blive.s3.ap-south-1.amazonaws.com';
  String _appDocsDir;
  TabController controller, bottomController;
  int merge = 0;
  int page = 1;
  int solopage = 1;
  int audiopage = 1;
  int pkpage = 1;
  int hotpage = 1;
  int screenpage = 1;
  int group3page = 1;
  int group6page = 1;
  int group9page = 1;
  int pageLength = 1;
  int solopageLength = 1;
  int audiopageLength = 1;
  int pkpageLength = 1;
  int hotpageLength = 1;
  int screenpageLength = 1;
  int group3pageLength = 1;
  int group6pageLength = 1;
  int group9pageLength = 1;
  int currentPage = 0;
  List oldList = [];
  var listData = {};
  var userName;
  var userId;
  var profilePic;
  int pageIndex = 0;
  var giftVersion;
  DateTime currentBackPressTime;
  ScrollController soloscrollController = ScrollController();
  ScrollController audioscrollController = ScrollController();
  ScrollController pkscrollController = ScrollController();
  ScrollController hotscrollController = ScrollController();
  ScrollController group3scrollController = ScrollController();
  ScrollController group6scrollController = ScrollController();
  ScrollController group9scrollController = ScrollController();
  ScrollController screenscrollController = ScrollController();
  ScrollController activescrollController = ScrollController();

  List giftData = [];
  List banner = [];
  List solo = [];
  List screenSharing = [];
  List groupof3 = [];
  List groupof6 = [];
  List groupof9 = [];
  List pk = [];
  List audio = [];
  List hotlive = [];
  List activeList = [];
  List giftList = <String>[];
  var db = DatabaseHelper();
  List listDataId = [];
  String globalType = "all";
  String country = "";
  String city = "";

  void path() async {
    if (_appDocsDir == null) {
      _appDocsDir = (await getApplicationDocumentsDirectory()).path;
    }
  }

  Future<bool> _hasToDownloadAssets(String name, String _appDocsDir) async {
    var file = File('$_appDocsDir/$name.zip');
    return !(await file.exists());
  }

  //Gift Download Prosess Start
  Future<void> _downloadAssets(String name) async {
    toast(name, Colors.red);
    if (!await _hasToDownloadAssets(name, _appDocsDir)) {
      toast(_appDocsDir, Colors.amber);
      return;
    }
    toast('$api/$name.zip', Colors.amber);
    var zippedFile =
    await _downloadFile('$api/$name.zip', '$name.zip', _appDocsDir);

    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);

    for (var file in archive) {
      var filename = '$_appDocsDir/${file.name}';
      if (file.isFile) {
        var outFile = File(filename);
        print('File Extract Here:: ' + outFile.path);
        toast("Un Zipping....WOW..!!!!!", Colors.yellow);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }

  Future<File> _downloadFile(
      String url, String filename, String _appDocsDir) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$_appDocsDir/$filename');
    toast("File Started to Download..", Colors.green);
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
    soloscrollController.dispose();
    audioscrollController.dispose();
    pkscrollController.dispose();
    hotscrollController.dispose();
    group3scrollController.dispose();
    group6scrollController.dispose();
    group9scrollController.dispose();
    screenscrollController.dispose();
    activescrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Wakelock.disable();
    path();
    dataGet();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.deepOrange,
      statusBarBrightness: Brightness.dark,
    ));

    _storagepermissionstore();
    controller = TabController(length: 3, vsync: this);
    bottomController = TabController(length: 4, vsync: this);
    bottomController.addListener(_handleTabSelection);
    soloscrollController.addListener(() {
      if (soloscrollController.position.pixels ==
          soloscrollController.position.maxScrollExtent) {
        if (solopage <= solopageLength) {
          solopage++;
          dataProccessor(0, "solo");
        }
      }
    });
    screenscrollController.addListener(() {
      if (screenscrollController.position.pixels ==
          screenscrollController.position.maxScrollExtent) {
        if (screenpage <= screenpageLength) {
          screenpage++;
          dataProccessor(0, "screenSharing");
        }
      }
    });
    audioscrollController.addListener(() {
      if (audioscrollController.position.pixels ==
          audioscrollController.position.maxScrollExtent) {
        if (audiopage <= audiopageLength) {
          audiopage++;
          dataProccessor(0, "audio");
        }
      }
    });
    group3scrollController.addListener(() {
      if (group3scrollController.position.pixels ==
          group3scrollController.position.maxScrollExtent) {
        if (group3page <= group3pageLength) {
          group3page++;
          dataProccessor(0, "groupof3");
        }
      }
    });
    group6scrollController.addListener(() {
      if (group6scrollController.position.pixels ==
          group6scrollController.position.maxScrollExtent) {
        if (group6page <= group6pageLength) {
          group6page++;
          dataProccessor(0, "groupof6");
        }
      }
    });
    group9scrollController.addListener(() {
      if (group9scrollController.position.pixels ==
          group9scrollController.position.maxScrollExtent) {
        if (group9page <= group9pageLength) {
          group9page++;
          dataProccessor(0, "groupof6");
        }
      }
    });
    hotscrollController.addListener(() {
      if (hotscrollController.position.pixels ==
          hotscrollController.position.maxScrollExtent) {
        if (hotpage <= hotpageLength) {
          hotpage++;
          dataProccessor(0, "hotlive");
        }
      }
    });
    activescrollController.addListener(() {
      if (activescrollController.position.pixels ==
          activescrollController.position.maxScrollExtent) {
        if (page <= pageLength) {
          page++;
          dataProccessor(0, "all");
        }
      }
    });
    dataProccessor(0, globalType);
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
        type +
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
            if (type == "solo" || type == "universal" || merge == 0) {
              solopageLength = d2['body']['solo_page'];
              solo = List.from(solo)
                ..addAll(d2['body']['active_user_details']['soloLists']);
            }
            if (type == "screenSharing" || type == "universal" || merge == 0) {
              screenpageLength = d2['body']['screen_page'];
              screenSharing = List.from(screenSharing)
                ..addAll(
                    d2['body']['active_user_details']['screenSharingLists']);
            }
            if (type == "groupof3" || type == "universal" || merge == 0) {
              group3pageLength = d2['body']['group3_page'];
              groupof3 = List.from(groupof3)
                ..addAll(d2['body']['active_user_details']['groupof3Lists']);
            }
            if (type == "groupof6" || type == "universal" || merge == 0) {
              group6pageLength = d2['body']['group6_page'];
              groupof6 = List.from(groupof6)
                ..addAll(d2['body']['active_user_details']['groupof6Lists']);
            }
            if (type == "groupof9" || type == "universal" || merge == 0) {
              group9pageLength = d2['body']['group9_page'];
              groupof9 = List.from(groupof9)
                ..addAll(d2['body']['active_user_details']['groupof9Lists']);
            }
            if (type == "pk" || type == "universal" || merge == 0) {
              pkpageLength = d2['body']['pk_page'];
              pk = List.from(pk)
                ..addAll(d2['body']['active_user_details']['pkLists']);
            }
            if (type == "audio" || type == "universal" || merge == 0) {
              audiopageLength = d2['body']['audio_page'];
              audio = List.from(audio)
                ..addAll(d2['body']['active_user_details']['audioLists']);
            }
            if (type == "hotlive" || type == "universal" || merge == 0) {
              hotpageLength = d2['body']['hot_page'];
              hotlive = List.from(hotlive)
                ..addAll(d2['body']['active_user_details']['hotliveLists']);
            }
            if (type == "all") {
              activeList = List.from( activeList)
                ..addAll(d2['body']['active_user_details']['allLists']);
              pageLength = d2['body']['last_page'];
            }
            merge = 1;
          });
        }
        Timer(Duration(milliseconds: 500), () {
           dataSlider();
          Timer(Duration(milliseconds: 500), () {
            toast(giftVersion, Colors.red);
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
        dataProccessor(0, globalType);
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
      if (globalType == "universal") {
        solo = [];
        page = 1;
        pageLength = 1;
        screenSharing = [];
        page = 1;
        pageLength = 1;
        groupof3 = [];
        group3page = 1;
        group3pageLength = 1;
        groupof6 = [];
        group6page = 1;
        group6pageLength = 1;
        groupof9 = [];
        group9page = 1;
        group9pageLength = 1;
        pk = [];
        pkpage = 1;
        pkpageLength = 1;
        audio = [];
        audiopage = 1;
        audiopageLength = 1;
        hotlive = [];
        hotpage = 1;
        hotpageLength = 1;
      } else {
        activeList = [];
        page = 1;
        pageLength = 1;
      }
      dataProccessor(1, globalType);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orangeAccent,
        accentColor: Colors.deepOrangeAccent,
        textTheme: GoogleFonts.firaSansCondensedTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routes: <String, WidgetBuilder>{'/dashboard': (context) => DashboardNew()},
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
                      builder: (context) => AudioCall(
                          userId1: userId,
                          broadcasterId1: userId,
                          username1: userName,
                          userType1: "broad",
                          broadcastType1: "audio"
                      ),
                    ),
                  );
                } else {
                  toast("Please Allow the Permission", Colors.red);
                }
              },
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
            body: TabBarView(
              children: <Widget>[
                Scaffold(
                  backgroundColor: Colors.orangeAccent[100],
                  appBar: GradientAppBar(
                    centerTitle: true,
                    backgroundColorStart: const Color(0xFFFF3D00),
                    backgroundColorEnd: const Color(0xFFFF7043),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => AdvancedSearch(),
//                            ),
//                          );
                        },
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: IconButton(
                          icon: Icon(Icons.notifications),
                          onPressed: () {
                            print('Click leading');
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                    ],
                    title: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(fontSize: 16),
                      unselectedLabelStyle: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(fontSize: 14),
                      tabs: <Widget>[
                        Tab(text: "Live"),
                        Tab(text: "Universal"),
                        Tab(text: "Game"),
                      ],
                      controller: controller,
                      onTap: (index) {
                        switch (index) {
                          case 0:
                            globalType = "all";
                            break;
                          case 1:
                            globalType = "universal";
                            break;
                          default:
                        }
                      },
                    ),
                  ),
                  body: Column(
                    children: <Widget>[
                      Story(),
                      Container(
                        width: double.infinity,
                        height: 150,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage('assets/images/one.jpg'),
                                fit: BoxFit.cover
                            )
                        ),
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
                                      image: NetworkImage(
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
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            Center(
                              child: Scaffold(
                                body: RefreshIndicator(
                                  child: Container(
                                    child: dispyActive(
                                        activeList, activescrollController),
                                  ),
                                  onRefresh: refreshFun,
                                ),
                              ),
                            ),
                            Center(
                              child: Scaffold(
                                body: RefreshIndicator(
                                  child: Container(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          dispyUnivers(solo, "Solo",
                                              soloscrollController),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dispyUnivers(audio, "Audio",
                                              audioscrollController),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dispyUnivers(groupof3, "Group 3",
                                              group3scrollController),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dispyUnivers(groupof6, "Group 6",
                                              group6scrollController),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dispyUnivers(groupof9, "Group 9",
                                              group9scrollController),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dispyUnivers(
                                              screenSharing,
                                              "Screen Sharing",
                                              screenscrollController),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dispyUnivers(
                                              pk, "PK", pkscrollController),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dispyUnivers(hotlive, "Hot Live",
                                              hotscrollController),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onRefresh: refreshFun,
                                ),
                              ),
                            ),
                            Center(child: Text("Home Page 3")),
                          ],
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Webview(
                    text: 'https://phalcon.sjhinfotech.com/tooper/index.html',
                    webViewTitle: 'TopperPage',
                  ),
                ),
                Center(
//                  child: TopperStart(),
                ),
                Center(child: Profile()),
              ],
              controller: bottomController,
            ),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: TabBar(
                tabs: [
                  Tab(
                    child: Image(
                      image: bottomController.index == 0
                          ? AssetImage('assets/dashboard/HomeSelected.png')
                          : AssetImage('assets/dashboard/Home.png'),
                      width: 25,
                      height: 25,
                    ),
                  ),
                  Tab(
                    child: Image(
                      image: bottomController.index == 1
                          ? AssetImage('assets/dashboard/ToppersSelected.png')
                          : AssetImage('assets/dashboard/Toppers.png'),
                      width: 25,
                      height: 25,
                    ),
                  ),
                  Tab(
                    child: Image(
                      image: bottomController.index == 2
                          ? AssetImage('assets/dashboard/ToppersSelected.png')
                          : AssetImage('assets/dashboard/Toppers.png'),
                      width: 25,
                      height: 25,
                    ),
                  ),
                  Tab(
                    child: Image(
                      image: bottomController.index == 3
                          ? AssetImage('assets/dashboard/ProfileSelected.png')
                          : AssetImage('assets/dashboard/Profile.png'),
                      width: 25,
                      height: 25,
                    ),
                  )
                ],
                controller: bottomController,
                onTap: (indexs) {
                  print(indexs);
                  setState(() {
                    pageIndex = indexs;
                  });
                },
                indicatorColor: Colors.grey,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dispyUnivers(list, name, viewController) {
    return list.length != 0
        ? Container(
      height: 250,
      width: double.infinity,
         child: Column(
          children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.black,
            ),
            child: Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(color: Colors.white, fontSize: 12),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                scrollDirection: Axis.horizontal,
                controller: viewController,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var live = 'Live';
                  var data = list[index];
                  if (data['status'] == 0) {
                    live = 'offline';
                  }
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 3, right: 3),
                    width: 150,
                    decoration: BoxDecoration(
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
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: NetworkImage(data['profile_pic']),
                        fit: BoxFit.cover,
                      ),
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
                                  builder: (context) => AudioCall(
                                    userId1: userId,
                                    broadcasterId1:
                                    data["user_id"].toString(),
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
                          left: 2,
                          right: 2,
                          bottom: 0,
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
                              padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                              alignment: Alignment.center,
                              child: Text(
                                data['profileName'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle
                                    .copyWith(
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          left: 5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEC008C),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              width: 30,
                              alignment: Alignment.center,
                              child: Text(
                                live,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle
                                    .copyWith(
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 5,
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
                                    data['viewer_count'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle
                                        .copyWith(
                                        color: Colors.white,
                                        fontSize: 12),
                                  ),
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
            ),
          )
        ],
      ),
    )
        : Container();
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
              margin: EdgeInsets.only(top: 1, bottom: 1, left: 1, right: 1),
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
                            builder: (context) => AudioCall(
                              userId1: userId,
                              broadcasterId1:
                              data["user_id"].toString(),
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
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
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
                        color: const Color(0xFFEC008C),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Text(
                          live,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 15,
                    child: Container(
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.purple),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 10,
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(
                                "assets/images/dashboard/Group3.png",
                              ),
                              width: 15,
                              height: 15,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              data['viewer_count'],
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(
                                  color: Colors.white, fontSize: 8),
                            ),
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
}
