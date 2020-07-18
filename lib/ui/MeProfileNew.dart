import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/Imageupload.dart';
import 'package:honeybee/ui/liveroom/profileUi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  var idhide;
  var touserid="";
  var coverPic="";

  DateTime date;
  var _image;
  var _imageCover;
  bool _piccheck = false;
  bool _piccheckCover = false;
  int _radioValue1 = -1;
  bool _visible = false;
  String genderValue;
  File imageURI;
  PageController _pageController = PageController();
  final TextEditingController names = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController referalCode = TextEditingController();
  String _selectedDate = 'Date of Birth';

  Future getImageCover() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    _piccheckCover = true;
    if (image != null) {
      setState(() {
        _imageCover = File(image.path);
      });
    }
  }

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    _piccheck = true;
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2021),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
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
        profilePic = data['profile_pic'];
        names.text = name = data['profileName'];
        coverPic = data['cover_pic'];
        print("coverPic " + coverPic);
        level = data['level'];
        country = data['country'];
        profilePic = data['profile_pic'];
        referalCode.text = refrenceId = data['reference_user_id'];

        if (dob == '0' ||
            dob == '' ||
            dob == '0000-00-00' ||
            dob == null) {
          dob = DateTime.now();
        } else {
         /* date = DateTime.parse(common.date);*/
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
    names.dispose();
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
                            child: (_piccheck == false)
                                ? FittedBox(
                              child: Center(
                                child: Image.network(
                                  profilePic,
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                                : FittedBox(
                              child: Image.file(
                                _image,
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
                         /* getImageCover();*/
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleImageUpload(),
                            ),
                          );
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
                          controller: names,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            labelText: 'Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: referalCode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Referal Code',
                            labelText: 'Refferal Code ',
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
                        padding: EdgeInsets.only(right: 20, bottom: 10),
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width - 40,
                          child: Material(
                            elevation: 10,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(35),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  InkWell(
                                    child: Text(
                                        _selectedDate,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Color(0xFF000000),
                                          fontSize: 16,)
                                    ),
                                    onTap: (){
                                      _selectDate(context);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
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
                            loader = true;
                            var endPoint = 'user/updateProfile';
                            var params;
                            if (_image == null) {
                              params = {

                              };
                              makePostRequest(endPoint, jsonEncode(params), 0,
                                  context)
                                  .then((response) {
                                var data = (response).trim();
                                var d2 = jsonDecode(data);
                                if (d2['status'] == 0) {
                                  Fluttertoast.showToast(msg: d2['message']);
                                  updateProfile();
                                }
                              });
                            } else {
                              params = {

                              };
                              uploadImage(_image, 'user/updateProfile',
                                  jsonEncode(params), 0, context)
                                  .then((response) {
                                var data = (response).trim();
                                var d2 = jsonDecode(data);
                                if (d2['status'] == 0) {
                                  Fluttertoast.showToast(msg: d2['message']);
                                  updateProfile();
                                }
                              });
                            }
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

  dynamic calculateAge(DateTime birthDate) {
    var currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    var month1 = currentDate.month;
    var month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = currentDate.day;
      var day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  dynamic updateProfile() {
    var params = 'action=fullProfile';
    makeGetRequest('user', params, 0, context).then((response) {
      var res = jsonDecode(response);
      var entryList = res['body'].entries.toList();
      for (var j = 0; j < entryList.length; j++) {
        CommonFun().saveShare(entryList[j].key, entryList[j].value.toString());
        switch (entryList[j].key) {
          /*case 'profileName':
            common.profileName = entryList[j].value.toString();
            break;
          case 'profile_pic':
            common.profilePic =
                entryList[j].value.toString() + '?v=' + common.count.toString();
            break;
          case 'gender':
            common.gender = entryList[j].value.toString();
            break;
          case 'country':
            common.country = entryList[j].value.toString();
            break;
          case 'date_of_birth':
            common.date = entryList[j].value.toString();
            break;
          default:*/
        }
      }
      loader = false;
      setState(() {});
      Navigator.of(context).pop();
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

  Widget _editbtn() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 278.0, left: 100.0),
        child: IconButton(
          icon: Icon(
            Icons.camera_enhance,
            color: Colors.black38,
            size: 30.0,
          ),
          onPressed: () {
            getImage();
          },
        ),
      ),
    );
  }
}

