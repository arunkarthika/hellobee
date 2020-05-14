
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/ui/listusers.dart';
import 'package:honeybee/ui/listview.dart';
import 'package:honeybee/ui/mepage.dart';
import 'package:honeybee/ui/settings.dart';
import 'package:honeybee/ui/webView.dart';

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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/profile/ProfileBG.png"),
                    fit: BoxFit.cover,
                  ),
                ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
            height: 160,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (profilePic),),
                              ),
                              title:  profileName == null
                                  ? Text("Name")
                                  : Text(
                                profileName,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: referenceId == null
                                  ? Text("ID :0000")
                                  : Text(
                                "ID: " + referenceId,
                                textAlign: TextAlign.start,
                                style:
                                Theme.of(context).textTheme.subtitle.copyWith(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                               trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MEpage(
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        )),
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                           child: GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Text(" Friends",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(" 580k",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                             onTap: (){
                               Navigator.of(context)
                                   .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                 return new ListUser(type: "friends",title: "Friends");
                               }));
                             },
                            )
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Container(
                            child: GestureDetector(
                              child: Column(
                              children: <Widget>[
                                Text(" Followings",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      " 260k",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                return new ListUser(type: "followers",title: "Followings");
                              }));
                            },
                          )
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Container(
                            child: GestureDetector(
                             child: Column(
                              children: <Widget>[
                                Text("Fans",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                      Text(" 950k",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                             onTap: (){
                               Navigator.of(context)
                                   .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                 return new ListUser(type: "fans",title: "Fans");
                               }));
                            },
                          )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
          ),
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage(
                              "assets/profile/Bgold.png",
                            ),
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '230k',
                          ),
                        ],
                      ),
                      Text("B-Gold"),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage(
                              "assets/profile/diamond.png",
                            ),
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '500',
                          ),
                        ],
                      ),
                      Text("Diamond"),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 230,
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
                    height: 500.0,
                    child: Container(
                      height:250.0,
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white,
                        elevation: 6.0,
                        margin: EdgeInsets.only(right: 15.0, left: 15.0),
                        child: new Wrap(
                          children: <Widget>[
                            new ListTile(
                              leading: SvgPicture.asset(wallet,
                                  width: 30.0,
                                  height: 30.0,
                                  fit: BoxFit.fill,
                              ),
                              title: Text("Wallet"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                String textToSend =
                                    "https://stg.sjhinfotech.com/BliveWeb/purchase/wallet07.php?user_id=100001";
                                Navigator.of(context).push(
                                    MaterialPageRoute<Null>(
                                        builder: (BuildContext context) {
                                          return new Webview(
                                            text: textToSend,
                                            webViewTitle: "Wallet",
                                          );
                                        }));
                              },
                            ),
                            new ListTile(
                              leading: SvgPicture.asset(golds,
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.fill,
                              ),
                              title: Text("Earn Golds"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                  return new Settings();
                                }));
                              },
                            ),
                            new ListTile(
                              leading: SvgPicture.asset(aristocracy,
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.fill,
                              ),
                              title: Text("Aristocracy"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                  return new Settings();
                                }));
                              },
                            ),
                            new ListTile(
                              leading: SvgPicture.asset(store,
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.fill,
                              ),
                              title: Text("Store"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                  return new Settings();
                                }));
                              },
                            ),
                            new ListTile(
                              leading: SvgPicture.asset(medal,
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.fill,
                              ),
                              title: Text("Medal"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                  return new Settings();
                                }));
                              },
                            ),
                            new ListTile(
                              leading: SvgPicture.asset(guild,
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.fill,
                              ),
                              title: Text("Guild"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                  return new Settings();
                                }));
                              },
                            ),
                            new ListTile(
                              leading: SvgPicture.asset(feedback,
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.fill,
                              ),
                              title: Text("Feedback"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                  return new Settings();
                                }));
                              },
                            ),
                            new ListTile(
                              leading: SvgPicture.asset(settings,
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.fill,
                              ),
                              title: Text("Settings"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                                  return new Settings();
                                }));
                              },
                            ),
                          ],
                        ),
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
