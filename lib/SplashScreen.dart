import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:honeybee/Constant/constant.dart';
import 'package:honeybee/Constant/common.dart';
import 'package:honeybee/Constant/http.dart';
import 'package:honeybee/Constant/permision.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<SplashScreen> {
  VideoPlayerController playerController;
  VoidCallback listener;

  @override
  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
    initializeVideo();
    playerController.play();

    ///video splash display only 5 second you can change the duration according to your need
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    playerController.setVolume(0.0);
    playerController.removeListener(listener);
    Navigator.of(context).pop(VIDEO_SPALSH);

    var storage = await PermissionFun().storagePermision();
    print(storage);
    if (storage.toString() == "PermissionStatus.granted") {
      var bearer = await CommonFun().getStringData('bearer');
      print('bearer');
      print(bearer);
      if (bearer == null || bearer == "")
        Navigator.of(context).pushReplacementNamed('/check');
      else {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } else {
      toast("Please Allow the Permission", Colors.red);
    }
  }

  void initializeVideo() {
    playerController =
    VideoPlayerController.asset('assets/videos/aeologic_logo.mp4')
      ..addListener(listener)
      ..setVolume(1.0)
      ..initialize()
      ..play();
  }

  @override
  void deactivate() {
    if (playerController != null) {
      playerController.setVolume(0.0);
      playerController.removeListener(listener);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (playerController != null) playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          new AspectRatio(
              aspectRatio: 9 / 16,
              child: Container(
                child: (playerController != null
                    ? VideoPlayer(
                  playerController,
                )
                    : Container()),
              )),
        ]));
  }
}
