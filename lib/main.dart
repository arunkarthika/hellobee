import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'package:honeybee/SplashScreen.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/ui/dashboard.dart';
import 'package:honeybee/ui/loginpage.dart';

void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.pink,
          accentColor: Colors.pinkAccent,
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/check': (BuildContext context) => LoginPage(),
          '/dashboard': (BuildContext context) => Dashboard()
        }
    )
);

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigationPage();
    super.initState();
  }

  void navigationPage() async {
    print("ok");
    var bearer = await CommonFun().getStringData('bearer');
    print('bearer');
    print(bearer);
    if (bearer == null || bearer == "")
      Navigator.of(context).pushReplacementNamed('/check');
    else {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
//        child: new Image.asset('assets/images/BLIVE_NEW.png',
//        width: 250.0, height: 250.0),
    ),
    );
  }
}




















