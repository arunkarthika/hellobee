
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/ui/meprofile.dart';
import 'package:honeybee/ui/search_page.dart';
import 'package:honeybee/ui/setting.dart';
import 'package:honeybee/ui/webView.dart';
import 'package:honeybee/utils/string.dart';
import 'package:honeybee/widget/circularbutton.dart';

import 'liveroom/personalChat/home.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Profilepage();
  }
}

class Profilepage extends State<Profile> {
  final color = Colors.pink;
  var profileName="";
  var level="";
  var referenceId="";
  var userid="";
  var profilePic="";
  var diamond="";
  var bGold="";
  var gcm_registration_id="";
  var friends="";
  bool loader = false;

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
    userid = await CommonFun().getStringData('user_id');
    level = await CommonFun().getStringData('level');
    profilePic = await CommonFun().getStringData('profile_pic');
    diamond = await CommonFun().getStringData('diamond');
    bGold = await CommonFun().getStringData('over_all_gold');
    friends = await CommonFun().getStringData('friends');
    gcm_registration_id = await CommonFun().getStringData('gcm_registration_id');

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
            child: profileheader(),
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
                        builder: (context) => HomeScreen(currentUserId: gcm_registration_id),
                      ),
                    );
                  },
                ),
                CircularButton(
                  title: "Wallet",
                  icon: Icons.account_balance_wallet,
                  onTap: () {
                    String textToSend = wallet;
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
                    String textToSend = terms;
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
                    String textToSend = myprgress ;
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
                              onPressed: () {

                              },
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
                              onPressed: () {

                              },
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
                              onPressed: () {

                              },
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
                              onPressed: () {

                              },
                            ),
                          ),
                          new ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(
                                  ),
                                ),
                              );
                            },
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen(
                                    ),
                                  ),
                                );
                              },
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

  Widget profileheader() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.deepOrangeAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(2.3),
                  decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: CircleAvatar(
                    maxRadius: 35.0,
                    backgroundImage: NetworkImage(
                      (profilePic),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new MeProfile(touserid: userid,);
                          }));
                },
              ),
              SizedBox(width: 21),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        profileName == null
                            ? Text("Name")
                            : Text(
                          profileName,
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .apply(fontWeightDelta: 2, color: Colors.white),
                        ),
                        SizedBox(width: 15.0),
                        /*GestureDetector(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onTap: () {},
                        )*/
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        referenceId == null
                            ? Text("ID ")
                            : Text(
                            "ID: " + referenceId,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle.
                            apply(color: Colors.white)
                        ),
                        SizedBox(width: 15.0),
                        GestureDetector(
                          child: level == null
                              ? Text("ID ")
                              : Text(
                              "Lv: " + level,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle.
                              apply(color: Colors.white)
                          ),
                          onTap: () {

                          },
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Column(
                    children: <Widget>[
                      Text(
                        "849",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .apply(color: Colors.white),
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        "Friends",
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ]),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new ListPersonPage(tosearch: "Friends", touserid: userid,);
                          }));
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Text(
                      "51",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .apply(color: Colors.white),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      "Followers",
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new ListPersonPage(tosearch: "Followers", touserid: userid,);
                          }));
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Text(
                      "291",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .apply(color: Colors.white),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      "Fans",
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new ListPersonPage(tosearch: "Fans", touserid: userid,);
                          }));
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    bGold == null
                        ? Text("0")
                        : Text(
                      bGold,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .apply(color: Colors.white),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      "B-Gold",
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                  ],
                ),
                onTap: () {
                  Fluttertoast.showToast(msg: exit_warning);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
