
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/MeProfileNew.dart';
import 'package:honeybee/ui/liveroom/personalChat/chat.dart';
import 'package:honeybee/utils/string.dart';
import 'liveroom/profileUi.dart';

class MeProfile extends StatefulWidget {
  MeProfile({Key key, @required this.touserid})
      : super(key: key);

  final String touserid;
  _EditProfileState createState() => _EditProfileState( touserid: touserid);

}

class _EditProfileState extends State<MeProfile>  {
  _EditProfileState({Key key, @required this.touserid});

  UserData uData = UserData();
  var name = "";
  var gender = "";
  var level = "";
  var diamond = "";
  var fans = "";
  var overallgold = "";
  var friends = "";
  var followers = "";
  var country = "";
  bool loader = true;
  var profilePic = "";
  var coverPic = "";
  var refrenceId = "";
  var block = "";
  var status = "";
  var agehide;
  var genderhide;
  var dobhide;
  var dob;
  var age;
  var idhide;
  var touserid="";

  void dataGet() async {
    touserid = await CommonFun().getStringData('user_id');
  }

  @override
  void initState() {
    dataGet();
    var params = "action=fullProfile&user_id=" + touserid.toString();
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
        coverPic = data['cover_pic'];
        name = data['profileName'];
        diamond = data['diamond'];
        friends = data['friends'];
        followers = data['followers'];
        fans = data['fans'];
        overallgold = data['over_all_gold'];
        level = data['level'];
        age = data['age'];
        name = data['profileName'];
        gender = data['gender'];
        country = data['country'];
        profilePic = data['profile_pic'];
        refrenceId = data['reference_user_id'];
        uData.userrelationblock = data['block'];
        uData.userrelation = data['userRelationship'];

        if (uData.userrelationblock == null) uData.userrelationblock = 0;
        uData.relationDataBlock = "Block";
        uData.relationImageblock = Icons.block;
        if (uData.userrelationblock == 1) {
          uData.relationDataBlock = 'UnBlock';
          uData.relationImageblock = Icons.radio_button_unchecked;
        }

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

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: null,
      body: new ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              Container(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(child:
                        Container(
                        height: 250.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(coverPic)
                            )
                        ),
                      ),)
                    ],
                    ),
                    Positioned(
                      top: 180.0,
                      left: 25,
                      child: GestureDetector(
                        child: Container(
                          child: Align(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.black26,
                              child: ClipOval(
                                  child: Center(
                                    child: Image.network(
                                      profilePic,
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ),
                            ),
                          ),
                        ),
                        onTap: (){

                        },
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle),
                          child: InkWell(
                           child: IconButton(
                             alignment: Alignment.topCenter,
                             icon: Image.asset(
                               "assets/profile/edit.png",
                               width: 24,
                               color: Color(0xFFFFFFFF),
                             ), onPressed: () {
                             Navigator.of(context).push(
                                 MaterialPageRoute<Null>(
                                     builder: (BuildContext context) {
                                       return new EditProfileNew(touserid: touserid,);
                                     }));
                           },),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle),
                          child: InkWell(
                           child: IconButton(
                             alignment: Alignment.topCenter,
                             icon: Icon(
                               Icons.more_vert,
                               color: Color(0xFFFFFFFF),
                             ), onPressed: () {
                             Navigator.of(context).push(
                                 MaterialPageRoute<Null>(
                                     builder: (BuildContext context) {
                                       return new EditProfileNew(touserid: touserid,);
                                     }));
                           },),
                        ),
                      ),
                    ),
                  ],),
              ),
              Container(
                alignment: Alignment.topLeft,
                height: 35.0,
                padding: EdgeInsets.only(left:100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    name == null
                        ? Text("Name")
                        : Text(
                      name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left:40.0),
                child: Center(
                    child: refrenceId == null
                        ? Text("ID ")
                        : Text(
                        "ID: " + refrenceId +
                            ' ' +
                            "|" +
                            ' ' +
                            country,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1.
                        apply(color: Colors.orange)
                    )
                ),
              ),
              SizedBox(height: 10.0,),
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
                                Text("↑Level " + level,
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
                                Text("💎 " + diamond,
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
                                Text("⚤" + gender,
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        OutlineButton(
                            padding: EdgeInsets.all(0.0),
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                 Icon(
                                  Icons.message,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                Text(" Chat",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen
                                    (peerId:"0",peerAvatar:profilePic,
                                      peerName:name),
                                ),
                              );
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                        ),
                        OutlineButton(
                            padding: EdgeInsets.all(0.0),
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                 Icon(
                                  uData.relationImage,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                Text(  uData.relationData,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            onPressed: () {
                              userRelation(uData.userrelation, touserid, uData,
                                  setState, context);
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                        ),
                        OutlineButton(
                            padding: EdgeInsets.all(0.0),
                            child: Row(
                              children: <Widget>[
                                 Icon(
                                   uData.relationImageblock,
                                  color: Colors.black38,
                                  size: 18,
                                ),
                                Text( " " + uData.relationDataBlock,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            onPressed: () {
                              userBlockRelation("blockInt", touserid, "common", setState, context);
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
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
                              Text(friends,
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
                              Text(fans,
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
                              Text(followers,
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
                              Text(overallgold,
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
              SizedBox(height: 10.0,),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Image(
                        image: AssetImage(
                          "assets/profile/Medal.png",
                        ),
                        fit: BoxFit.fill,
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(width: 5.0,),
                      Text('Fame Medal',style: TextStyle(
                          fontSize: 18.0
                      ),),
                    ],),
                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.home),
                      SizedBox(width: 5.0,),
                      Text('Reference Id',style: TextStyle(
                          fontSize: 18.0
                      ),),
                      SizedBox(width: 5.0,),
                      Text("100010",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                        ),)
                    ],),
                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(width: 5.0,),
                      Text('From',style: TextStyle(
                          fontSize: 18.0
                      ),),
                      SizedBox(width: 5.0,),
                      Text(country,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                        ),)
                    ],),
                    SizedBox(height: 10.0,),
                    SizedBox(height: 5.0,),
                    Container(
                      height: 10.0,
                      child:
                      Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text('Photos',style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),)),
                    Container(child:
                     Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                              child: Card(
                                child:
                                Image.network('https://images.pexels.com/photos/1580271/pexels-photo-1580271.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                              )
                          ),
                          Expanded(
                              child: Card(
                                child:
                                Image.network('https://desigirlphotos.com/wp-content/uploads/2020/04/pexels-photo-1580274.jpeg'),
                              )
                          )
                        ],),
                        Row(children: <Widget>[
                          Expanded(
                              child: Card(
                                child:
                                Image.network('https://i.pinimg.com/originals/34/61/e6/3461e6bd6413977353c3f66883ad3584.jpg'),
                              )
                          ),
                          Expanded(
                              child: Card(
                                child:
                                Image.network('https://www.desicomments.com/wp-content/uploads/2018/01/Pic-Of-Actress-Kanika-Mann.jpg'),
                              )
                          ),
                          Expanded(
                              child: Card(
                                child:
                                Image.network('https://www.desicomments.com/wp-content/uploads/2018/01/Picture-Of-Kanika-Mann-Looking-Lovely.jpg'),
                              )
                          )
                        ],)
                      ],
                    ),)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void userBlockRelation(type, id, common, setState, context) {
    setState(() {

    });
    var endPoint = 'user/userRelation';
    var action = '';
    var returnData = '';
    var image = Icons.add;
    var relationInt = 0;
    switch (type) {
      case 0:
        action = 'block';
        image = Icons.radio_button_unchecked;
        returnData = 'Unblock';
        relationInt = 1;
        break;
      case 1:
        action = 'unblock';
        image = Icons.block;
        returnData = 'Block';
        relationInt = 0;
        break;
      default:
    }
    var params = {
      'action': action,
      'user_id': id.toString(),
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = jsonDecode(response);
      var message = data['body'];
      Fluttertoast.showToast(msg: message);
      setState(() {
        common.loaderInside = false;
        common.blockStatus = returnData;
        common.blockInt = relationInt;
        common.blockIcon = image;
      });
    });
  }

  _showMoreOption(BuildContext context) {
    showDialog<Dialog>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('Block'),
                onPressed: () {
                  Fluttertoast.showToast(msg: reportMessage);
                },
              ),
              SimpleDialogOption(
                child: const Text('Report'),
                onPressed: () {
                  Fluttertoast.showToast(msg: blockMessage);
                },
              ),
            ],
          );
        });
  }
}