import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:honeybee/constant/common.dart';
import 'feed.dart';
import 'upload_page.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_account.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'models/user.dart';

final auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();
final ref = Firestore.instance.collection('insta_users');
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

User currentUserModel;





Future<void> tryCreateUserRecord(BuildContext context) async {
  String userid = await CommonFun().getStringData('user_id');

  DocumentSnapshot userRecord = await ref.document(userid).get();
  if (userRecord.data == null) {
    // no user record exists, time to create

    String userName = await CommonFun().getStringData('username');
    String proname = await CommonFun().getStringData('profileName');
    String propic = await CommonFun().getStringData('profile_pic');

    if (userName != null || userName.length != 0) {
      ref.document(userid).setData({
        "id": userid,
        "username": userName,
        "photoUrl": propic,
        "email": "user.email",
        "displayName": proname,
        "bio": "",
        "followers": {},
        "following": {},
      });
    }
    userRecord = await ref.document(userid).get();
  }

  currentUserModel = User.fromDocument(userRecord);
  return null;
}

class Fluttergram extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonColor: Colors.pink,
          primaryIconTheme: IconThemeData(color: Colors.black)),
      home: HomePage(title: 'Instagram'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

PageController pageController;

class _HomePageState extends State<HomePage> {
  int _page = 0;
  bool triedSilentLogin = false;
  bool setupNotifications = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: Colors.white,
            child: Feed(),
          ),
          Container(
            color: Colors.white,
          ),
          Container(
            color: Colors.white,
            child: Uploader1(),
          ),
          Container(
            color: Colors.white,
          ),
          Container(
            color: Colors.white,
          ),
        ],
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
    );
  }




  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    tryCreateUserRecord(context);

  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
