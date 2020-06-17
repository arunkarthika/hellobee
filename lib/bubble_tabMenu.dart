
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:honeybee/constant/permision.dart';
import 'package:honeybee/ui/liveroom/liveRoom.dart';

class BubbleTabMenu extends StatefulWidget {

  BubbleTabMenu({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomeWidgetState();
  }
}

class HomeWidgetState extends State<BubbleTabMenu> with SingleTickerProviderStateMixin{

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
  List activeList = [];
  ScrollController activescrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        bottom: new TabBar(
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
      body: new TabBarView(
        controller: _tabController,
        children: tabs.map((Tab tab) {
          return new  Center(
            child: Scaffold(
              body: RefreshIndicator(
                child: Container(
                  child: dispyActive(
                      activeList, activescrollController),
                ),
                onRefresh: refreshFun,
              ),
            ),
          );
        }).toList(),
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
                            builder: (context) => LiveRoom(
                              userId1: "userId",
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

  Future<Null> refreshFun() async {
    setState(() {

    });
    return null;
  }
}