import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/Dashboard.dart';
import 'package:honeybee/ui/liveroom/personalChat/chat.dart';
import 'package:honeybee/ui/liveroom/personalChat/settings.dart';
import 'package:honeybee/utils/global.dart';
import 'package:http/http.dart' as http;


import 'const.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState(currentUserId: currentUserId);
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState({Key key, @required this.currentUserId});

  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  List<Person> filteredList = [];
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  String filter = '';
  int page = 1;
  int lastpage = 0;
  var userId;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.pink, Colors.green],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    Choice(title: 'Settings', icon: Icons.settings),
    Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    sendNotification('receiver','msg');
    CommonFun().getStringData('user_id').then((value) {
      userId = value;
      listData();
    });
    registerNotification();
    configLocalNotification();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (lastpage != page) {
          page++;
          listData();
        }
      }
    });
  }
  static Future<void> sendNotification(receiver,msg)async{

    var token = 'cYoMvZctbiA:APA91bE0lqgwXLBxT6eim_aj5FcjuRZN1xb0ln2UW_fOSJ-pTRedNrpdSIR_hi3Kl5x9kjcvh1FVxilGIhWwyPmAgl1qlYDHr3uc_6Lxk3NRTHjui56oQ1PSumZgSFmeQGY9wwz3JHJq';
    print('token : $token');

    final data = {
      "notification": {"body": msg, "title": "Message From $receiver"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAykcMHoI:APA91bEW9Bh9ysmmZS2hfFzK679_maREiia6IPfzdphBJHIRDz1K7Db2j5PXIpFC8HmcG9dIfFap8HsMC5gWqOJQ1TvKCdLmhTEuNy1hIPiCiVOrbIo4MLB1ACSADznlwLo_5OnVW9gh'
    };

    final postUrl = 'https://fcm.googleapis.com/fcm/send';




    try {
      final response = await http.post(postUrl,
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Request Sent To Driver');
      } else {
        Fluttertoast.showToast(msg: 'notification sending failed');
        print('notification sending failed');
        // on failure do sth
      }
    }
    catch(e){
      print('exception $e');
    }




  }


  void registerNotification() async{
    firebaseMessaging.requestNotificationPermissions();
    print(currentUserId+"success");
    await Firestore.instance.collection('messages').where(
        '100',
        isEqualTo: 'users'
    ).getDocuments().then((event) {
      print('success'+event.documents.length.toString());
      if (event.documents.isNotEmpty) {
        Map<String, dynamic> documentData = event.documents.single.data;//if it is a single document

      }
    }).catchError((e)=> print("error fetching data: $e"));

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print(message);
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print(message);

      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print(message);

      return;
    });
    firebaseMessaging.getToken().then((token) {
      print("token"+token);
//      Firestore.instance
//          .collection('users')
//          .document(currentUserId)
//          .setData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Settings()));
    }
  }

  dynamic listData() {
    var endPoint = 'user/List';
    var params = 'length=10&page=$page&user_id=' + userId + '&action=friends';
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      print('datawillbe' + data.toString());
      var pic = json.decode(data);
      lastpage = pic['body']['last_page'];
      var res = pic['body']['friends'];
      if (res.length > 0) {
        for (dynamic v in res) {
          var relation = v['userRelation'];
          relation = relation ?? 0;
          var icon = Icons.add;
          var name = 'Follow';
          if (relation == 1) {
            name = 'Unfollow';
            icon = Icons.remove;
          } else if (relation == 3) {
            name = 'Friend';
            icon = Icons.swap_horiz;
          }
          var person = Person(
              v['profileName'],
              v['user_id'],
              v['level'],
              v['userRelation'],
              v['profile_pic'],
              name,
              icon,
              v['firebaseUID'],v['gcm_registration_id']);
          filteredList.add(person);
        }
      }
      if (page == 1) {
        setState(() {
          isLoading = true;
        });
      }
    });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  Future<bool> onBackPress() {
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: themeColor,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  Future<Null> handleSignOut() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    setState(() {
      isLoading = false;
    });

    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black45),
        iconTheme: IconThemeData(color: Colors.black45),
        title: Text("Message"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (ctx, i) {
          return Column(
            children: <Widget>[
              ListTile(
                isThreeLine: true,
                onTap: () {
                  print('------------------userid-----------------' +
                      filteredList[i].firebaseId);
                  print(filteredList[i].firebaseId);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(
                                peerId: filteredList[i].firebaseId,
                                peerAvatar: filteredList[i].profilepic,
                                peerName: filteredList[i].personFirstName,
                                peergcm: filteredList[i].gcm_registration_id,
                              )));
                },
                onLongPress: () => Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new ChatScreen();
                })),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.3),
                          offset: Offset(0, 5),
                          blurRadius: 25)
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(filteredList[i].profilepic),
                        ),
                      ),
                      friendsList[i]['isOnline']
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                title: Text(
                  "${filteredList[i].personFirstName}",
                  style: Theme.of(context).textTheme.title,
                ),
                subtitle: Text(
                  "Last MSG",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(color: Colors.black54),
                ),
                trailing: Container(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.check,
                            size: 15,
                          ),
                          Text("6.44 Pm")
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: myGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "13",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider()
            ],
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: Theme.of(context)
              .textTheme
              .subtitle
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return true;
          },
          child: !isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : filteredList.isNotEmpty
                  ? Container(
                      child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: filteredList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: GestureDetector(
                              onTap: () {
                                print(
                                    '------------------userid-----------------' +
                                        filteredList[index].firebaseId);
                                print(filteredList[index].firebaseId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              peerId: filteredList[index]
                                                  .firebaseId,
                                              peerAvatar: filteredList[index]
                                                  .profilepic,
                                              peerName: filteredList[index]
                                                  .personFirstName,
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            filteredList[index].profilepic),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(3.0),
                                      width: 80,
                                      height: 40,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            filteredList[index].personFirstName,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                              'ID - ' +
                                                  filteredList[index].userid,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.pink,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '⭐ ' + filteredList[index].lvl,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..shader = linearGradient),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Text('No Data'),
                      ),
                    )),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: document['photoUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: greyColor,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document['nickname']}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          peerId: document.documentID,
                          peerAvatar: document['photoUrl'],
                      peerName: 'name',
                        )));
          },
          color: Colors.orange,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class Person {
  String personFirstName;
  String gcm_registration_id;
  String userid;
  String lvl;
  int userrelation;
  String profilepic;
  String relationName;
  IconData icon;
  var firebaseId;

  Person(this.personFirstName, this.userid, this.lvl, this.userrelation,
      this.profilepic, this.relationName, this.icon, this.firebaseId, this.gcm_registration_id);
}
