
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/ui/listusers.dart';
import 'package:honeybee/ui/listview.dart';
import 'package:honeybee/ui/mepage.dart';
import 'package:honeybee/ui/message.dart';
import 'package:honeybee/ui/profilecontainer.dart';
import 'package:honeybee/ui/settings.dart';
import 'package:honeybee/ui/webView.dart';
import 'package:honeybee/widget/circularbutton.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Profilepage();
  }
}

class Profilepage extends State<Profile> {
  final color = Colors.pink;
  var profileName;
  var level;
  var referenceId;
  var profilePic;
  var diamond;
  var bGold;
  bool loader = false;

  final String wallet = 'assets/profile/Wallet.svg';
  final String golds = 'assets/profile/Coin.svg';
  final String aristocracy = 'assets/profile/Diamond.svg';
  final String store = 'assets/profile/Statistics.svg';
  final String medal = 'assets/profile/Medal.svg';
  final String guild = 'assets/profile/Wallet.svg';
  final String feedback = 'assets/profile/Writing.svg';
  final String settings = 'assets/profile/Setting.svg';

  @override
  void initState() {
    super.initState();
    dataGet();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildTop(context),
          ],
        ),
      ),
    );
  }

  void dataGet() async {
    print(await CommonFun().getStringData('profile_pic'));
    profileName = await CommonFun().getStringData('profileName');
    referenceId = await CommonFun().getStringData('reference_user_id');
    level = await CommonFun().getStringData('level');
    profilePic = await CommonFun().getStringData('profile_pic');
    diamond = await CommonFun().getStringData('diamond');
    bGold = await CommonFun().getStringData('over_all_gold');
    setState(() {
      loader = true;
    });
  }

  Widget buildTop( BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
            height: 190,
            child: ProfileContainer(),
          ),
          Positioned(
            top: 215,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularButton(
                  number: 11,
                  title: "Message",
                  icon: Icons.message,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatHome(
                        ),
                      ),
                    );
                  },
                ),
                CircularButton(
                  title: "Wallet",
                  icon: Icons.account_balance_wallet,
                  onTap: () {
                    String textToSend =
                        "https://phalcon.sjhinfotech.com/BliveWeb/purchase/wallet07.php?user_id=100001" ;
                    Navigator.of(context).push(
                        MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return new Webview(text: textToSend, webViewTitle: "Wallet",);
                            }));
                  },
                ),
                CircularButton(
                  title: "Level",
                  icon: Icons.send,
                  onTap: () {
                    String textToSend =
                        "https://phalcon.sjhinfotech.com/BliveWeb/Terms/V1/level.php?userID=100001" ;
                    Navigator.of(context).push(
                        MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return new Webview(text: textToSend, webViewTitle: "Level",);
                            }));
                  },
                ),

                CircularButton(
                  title: "History",
                  icon: Icons.attach_money,
                  onTap: () {
                    String textToSend =
                        "https://phalcon.sjhinfotech.com/BliveWeb/myProgress/myProgress.php?user_id=100001" ;
                    Navigator.of(context).push(
                        MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return new Webview(text: textToSend, webViewTitle: "History",);
                            }));
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 310,
            left: 0,
            right: 0,
            child: new Stack(
              children: <Widget>[
                new Image.asset(
                  'assets/images/bg.jpeg',
                  fit: BoxFit.fitWidth,
                ),
                new Center(
                  child: new Container(
                    height: 480.0,
                    child: Container(
                      height:150.0,
                        margin: EdgeInsets.only(right: 15.0, left: 15.0),
                        child: new Wrap(
                          children: <Widget>[
                            new ListTile(
                              onTap: () {},
                              leading: Container(
                                padding: EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.deepOrangeAccent],
                                    ),
                                    color: Color(0xff8d7bef),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.location_on,color: Colors.white),
                              ),
                              title: Text("My Assets"),
                              trailing: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                            ),
                            new ListTile(
                              onTap: () {},
                              leading: Container(
                                padding: EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.deepOrangeAccent],
                                    ),
                                    color: Color(0xff8d7bef),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.store,color: Colors.white),
                              ),
                              title: Text("Store"),
                              trailing: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                            ),
                            new ListTile(
                              onTap: () {},
                              leading: Container(
                                padding: EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.deepOrangeAccent],
                                    ),
                                    color: Color(0xff8d7bef),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.location_on,color: Colors.white),
                              ),
                              title: Text("Aristocracy"),
                              trailing: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                            ),
                            new ListTile(
                              onTap: () {},
                              leading: Container(
                                padding: EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.deepOrangeAccent],
                                    ),
                                    color: Color(0xff8d7bef),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.location_on,color: Colors.white),
                              ),
                              title: Text("Medal"),
                              trailing: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                            ),
                            new ListTile(
                              onTap: () {},
                              leading: Container(
                                padding: EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.deepOrangeAccent],
                                    ),
                                    color: Color(0xff8d7bef),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.location_on,color: Colors.white),
                              ),
                              title: Text("Guild"),
                              trailing: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                            ),
                            new ListTile(
                              onTap: () {},
                              leading: Container(
                                padding: EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.deepOrangeAccent],
                                    ),
                                    color: Color(0xff8d7bef),
                                    shape: BoxShape.circle

                                ),
                                child: Icon(Icons.feedback,color: Colors.white),
                              ),
                              title: Text("Feedback"),
                              trailing: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                            ),
                            new ListTile(
                              onTap: () {},
                              leading: Container(
                                padding: EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.deepOrangeAccent],
                                    ),
                                    color: Color(0xff8d7bef),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.settings,color: Colors.white),
                              ),
                              title: Text("Settings"),
                              trailing: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                    ),
                    padding: EdgeInsets.only(bottom: 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
