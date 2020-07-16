import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/ui/insta/models/user.dart';
import 'package:honeybee/ui/insta/upload_page.dart';
import 'package:honeybee/ui/postImage.dart';
import 'image_post.dart';
import 'dart:async';
import 'main12.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed>
    with AutomaticKeepAliveClientMixin<Feed>, WidgetsBindingObserver {
  List<ImagePost> feedData;
  File file;
  bool uploading = false;
  Address address;
  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  User currentUserModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    this._loadFeed();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.toString() == 'AppLifecycleState.paused') {}
    if (state.toString() == 'AppLifecycleState.resumed') {
      if (file != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new Uploader1(
            tosearch: file,
          );
        }));
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  buildFeed() {
    print('buildfeed');
    if (feedData != null) {
      return ListView(
        children: feedData,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 10.0,
        centerTitle: true,
        title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('HelloBee Feed'),
            ]),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              print('Click start');
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return new PostImage();
              }));
            },
          ),
        ],
      ),
      body: buildActivityFeed(),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    print(document['mediaUrl']);
    String media = document['mediaUrl'];
    return Container(child: Image.network(media));
  }

  Future<Null> _refresh() async {
    await _getFeed();
    setState(() {});
    return;
  }

  buildActivityFeed() {
    return Container(
      child: FutureBuilder(
          future: _getFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else {
              return ListView(children: snapshot.data);
            }
          }),
    );
  }

  _loadFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("feed");
    if (json != null) {
      List<Map<String, dynamic>> data =
          jsonDecode(json).cast<Map<String, dynamic>>();
      List<ImagePost> listOfPosts = _generateFeed(data);
      setState(() {
        feedData = listOfPosts;
      });
    } else {
      _getFeed();
    }
  }

  _getFeed() async {
    print("Staring getFeed");
    List<ImagePost> items = [];
    var snap =
        await Firestore.instance.collection('insta_posts').getDocuments();
    for (var doc in snap.documents) {
      items.add(ImagePost.fromDocument(doc));
    }
    return items;
  }

  List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
    List<ImagePost> listOfPosts = [];
    for (var postData in feedData) {
      listOfPosts.add(ImagePost.fromJSON(postData));
    }
    return listOfPosts;
  }

  @override
  bool get wantKeepAlive => true;

  void instastoredetails(userid, username, photourl, displayname) async {
    DocumentSnapshot userRecord = await ref.document(userid).get();
    if (userRecord.data == null) {
      ref.document(userid).setData({
        "id": userid,
        "username": username,
        "photoUrl": photourl,
        "email": "emptyurl",
        "displayName": displayname,
        "bio": "",
        "followers": {},
        "following": {},
      });
    }
    userRecord = await ref.document(userid).get();
    currentUserModel = User.fromDocument(userRecord);
    this._loadFeed();
  }

  void instastoredetailsnew() {
    var userid, photourl, displayname, username;
    CommonFun().getStringData('user_id').then((value) {
      userid = value;
      CommonFun().getStringData('profile_pic').then((value) {
        photourl = value;
        CommonFun().getStringData('username').then((value) {
          username = value;
          CommonFun().getStringData('profileName').then((value) {
            displayname = value;
            instastoredetails(userid, username, photourl, displayname);
          });
        });
      });
    });
  }
}
