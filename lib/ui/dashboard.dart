
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/ui/audio.dart';
import 'package:honeybee/ui/dashNew.dart';
import 'package:honeybee/ui/editprofile.dart';
import 'package:honeybee/ui/message.dart';
import 'package:honeybee/ui/story.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/constant/permision.dart';
import 'package:honeybee/utils/string.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.deepOrangeAccent,
          accentColor: Colors.red,
          textTheme: GoogleFonts.firaSansCondensedTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: DashboardView(),
        routes: <String, WidgetBuilder>{
          '/dashboard': (BuildContext context) => Dashboard()
        });
  }
}

class DashboardView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePage();
  }
}

class HomePage extends State<DashboardView> with TickerProviderStateMixin {
  String api = 'https://blive.s3.ap-south-1.amazonaws.com';
  TabController controller, bottomController;

  /*List banner = [
    'https://i.gadgets360cdn.com/large/amazonindia_sale1_1571466846616.jpg'
    'https://lh3.googleusercontent.com/proxy/pthiokKtws5Dvn9EPjoJAH2jVpxvXeQThuLTQ2MznE7_Vp-vR3N0Z6V1d5CGlSeo8wyiZM81lHWVv-KQx59myBbukg23t-zVm_w7FFM_kWjdY851',
    'https://i.gadgets360cdn.com/large/amazonindia_sale1_1571466846616.jpg',
    'https://cdn.grabon.in/gograbon/images/web-images/uploads/1574861413546/cashify-offers.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRaOT0G2rL1N6FaZ_096eiuYFZbbvVhqmB9iAAY0m97YuL7wx3U&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVr6dqR-Z6RnHrmBXqkVxy0SNfRzoX1uVFWZEbcIFyk3HbbIJS&usqp=CAU'
  ];*/

  final List<String> _listItem = [
    'assets/lady/lady1.jpg','assets/lady/lady2.jpg',
    'assets/lady/lady3.png','assets/lady/lady4.jpg',
    'assets/lady/lady1.jpg','assets/lady/lady2.jpg',
    'assets/lady/lady3.png','assets/lady/lady4.jpg',
    'assets/lady/lady1.jpg','assets/lady/lady2.jpg',
  ];

