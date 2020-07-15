import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/liveroom/personalChat/chat.dart';

profileviewAudience(id, context, common) {
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
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                  ),
                                ),
                              );*/
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
                              data['country' ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              OutlineButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text("↑Level " + data['level'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                              ),
                              OutlineButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text("💎 " + data["diamond"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                              ),
                              OutlineButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text("♀ " + data["gender"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                              ),
                            ],
                          ),
                        ],
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
                            label: Text('EndCall',
                              style: TextStyle(color: Colors.black),),
                            icon: Icon(Icons.call_end, color:Colors.redAccent,size: 18,),
                            onPressed: () {
                              Navigator.pop(context,true);
                              common.removeGuest(id, context);
                            },
                          ),
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
                                  builder: (context) => ChatScreen
                                    (peerId:"0",peerAvatar:data['profile_pic'],
                                      peerName:data['profileName']),
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

void userRelation(level, id, common, setState, context) {
  print('level');
  print(level);
  String endPoint = 'user/userRelation';
  var action = "";
  String returnData = "";
  var image = Icons.add;
  int relationInt = 0;
  switch (level) {
    case 0:
      action = "follow";
      image = Icons.remove;
      returnData = "Unfollow";
      relationInt = 1;
      break;
    case 1:
      action = "unfollow";
      image = Icons.add;
      returnData = "Follow";
      relationInt = 0;
      break;
    case 2:
      action = "follow";
      image = Icons.swap_horiz;
      returnData = "Friends";
      relationInt = 3;
      break;
    case 3:
      action = "unfollow";
      image = Icons.add;
      returnData = "Follow";
      relationInt = 2;
      break;
    default:
  }
  var params = {
    "action": action,
    "user_id": id.toString(),
  };
  print(endPoint + jsonEncode(params));
  makePostRequest(endPoint, jsonEncode(params), 0, context)
      .then((response) async {
    if (id == common.broadcasterId) {
      var msgString = "£01relationStatus01£*£" +
          action +
          "£*£" +
          common.userId +
          "£*£" +
          common.name +
          "£*£" +
          common.username +
          "£*£" +
          common.profilePic;
      common.publishMessage(common.broadcastUsername, msgString);
    }
    setState(() {
      print(returnData);
      common.relationData = returnData;
      print(relationInt);
      common.userrelation = relationInt;
      common.relationImage = image;
    });
  });
}

class UserData {
  var relationImage = Icons.add;
  String relationData = "Follow";
  int userrelation = 0;
  String userId;
  String name;
  String username;
  String profilePic;
  String broadcastUsername;
  String broadcasterId;
  UserData();
}

class FullProfile extends StatefulWidget {
  FullProfile({Key key, @required this.userId}) : super(key: key);
  final String userId;

  @override
  _FullProfileState createState() => _FullProfileState(userId: userId);
}

class _FullProfileState extends State<FullProfile> {
  _FullProfileState({Key key, @required this.userId});
  final String userId;

  UserData uData = UserData();
  var name = "";
  var gender = "Female.png";
  var level = "";
  var country = "India";
  bool loader = true;
  var profilePic = "";
  var refrenceId = "";
  var status = "";
  var agehide;
  var genderhide;
  var dobhide;
  var dob;
  var age;
  var idhide;

  @override
  void initState() {
    print(userId);
    var params = "action=fullProfile&user_id=" + userId.toString();
    makeGetRequest("user", params, 0, context).then((response) {
      var res = jsonDecode(response);
      var data = res['body'];
      print(data);
      setState(() {
        status = data['status'];
        dob = data['date_of_birth'];
        age = data['age'];
        agehide = data['is_the_age_hidden'];
        genderhide = data['is_the_gender_hide'];
        dobhide = data['is_the_dob_hidden'];
        idhide = data['is_the_user_id_hidden'];
        profilePic = data['profile_pic'];
        name = data['profileName'];
        gender = "Female.png";
        level = data['level'];
        age = data['age'];
        name = data['profileName'];
        if (data['gender'] == "male") gender = "male.jpg";
        country = data['country'];
        profilePic = data['profile_pic'];
        refrenceId = data['reference_user_id'];
        if (data['gender'] == "male") gender = "male.jpg";
        uData.userrelation = data['userRelationship'];
        if (uData.userrelation == null) uData.userrelation = 0;
        uData.relationData = "Follow";
        uData.relationImage = Icons.add;
        if (uData.userrelation == 1) {
          uData.relationData = 'Unfollow';
          uData.relationImage = Icons.remove;
        } else if (uData.userrelation == 3) {
          uData.relationImage = Icons.swap_horiz;
          uData.relationData = 'Friend';
        }
        loader = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loader == true
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image(
                image: AssetImage(
                  "assets/images/audience/Pink_BG.jpg",
                ),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 175,
                  height: 175,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(profilePic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 230,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      /* style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.white),*/
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    status == "ACTIVE"
                        ? FlatButton(
                      color: Colors.transparent,
                      child: Row(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Text(
                            "Live",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.green),
                          ),
                          Icon(
                            Icons.settings_remote,
                            color: Colors.green,
                          )
                        ],
                      ),
                      onPressed: () {},
                    )
                        : Container()
                  ],
                ),
              ),
            ),
            Positioned(
              top: 270,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "ID" + ' ' + (idhide == 1 ? "PRIVATE" : refrenceId),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  // width: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(children: <Widget>[
                          Container(
                            width: 20,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.orange,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              level,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                color: Colors.white,
                                // fontSize: 12,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 400,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  // width: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "Age",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              agehide == 1 ? "PRIVATE" : age.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "Gender",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            genderhide == 1
                                ? Text(
                              "PRIVATE",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white),
                            )
                                : Image(
                              image: AssetImage(
                                "assets/images/audience/" + gender,
                              ),
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "D.O.B",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              dobhide == 1 ? "PRIVATE" : dob.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    userRelation(uData.userrelation, userId, uData,
                        setState, context);
                  },
                  child: Container(
                    width: 125,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      // color: Colors.pink,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFEC008C),
                          const Color(0xFFFC6767)
                        ],
                      ),
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 20,
                          alignment: Alignment.center,
                          child: Icon(
                            uData.relationImage,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            uData.relationData,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


