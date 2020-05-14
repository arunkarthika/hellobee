import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/utils/string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

toast(text, color) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 3,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

makeGetRequest(String endPoint, String params, int woutauth, context) async {
  if (await CommonFun().check()) {
  String username = await CommonFun().getStringData('bearer');
  String password = await CommonFun().getStringData('token');
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  String url =
      'https://phalcon.sjhinfotech.com/blive_phalcon/api/v1/$endPoint?$params';
  var response;
  print(url);
  print(woutauth);
  if (woutauth == 0) {
    response = await http.get(Uri.encodeFull(url), headers: {
      "Content-type": "application/json",
      "Authorization": basicAuth
    });
  } else {
    response = await http.get(Uri.encodeFull(url));
  }
  if (response.statusCode == 401 && woutauth == 0) {
    var json = jsonEncode({'device': 'android'});
    var urlData =
        "https://phalcon.sjhinfotech.com/blive_phalcon/api/v1/system/auth";
    var session = await http.post(Uri.encodeFull(urlData),
        body: jsonDecode(json), headers: {"Authorization": "Bearer $username"});
    if (session.statusCode == 406) {
      Navigator.of(context).pushReplacementNamed('/check');
    } else {
      var data = jsonDecode(session.body);
      var token = data['body']['token'];
      CommonFun().saveShare('token', token);
      makeGetRequest(endPoint, params, 0, context);
    }
  }
  print('response.body');
  print(response.body);
  var jsonData = jsonDecode(response.body);
  if (jsonData['status'] == 1 && jsonData['message'] != "Session Expiry") {
    toast(jsonData['message'], Colors.red);
  }
  print('response.body');
  print(response.body);
  return response.body;
  } else {
    Fluttertoast.showToast(msg: internetConnection);
  }
}

makePostRequest(String endPoint, String params, int woutauth, context) async {
  if (await CommonFun().check()) {
  String username = await CommonFun().getStringData('bearer');
  String password = await CommonFun().getStringData('token');
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  String url = 'https://phalcon.sjhinfotech.com/blive_phalcon/api/v1/$endPoint';
  print(url);
  var response;
  if (woutauth == 0) {
    response = await http.post(Uri.encodeFull(url), body: jsonDecode(params), headers: {
      "Authorization": basicAuth
    });
  } else {
    response = await http.post(Uri.encodeFull(url), body: jsonDecode(params));
  }
  print('response.body');
  print(response.body);
  if (response.statusCode == 401 && woutauth == 0) {
    var json = jsonEncode({'device': 'android'});
    var urlData =
        "https://phalcon.sjhinfotech.com/blive_phalcon/api/v1/system/auth";
    var session = await http.post(Uri.encodeFull(urlData),
        body: jsonDecode(json), headers: {"Authorization": "Bearer $username"});
    if (session.statusCode == 406) {
      Navigator.of(context).pushReplacementNamed('/check');
    } else {
      var data = jsonDecode(session.body);
      var token = data['body']['token'];
      CommonFun().saveShare('token', token);
      makeGetRequest(endPoint, params, 0, context);
    }
  }
  var jsonData = jsonDecode(response.body);
  if (jsonData['status'] == 1 && jsonData['message'] != "Session Expiry") {
    toast(jsonData['message'], Colors.red);
  }
  return response.body;
  } else {
    Fluttertoast.showToast(msg: internetConnection);
  }
}
