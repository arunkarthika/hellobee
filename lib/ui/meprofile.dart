
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/editMeprofile.dart';
import 'package:honeybee/ui/listview.dart';
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

  final String touserid;

  UserData uData = UserData();
  var name = "";
  var gender = "Female.png";
  var level = "";
  var fans = "";
  var overallgold = "";
  var friends = "";
  var followers = "";
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

  final List tags = [
    "↑Lv 10",
    "💎 50K",
    "♀ Female",
    '🌝 Happy face',
  ];

  @override
  void initState() {
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
        name = data['profileName'];
        friends = data['friends'];
        followers = data['followers'];
        fans = data['fans'];
        overallgold = data['over_all_gold'];
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
                                image: NetworkImage(
                                    'https://images.pexels.com/photos/1308881/pexels-photo-1308881.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500 ')
                            )
                        ),
                      ),)
                    ],
                    ),
                    Positioned(
                      top: 180.0,
                      left: 25,
                      child: Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(profilePic),
                            ),
                            border: Border.all(
                                color: Colors.white,
                                width: 2.0
                            )
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
                             icon: Image.asset(
                               "assets/profile/edit.png",
                               width: 24,
                               color: Color(0xFFFFFFFF),
                             ), onPressed: () {
                             Navigator.of(context).push(
                                 MaterialPageRoute<Null>(
                                     builder: (BuildContext context) {
                                       return new EditProfile(touserid: touserid,);
                                     }));
                           },
                           ),
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
                    /*Icon(Icons.check_circle, color: Colors.blueAccent,)*/
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left:40.0),
                child: Center(
                    child: refrenceId == null
                        ? Text("ID ")
                        : Text(
                        "ID: " + refrenceId+
                            ' ' +
                            "|" +
                            ' ' +
                            "India",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1.
                        apply(color: Colors.orange)
                    )
                ),
              ),
              SizedBox(height: 10.0,),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Listview(),
                              ),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Listview(),
                              ),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Listview(),
                              ),
                            );
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
                      Icon(Icons.person),
                      SizedBox(width: 5.0,),
                      Text('Gender',style: TextStyle(
                          fontSize: 18.0
                      ),),
                      SizedBox(width: 5.0,),
                      Text("FeMale",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                        ),)
                    ],),
                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.home),
                      SizedBox(width: 5.0,),
                      Text('Lives in',style: TextStyle(
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
                    /*    Row(children: <Widget>[
                      Icon(Icons.list),
                      SizedBox(width: 5.0,),
                      Text('Followed by',style: TextStyle(
                          fontSize: 18.0
                      ),),
                      SizedBox(width: 5.0,),
                      Text('100K people',style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),)
                    ],),*/
                    SizedBox(height: 5.0,),
                    /*  Row(children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text('see more..'),
                        ),
                      )
                    ],),*/
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