import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/ui/liveroom/personalChat/const.dart';
import 'package:honeybee/ui/liveroom/personalChat/full_photo.dart';
import 'package:honeybee/ui/liveroom/personalChat/loading.dart';
import 'package:honeybee/ui/meprofile.dart';
import 'package:honeybee/utils/global.dart';
import 'package:honeybee/widget/mycircleavatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String peergcm;
  final String userid;

  ChatScreen({Key key, @required this.peerId, @required this.peerAvatar, @required this.peerName, @required this.peergcm, @required this.userid})
      : super(key: key);

  @override
  State createState() =>
      ChatScreenState(peerId: peerId, peerAvatar: peerAvatar, peerName: peerName, peergcm: peergcm,userid:userid);
}

class ChatScreenState extends State<ChatScreen> {
  bool _showBottom = false;

  ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar, @required this.peerName, @required this.peergcm, @required this.userid});

  String peerId;
  String userid;
  String peerAvatar;
  String id;
  String peerName;
  String peergcm;

  var listMessage;
  String groupChatId;
  SharedPreferences prefs;
  final Firestore _db = Firestore.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    groupChatId = '';
    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    inputData();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void registerNotification() async{
    _fcm.requestNotificationPermissions();

    _fcm.configure(onMessage: (Map<String, dynamic> message) {
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {

      return;
    }, onLaunch: (Map<String, dynamic> message) {
      return;
    });
    _fcm.getToken().then((token) {
      print("token"+token);
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
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

  void inputData() async {
    var auth=FirebaseAuth.instance;

    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    print('firebaseUID'+uid.toString());
    id=uid;
    readLocal();
    _saveDeviceToken();
  }
  _saveDeviceToken() async {
    // Get the current user
    String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print('fcmtoken'+fcmToken);

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }


  static Future<void> sendNotification(receiver,msg)async{

    var token = receiver;
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

  dynamic readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('firebaseUID') ?? id;
    print('firebaseuid'+id.toString());
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
    await Firestore.instance
        .collection('users')
        .document(id)
        .setData({'chattingWith': peerId});
    setState(() {

    });
  }

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        await uploadFile();
      }
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    var fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var reference = FirebaseStorage.instance.ref().child(fileName);
    var uploadTask = reference.putFile(imageFile);
    var storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      sendNotification(peergcm, content);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      return Row(
        children: <Widget>[
          document['type'] == 0
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  DateFormat('dd MMM kk:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document['timestamp']))),
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .apply(color: Colors.grey),
                ),
                SizedBox(width: 15),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .6),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: myGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  child: Text(
                    document['content'],
                    style: Theme.of(context).textTheme.body2.apply(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
              : document['type'] == 1
              ? Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.pink),
                    ),
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(70.0),
                    decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Image.asset(
                      'assets/images/sticker/img_not_available.jpeg',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FullPhoto(url: document['content'])));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
              : Container(
            child: Image.asset(
              'assets/images/sticker/${document['content']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                    child: MyCircleAvatar(
                      imgUrl: peerAvatar,
                    ))
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            peerName,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width *
                                    .6),
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Color(0xfff9f9f9),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: GestureDetector(
                              onLongPress: (){
                                Clipboard.setData(new ClipboardData(text: document['content'].toString()));

                              },
                              child:Text(


                              document['content'],
                              style:
                              Theme.of(context).textTheme.body1.apply(
                                color: Colors.black87,
                              ),),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document['timestamp']))),
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .apply(color: Colors.grey),
                      ),
                    ],
                  ),
                )
                    : document['type'] == 1
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.pink),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: greyColor2,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Material(
                              child: Image.asset(
                                'assets/images/sticker/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullPhoto(
                                  url: document['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(
                  child: Image.asset(
                    'assets/images/sticker/${document['content']}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance
          .collection('users')
          .document(id)
          .setData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black54),
          title: GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new MeProfile(
                      touserid: userid,
                    );
                  }));

            },

            child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              MyCircleAvatar(
                imgUrl: peerAvatar,
              ),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    peerName,
                    style: Theme.of(context).
                    textTheme.
                    subtitle1
                    .copyWith(color: Colors.black, fontSize: 18),
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "Online",
                    style: Theme.of(context).textTheme.subtitle1.apply(
                      color: myGreen,
                    ),
                  )
                ],
              )
            ],
          ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.phone),
              onPressed: () {
                Fluttertoast.showToast(msg: 'Coming Soon!');
              },
            ),
            IconButton(
              icon: Icon(Icons.videocam),
              onPressed: () {
                Fluttertoast.showToast(msg: 'Coming Soon!');

              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                Fluttertoast.showToast(msg: 'Coming Soon!');
              },
            ),
          ],

        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildListMessage(),
                (isShowSticker ? buildSticker() : Container()),
                buildInputnew(),
              ],
            ),
            buildLoading()
          ],
        ),
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('funny4', 2),
                child: Image.asset(
                  'assets/images/sticker/funny4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny5', 2),
                child: Image.asset(
                  'assets/images/sticker/funny5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny6', 2),
                child: Image.asset(
                  'assets/images/sticker/funny6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('kitty', 2),
                child: Image.asset(
                  'assets/images/sticker/kitty.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny', 2),
                child: Image.asset(
                  'assets/images/sticker/funny.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny1', 2),
                child: Image.asset(
                  'assets/images/sticker/funny1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('tenor', 2),
                child: Image.asset(
                  'assets/images/sticker/tenor.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny2', 2),
                child: Image.asset(
                  'assets/images/sticker/funny2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny3', 2),
                child: Image.asset(
                  'assets/images/sticker/funny3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('funny7', 2),
                child: Image.asset(
                  'assets/images/sticker/funny7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny8', 2),
                child: Image.asset(
                  'assets/images/sticker/funny8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('tenor1', 2),
                child: Image.asset(
                  'assets/images/sticker/tenor1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(3.0),
      height: 280.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildInputnew() {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: 60,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                ],
              ),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.face), onPressed: () {getSticker();}),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      getImage();
                      },
                  ),
                  /*IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {

                    },
                  )*/
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(color: myGreen, shape: BoxShape.circle),
            child: InkWell(
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onTap: () => onSendMessage(textEditingController.text, 0),
            ),
          ),
        ],
      ),
    );
  }

  List<IconData> icons = [
    Icons.image,
    Icons.camera,
    Icons.file_upload,
    Icons.folder,
    Icons.gif
  ];


  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink)))
          : StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.pink)));
          } else {
            listMessage = snapshot.data.documents;

            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }
}