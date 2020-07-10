import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/Dashboard.dart';
import 'package:honeybee/ui/liveroom/profileUi.dart';
import 'package:honeybee/utils/string.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class EditProfileNew extends StatefulWidget {
  EditProfileNew({Key key, @required this.touserid,}) : super(key: key);

  final String touserid;

  @override
  _MyAppState createState() => _MyAppState(touserid: touserid);

}

class _MyAppState extends State<EditProfileNew> {

  _MyAppState({Key key, @required this.touserid});

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

  var touserid="";

  var _profilePic;
  var _image;
  int _radioValue1 = -1;
  bool _visible = false;
  PageController _pageController = PageController();

  final TextEditingController names = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController referalCode = TextEditingController();

  String genderValue;
  File imageURI;

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
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

  void dataGet() async {
    touserid = await CommonFun().getStringData('user_id');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                alignment: Alignment.centerLeft,
                overflow: Overflow.visible,
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(child: Container(
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
                    child: GestureDetector(
                    child: Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://images.pexels.com/photos/1308881/pexels-photo-1308881.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500 ')
                          ),
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0
                          )
                      ),
                    ),
                      onTap: (){
                      getImage();
                      },
                    ),
                  ),
                   Positioned(
                    top: -20,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: _editbtn(),
                    ),
                  ),
                  Positioned(
                    top: 30,
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
                            "assets/profile/gallery.png",
                            width: 24,
                            color: Color(0xFFFFFFFF),
                          ), onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return new EditProfileNew(touserid: touserid,);
                                  }));
                        },
                        ),
                      ),
                    ),
                  ),
                ],),
            ),
            Container(
              padding: EdgeInsets.only(top:50.0),
                child: _buildAuthSection()
            ),
          ],
        )
      ),
    );
  }

  Widget _buildAuthSection() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: username,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter User Name',
                            labelText: 'Username',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: names,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            labelText: 'Enter Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: referalCode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Refferal Code (if any)',
                            labelText: 'Refferal Code (if any)',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: referalCode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Reference ID',
                            labelText: 'Reference Id',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: referalCode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Bio',
                            labelText: 'Enter Bio (optional)',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                            ),
                            Align(
                              alignment: Alignment(-0.9, 0.7),
                              child: Text(
                                "Gender",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Radio(
                                  value: 0,
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange,
                                ),
                                Text(
                                  'Male',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Radio(
                                  value: 1,
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange,
                                ),
                                Text(
                                  'Female',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RaisedButton(
                          child: Text("Update"),
                          onPressed: () {
                            dataProccessor(
                                username.text, names.text, referalCode.text);
                          },
                          color: Colors.orange,
                          textColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
                          splashColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageURI = image;
    });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue1 = value;
      print(value);
      if (value == 1) {
        genderValue = _radioValue1.toString();
        genderValue = "male";
      } else {
        genderValue = _radioValue1.toString();
        genderValue = "female";
      }
    });
  }

  Widget _buildHeaderSection() {
    return Stack(
      children: <Widget>[
        Align(
          child: ClipOval(
            child: ClipOval(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: (_image != null)
                    ? Image.file(
                  _image,
                  fit: BoxFit.fill,
                )
                    : Image.network(
                  _profilePic,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _editbtn() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 278.0, left: 100.0),
        child: IconButton(
          icon: Icon(
            Icons.camera_enhance,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
           /* getImage();*/
            Fluttertoast.showToast(msg: exit_warning);
          },
        ),
      ),
    );
  }

  void dataProccessor(String username, String name, String referralcode) {
    setState(() {
      _visible = true;
    });
    referralcode = referralcode == null ? "" : referralcode;
    String endPoint = 'system/register';
    if (_image != null) {
      var params = {
        "action": "register",
        "user_state": "login",
        "screen_id": "1",
        "name": name,
        "username": username,
        "gender": genderValue,
        "referral": referralcode,
        "profile_pic": ""
      };

      uploadImage(_image, endPoint, jsonEncode(params), 1, context)
          .then((response) {
        setState(() {
          _visible = false;
        });
        var data = (response).trim();
        var d2 = jsonDecode(data);
        if (d2['status'] == 0) {
          var entryList = d2['body'].entries.toList();

          for (var j = 0; j < entryList.length; j++) {
            CommonFun()
                .saveShare(entryList[j].key, entryList[j].value.toString());
          }
          CommonFun().saveShare('bearer', d2['body']['activation_code']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
          );
        }
      });
    }else {
      var params = {
        'action': 'register',
        'user_state': 'login',
        'screen_id': '1',
        'name': name.toString(),
        'username': username.toString(),
        'gender': genderValue.toString(),
        'referral': referralcode.toString(),
        'profile_pic': _profilePic.toString(),
      };
      makePostRequest(endPoint, jsonEncode(params), 1, context)
          .then((response) {
        setState(() {
          _visible = false;
        });
        var data = (response).trim();
        var d2 = jsonDecode(data);
        if (d2['status'] == 0) {
          var entryList = d2['body'].entries.toList();

          for (var j = 0; j < entryList.length; j++) {
            CommonFun()
                .saveShare(entryList[j].key, entryList[j].value.toString());
          }
          CommonFun().saveShare('bearer', d2['body']['activation_code']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
          );
        }
      });
    }
  }
}

