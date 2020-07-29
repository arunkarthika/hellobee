import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class CommonFun {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<String> getFutureData(
      String endPoint, String params, int woutauth) async {
    print(endPoint);
    print(params);
    String username = await CommonFun().getStringData('bearer');
    String password = await CommonFun().getStringData('token');
    print(username);
    print(password);
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    String url =
        'https://phalcon.sjhinfotech.com/Hellobee_phalcon/api/v1/$endPoint?$params';
    var response;
    print('url');
    print(url);
    if (woutauth == 0) {
      response = await http.get(Uri.encodeFull(url), headers: {
        "Content-type": "application/json",
        "Authorization": basicAuth
      });
    } else {
      response = await http.get(Uri.encodeFull(url));
    }
    print('response.statusCode');
    print(response.statusCode);
    if (response.statusCode == 401 && woutauth == 0) {
      var json = jsonEncode({'device': 'android'});
      var urlData =
          "https://phalcon.sjhinfotech.com/Hellobee_phalcon/api/v1/system/auth";
      var session = await http.post(Uri.encodeFull(urlData),
          body: jsonDecode(json),
          headers: {"Authorization": "Bearer $username"});
      if (session.statusCode == 406) {
        await CommonFun().navigateTo("/check");
      } else {
        var data = jsonDecode(session.body);
        var token = data['body']['token'];
        CommonFun().saveShare('token', token);
        getFutureData(endPoint, params, 0);
      }
    }
    print('response.body');
    print(response.body);
    return response.body;
  }

  Future<bool> hasToDownloadAssets(String name) async {
    print("==========name================");
    print(name);
    var file = File(name);
    print("==========file================");
    print(file.exists());
    return file.exists();
  }

  //store a shared preference
  saveShare(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }

  //Check Internet Connection
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<String> getStringData(key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  Future<List> getStringListData(key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  //WEBVIEW
  Widget webView(url, _webViewController) {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
      },
    );
  }

  Future<bool> saveImages(String value, key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  //Store Image
  static Future<String> getImages(key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<String> base46String(data) async {
    http.Response response = await http.get(data);
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }
  dynamic downloadFile(String url, String storeName) async {
    var req = await http.Client().get(Uri.parse(url));
    var outFile = File('$storeName');
    outFile = await outFile.create(recursive: true);
    await outFile.writeAsBytes(req.bodyBytes);
  }

//Display Gift
  giftDisplay(image) {
    print(image);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover))),
        ),
      ],
    );
  }
  TextStyle buildTextStyle(BuildContext context, double size,
      FontWeight fontWeight, Color color, FontStyle fontStyle) {
    return Theme.of(context).textTheme.subtitle1.copyWith(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        fontStyle: fontStyle);
  }

}
