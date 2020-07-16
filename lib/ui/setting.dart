import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:honeybee/ui/Language.dart';
import 'package:honeybee/ui/loginpage.dart';
import 'package:honeybee/utils/string.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Common',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguagesScreen()));
                },
              ),
              SettingsTile(
                  title: 'Blocked List',
                  subtitle: '15 Members',
                  leading: Icon(Icons.cloud_queue),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguagesScreen()));
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(title: 'Connected Accounts',
                  leading: Icon(Icons.phone)),
              SettingsTile(title: 'Review Us!', leading: Icon(Icons.star),
                onTap: () {
                 /* StoreRedirect.redirect(
                    androidAppId: "com.blive",
                  );*/
                },
              ),
              SettingsTile(title: 'Log out', leading: Icon(Icons.exit_to_app),
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Secutiry',
            tiles: [
              SettingsTile.switchTile(
                title: 'Notification',
                leading: Icon(Icons.phonelink_lock),
                switchValue: lockInBackground,
                onToggle: (bool value) {
                  setState(() {
                    lockInBackground = value;
                  });
                },
              ),
              SettingsTile.switchTile(
                title: 'Change Account',
                leading: Icon(Icons.lock),
                switchValue: true,
                onToggle: (bool value) {

                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Misc',
            tiles: [
              SettingsTile(
                  title: 'Terms of Service', leading: Icon(Icons.description),
                onTap: () {
                  Fluttertoast.showToast(msg: under_dev);
                },
              ),
              SettingsTile(
                  title: 'Suggestions', leading: Icon(Icons.description),
                onTap: () {
                  Fluttertoast.showToast(msg: under_dev);
                },
              ),
              SettingsTile(
                  title: 'Clear Cache',
                  leading: Icon(Icons.collections_bookmark),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguagesScreen()));
                },
              ),
              SettingsTile(
                title: 'Feedback',
                leading: Icon(Icons.feedback),
                onTap: () {
                  Fluttertoast.showToast(msg: under_dev);
                },
              ),
              SettingsTile(
                  title: 'About us',
                  leading: Icon(Icons.collections_bookmark),
                onTap: () {
                  Fluttertoast.showToast(msg: under_dev);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LanguagesScreen extends StatefulWidget {
@override
_LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 110,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hello Bee",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Select Language",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Color(0xffa29aac),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                IconButton(
                  alignment: Alignment.topCenter,
                  icon: Image.asset(
                    "assets/notification.png",
                    width: 24,
                  ),
                  onPressed: () {

                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GridDashboard()
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
  }
}
