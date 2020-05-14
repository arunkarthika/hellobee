import 'dart:convert';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:honeybee/Constant/common.dart';
import 'package:honeybee/Constant/http.dart';
import 'package:honeybee/ui/adminblock.dart';
import 'package:honeybee/ui/dashboard.dart';
import 'package:honeybee/ui/newuser.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BuildContext context;

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  bool _visible = false;

  void callOldUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Dashboard(),
      ),
          (Route<dynamic> route) => false,
    );
  }

  void callNewUser(name, profilePic, domain, email, mobile) {
    String profileName = name;
    String userName = name;
    String profilepic = profilePic;
    String loginDomain = domain;
    String emailId = email;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => NewUser(
            profileName: profileName,
            userName: userName,
            profilePic: profilepic,
            domain: loginDomain,
            userEmailId: emailId,
            userMobile: mobile),
      ),
          (Route<dynamic> route) => false,
    );
  }

  void dataProccessor(String name, String email, mobile, String profilePic, String domain) {
    setState(() {
      _visible = true;
    });
    String endPoint = 'system/check';
    String params = "login_domain=" +
        domain +
        "&email=" +
        email +
        "&mobile=" +
        mobile +
        "&device_id=0";
    makeGetRequest(endPoint, params, 1,context).then((response) {
      setState(() {
        _visible = false;
      });
      print("object" + response);
      var data = (response).trim();
      var d2 = jsonDecode(data);
      print(d2);
      print(d2['message']);
      if (d2['status'] == 0) {
        if (d2['message'] == "New user") {
          callNewUser(name, profilePic, domain, email, mobile);
        } else {
          var listData = d2['body']['message'];
          if (listData == "Already exsits") {
            print(d2['body']);
            var body = d2['body'];
            var entryList = body.entries.toList();
            for (int j = 0; j < entryList.length; j++) {
              CommonFun()
                  .saveShare(entryList[j].key, entryList[j].value.toString());
            }
            CommonFun().saveShare('bearer', d2['body']['activation_code']);
            callOldUser();
          } else if (listData == "Admin_BlocKEd") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => AdminBlock(),
              ),
                  (Route<dynamic> route) => false,
            );
          }
        }
        return Scaffold();
      } else {
        return Scaffold(
          body: Center(
            child: Text('Loading ...'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      this.context = context;
    });
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login/BG.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Image(
                      width: 160.0,
                      height: 160.0,
                      image: AssetImage(
                        'assets/login/Logo.png',
                      ),
                    )
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 140.0),
                      child: Image(
                        width: 200.0,
                        height: 180.0,
                        image: AssetImage(
                          'assets/login/Logo_text.png',
                        ),
                      )
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GoogleSignInButton(
                        borderRadius: 5.0,
                        text: "Sign in With Google",
                        textStyle: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          FirebaseAuthUi.instance().launchAuth([
                            AuthProvider.google(),
                          ]).then((firebaseUser) {
                            dataProccessor(
                                firebaseUser.displayName,
                                firebaseUser.email,
                                "",
                                firebaseUser.photoUri,
                                "google");
                          });
                        }),
                    FacebookSignInButton(
                        borderRadius: 5.0,
                        text: "Log in with facebook",
                        textStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                        onPressed: () {
                          FirebaseAuthUi.instance().launchAuth([
                            AuthProvider.facebook(),
                          ]).then((firebaseUser) {
                            print("firebaseUser");
                            print(firebaseUser.displayName);
                            print(firebaseUser.email);
                            print(firebaseUser.phoneNumber);
                            print(firebaseUser.photoUri);
                           /*  dataProccessor(
                                 firebaseUser.displayName,
                                 firebaseUser.email,
                                 "",
                                 firebaseUser.photoUri,
                                 "facebook");*/
                          });
                        }),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              Colors.white10,
                              Colors.white,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      width: 100.0,
                      height: 1.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        "or",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: "WorkSansMedium"),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white10,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      width: 100.0,
                      height: 1.0,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 40.0,left: 10.0),
                    child: GestureDetector(
                      onTap: () =>   FirebaseAuthUi.instance().launchAuth([
                        AuthProvider.twitter(),
                      ]).then((firebaseUser) {
                        print("firebaseUser");
                        print(firebaseUser.displayName);
                        print(firebaseUser.email);
                        print(firebaseUser.phoneNumber);
                        print(firebaseUser.photoUri);
                       /*  dataProccessor(
                             firebaseUser.displayName,
                             firebaseUser.email,
                             "",
                             firebaseUser.photoUri,
                             "google");*/
                      }),
                      child: Container(
                          child: Image(
                            width: 40.0,
                            height: 40.0,
                            image: AssetImage(
                              'assets/login/Twitter.png',
                            ),
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 10.0),
                    child: GestureDetector(
                      onTap: () =>  Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewUser(),
                        ),
                            (Route<dynamic> route) => false,
                      ),
                      child: Container(
                          child: Image(
                            width: 40.0,
                            height: 40.0,
                            image: AssetImage(
                              'assets/login/Mobile.png',
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top:80.0,left: 15.0, right: 15.0),
                child: Text(
                  "By Continuing You agree to \n the Terms & Condition",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: "WorkSansMedium"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