  int page = 1;
  int pageLength = 1;
  List listDataId = [];
  List oldList = [];
  List banner = [];
  var listData;
  var userName;
  var userId;
  var profilePic;
  var giftVersion;
  int pageIndex = 0;
  DateTime currentBackPressTime;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    bottomController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Wakelock.disable();
    controller = TabController(length: 5, vsync: this);
    bottomController = TabController(length: 4, vsync: this);
    bottomController.addListener(_handleTabSelection);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page <= pageLength) {
          page++;
          dataProccessor('user');
        }
      }
    });
    dataGet();
    dataProccessor('user');
    dataSlider();
    ZegoExpressEngine.createEngine(
        1263844657,
        '6fd98a7be6002228918436de65cff64556cc4fb01c88b266f6b3904cd83692e6',
        true,
        ZegoScenario.General,
        enablePlatformView: false);
  }

  void dataGet() async {
    print(await CommonFun().getStringData('bearer'));
    print(await CommonFun().getStringData('token'));
    userName = await CommonFun().getStringData('username');
    userId = await CommonFun().getStringData('user_id');
    print("8888888888888888" + userId.toString());
    profilePic = await CommonFun().getStringData('profile_pic');
    giftVersion = await CommonFun().getStringData('giftVersion');
  }

  void _handleTabSelection() {
    setState(() {});
  }

  dataProccessor(type) {
    String endPoint = type; //'appVersion';
    String params = "action=live_user&page=" +
        page.toString() +
        "&length=10&type=all&geo=all&country=India&city=Coimbatore";
    print('params');
    print(params);
    makeGetRequest(endPoint, params, 0,context).then((response) {
      var data = (response).trim();
      var d2 = jsonDecode(data);
      print(d2);
      if (d2['status'] == 0) {
        setState(() {
          print('listDataId.length');
          print(listDataId.length);
          if (page <= pageLength) {
            oldList = listDataId;
            listDataId = List.from(oldList)
              ..addAll(d2['body']['active_user_Id']);
            // listDataId = d2['body']['active_user_Id'];
            var oldData = listData;
            listData = listData != null
                ? listData.insert(
                oldData.begin(), d2['body']['active_user_details'].end())
                : d2['body']['active_user_details'];
            print(listData);
            pageLength = d2['body']['last_page'];
          }
        });
      } else if (d2['status'] == 1 && d2['message'] == "Session Expiry") {
        dataProccessor('user');
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink,
        accentColor: Colors.pinkAccent,
        textTheme: GoogleFonts.firaSansCondensedTextTheme(
        Theme.of(context).textTheme,
    ),
    ),
    routes: <String, WidgetBuilder>{
     '/dashboard': (BuildContext context) => Dashboard()
    },
      home: WillPopScope(
       onWillPop: onWillPop,
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
              Fluttertoast.showToast(msg: permission_warning);
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: TabBarView(
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.orangeAccent[100],
              appBar: GradientAppBar(
                backgroundColorStart: const Color(0xFFFF3D00),
                backgroundColorEnd: const Color(0xFFFF7043),
                title: TabBar(
                  labelStyle:
                  TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  tabs: <Widget>[
                    Tab(text: "Popular"),
                    Tab(text: "Explore"),
                    Tab(text: "Games"),
                    Tab(text: "PK"),
                    Tab(text: "Hot")
                  ],
                  controller: controller,
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Center(child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Story(),
                        Container(
                          width: double.infinity,
                          height: 150,
                            margin: EdgeInsets.only(top: 8.0),
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
                        SizedBox(height: 15,),
                        Expanded(
                          child: GridView.count(
                            padding: const EdgeInsets.all(5),
                            primary: false,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: 2,
                            controller: _scrollController,
                            children:
                            List.generate(listDataId.length, (index) {
                              var live = 'Live';
                              var data = listData[listDataId[index]];
                              if (data['status'] == 0) {
                                live = 'offline';
                              }
                              return Container(
                                // padding: const EdgeInsets.all(8),
                                child: Stack(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        var camstatus =
                                        await PermissionFun()
                                            .cameraPermision();
                                        var micstatus =
                                        await PermissionFun()
                                            .micPermision();
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
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        child: Image(
                                          image: NetworkImage(
                                            data['profile_pic'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 2,
                                      bottom: 5,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                          BorderRadius.circular(30.0),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              3, 1, 3, 1),
                                          alignment: Alignment.center,
                                          child: Text(
                                            data['profileName'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle
                                                .copyWith(
                                                color: Colors.white,
                                                fontSize: 14),
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
                                          borderRadius:
                                          BorderRadius.circular(30.0),
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
                                       /* decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.purple),
                                          borderRadius:
                                          BorderRadius.circular(30.0),
                                        ),*/
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 20,
                                              alignment: Alignment.center,
                                              child: Image(
                                                image: AssetImage(
                                                  "images/dashboard/Group3.png",
                                                ),
                                                width: 10,
                                                height: 10,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              /*child: Text(
                                                data['viewer_count'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle
                                                    .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),*/
                                              child: Icon(Icons.live_tv, size: 18,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
        ],
      ),
    ),),
                  Center(child: Text("Home Page 2")),
                  Center(child: Text("Home Page 3")),
                  Center(child: Text("Home Page 4")),
                  Center(child: Text("Home Page 5")),
                ],
                controller: controller,
              ),
            ),
            Center(child: EditProfile()),
            Center(child: ChatHome()),
            Center(child: DashboardNew()),
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
    );
  }

  Future<bool> onWillPop() {
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
        //borderRadius: BorderRadius.all(const Radius.circular(10.0)),
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
