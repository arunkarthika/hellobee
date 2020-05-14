
import 'package:flutter/material.dart';
import 'package:honeybee/ui/listusers.dart';
import 'package:honeybee/ui/listview.dart';
import 'package:honeybee/ui/loginpage.dart';
import 'package:honeybee/ui/webView.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(Settings());

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  final titles = [
    'Privacy Settings',
    'Blocked List',
    'Connected Accounts',
    'Suggestions',
    'About Us',
    'Language',
    'Clear Cache',
    'Review Us!',
    'Logout'
  ];

  final icons = [
    Icons.lock,
    Icons.block,
    Icons.account_box,
    Icons.system_update,
    Icons.select_all,
    Icons.language,
    Icons.clear,
    Icons.rate_review,
    Icons.exit_to_app
  ];

  return ListView.builder(
    itemCount: titles.length,
    itemBuilder: (context, index) {
      return Card(
        child: ListTile(
          leading: Icon(icons[index]),
          title: Text(titles[index]),
          trailing: Icon(Icons.keyboard_arrow_right),
          /*onTap: () => Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text(index.toString()))),*/
          onTap: () => onTapped(index, context),
        ),
      );
    },
  );
}

onTapped(post, BuildContext context) {
  String holder;
  holder = post.toString();
  print("switch" + holder);
  switch (holder) {
    case "0":

      break;

    case "1":
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new Listview();
      }));
      break;

    case "2":

      break;

    case "3":
      String textToSend = "https://stg.sjhinfotech.com/BliveWeb/Terms/V1/suggestions.php?user_id=100001";
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Webview(text: textToSend,webViewTitle: "Suggestions",),
          ));
      break;
    case "4":
      String textToSend = "https://stg.sjhinfotech.com/BliveWeb/Terms/V1/aboutus.php";
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Webview(text: textToSend,webViewTitle: "About Us",),
          ));
      break;

    case "5":

      break;

    case "6":

      break;

    case "7":
      StoreRedirect.redirect(
        androidAppId: "com.blive",
        /*iOSAppId: "585027354"*/);
      break;
    case "8":
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
            (Route<dynamic> route) => false,
      );
      break;
  }
}
