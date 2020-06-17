import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/Dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/services.dart';


class NewUser extends StatefulWidget {
  NewUser({
    Key key,
    this.profileName,
    this.userName,
    this.profilePic,
    this.domain,
    this.userEmailId,
    this.userMobile,
  }) : super(key: key);

  final String profileName;
  final String userName;
  final String profilePic;
  final String userEmailId;
  final String domain;
  final String userMobile;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<NewUser> {
  double screenWidth;
  double screenHeight;

  String deviceid;
  String imei;
  String meid;

  var _domain;
  var _email;
  var _mobile;
  int _radioValue1 = -1;
  bool _visible = false;
  PageController _pageController = PageController();

  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController referalCode = TextEditingController();
  String genderValue;
  File imageURI;

  void initDeviceId() {
    setState(() {
      deviceId();
      _domain = widget.domain;
      _email = widget.userEmailId;
      _mobile = widget.userMobile;
      name.text = widget.profileName;
      username.text = widget.userName.replaceAll(' ', '');
    });
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> deviceId() async {

    deviceid = await DeviceId.getID;
    try {
      imei = await DeviceId.getIMEI;
      meid = await DeviceId.getMEID;
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (!mounted) return;

    setState(() {
      //_deviceid = 'Your deviceid: $deviceid\nYour IMEI: $imei\nYour MEID: $meid';
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print("inside okok");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Visibility(
                  visible: _visible,
                  child: Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Container(
                  height: 200.0,
                ),
                Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(100.0),
                      bottomRight: const Radius.circular(100.0),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: _buildHeaderSection(),
                  ),
                ),
              ],
            ),
            _buildAuthSection(),
          ],
        ),
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
      print("----------------");
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
    return GestureDetector(
      onTap: () {
        getImageFromGallery();
      },
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          image: DecorationImage(
            image: AssetImage(
              'assets/images/logo.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
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
                          controller: name,
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
                          child: Text("Create Account"),
                          onPressed: () {
                            dataProccessor(
                                username.text, name.text, referalCode.text);
                          },
                          color: Colors.pink,
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

  void dataProccessor(String username, String name, String referralcode) {
    setState(() {
      _visible = true;
    });
    referralcode = referralcode == null ? "" : referralcode;
    String endPoint = 'system/register';
    var params = {
      "action": "register",
      "user_state": "login",
      "screen_id": "1",
      "name": name,
      "username": username,
      "gender": genderValue,
      "login_domain": _domain,
      "email": _email,
      "mobile": _mobile,
      "device_id": deviceid,
      "referral": referralcode,
      "gcm_registration_id": "0",
      "profile_pic": "",
    };

    print(endPoint + jsonEncode(params));
    makePostRequest(endPoint, jsonEncode(params), 1, context).then((response) {
      setState(() {
        _visible = false;
      });
      var data = (response).trim();
      var d2 = jsonDecode(data);
      if (d2['status'] == 0) {
        var entryList = d2['body'].entries.toList();

        for (int j = 0; j < entryList.length; j++) {
          CommonFun()
              .saveShare(entryList[j].key, entryList[j].value.toString());
        }
        CommonFun().saveShare('bearer', d2['body']['activation_code']);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
              (Route<dynamic> route) => false,
        );
      }
    });
  }
}
