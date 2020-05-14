import 'dart:async';
import 'package:flutter/material.dart';
import 'package:honeybee/ui/audio.dart';

class GoLivemode extends StatefulWidget {
  GoLivemode(
      {Key key,
      @required this.userId,
      @required this.username,
      @required this.profilePic,
      @required this.userType})
      : super(key: key);

  final String userId;
  final String username;
  final String userType;
  final String profilePic;
  RenderBroadcast createState() => RenderBroadcast(
      userId: userId,
      username: username,
      userType: userType,
      profilePic: profilePic);
}

class RenderBroadcast extends State<GoLivemode> with TickerProviderStateMixin {
  RenderBroadcast(
      {Key key,
      @required this.userId,
      @required this.username,
      @required this.profilePic,
      @required this.userType});

  TabController controller, bottomController;
  final String userId;
  final String username;
  final String userType;
  final String profilePic;
  @override
  void dispose() {
    // Dispose of the Tab Controller
    bottomController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the Tab Controller
    bottomController = new TabController(length: 4, vsync: this);
    bottomController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String broadType = "audio";
    return new WillPopScope(
      onWillPop: () {
        print('Backbutton pressed (device or appbar button), do whatever you want.');
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: new FloatingActionButton.extended(
          onPressed: () {
            var obj;
            switch (bottomController.index) {
              case 0:
                broadType = "audio";
                break;
              case 1:
                broadType = "audio";
                break;
              case 2:
                broadType = "audio";
                break;
              case 3:
                broadType = "audio";
                break;
              default:
                broadType = "audio";
                break;
            }
            obj = AudioCall(
                userId1: userId,
                broadcasterId1: userId,
                username1: username,
                userType1: userType,
                broadcastType1: broadType);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => obj));
          },
          label: Text("GO LIVE"),
          backgroundColor: const Color(0xFFFC6767),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: new TabBarView(
          children: <Widget>[
            Container(child: videoPreview()),
            Center(child: videoPreview()),
            Center(child: videoPreview()),
            Center(child: videoPreview())
          ],
          controller: bottomController,
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: new TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                child: Text("Solo"),
              ),
              Tab(
                child: Text("Multi-Guest"),
              ),
              Tab(
                child: Text("Screen Sharing"),
              ),
              Tab(
                child: Text("Audio Call"),
              )
            ],
            controller: bottomController,
            // indicatorColor: Colors.grey,
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget videoPreview() {
    return Stack(
      children: <Widget>[
        Container(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                image: DecorationImage(
                  image: NetworkImage("profilePic"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 10,
          child: GestureDetector(
            child: Image(
              image: AssetImage("assets/images/broadcast/Close.png"),
              width: 15,
              height: 15,
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(
                    "assets/images/broadStart/TurnCamera.png",
                  ),
                  width: 35,
                  height: 35,
                ),
                VerticalDivider(
                  color: Colors.white,
                  thickness: 3.0,
                ),
                Image(
                  image: AssetImage(
                    "assets/images/broadStart/PrivateCall.png",
                  ),
                  width: 35,
                  height: 35,
                ),
                VerticalDivider(
                  color: Colors.white,
                  thickness: 3.0,
                ),
                Image(
                  image: AssetImage(
                    "assets/images/broadStart/Quality.png",
                  ),
                  width: 35,
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
