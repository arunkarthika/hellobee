import 'dart:io';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/constant.dart';
import 'package:honeybee/ui/loginpage.dart';
import 'package:honeybee/utils/string.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';


//GET Request
makeGetRequest(String endPoint, String params, int woutauth, context) async {
  if (await CommonFun().check()) {
  String username = await CommonFun().getStringData('bearer');
  String password = await CommonFun().getStringData('token');
  String basicAuth ='Basic ' + base64Encode(utf8.encode('$username:$password'));
  String url ='https://phalcon.sjhinfotech.com/Hellobee_phalcon/api/v1/$endPoint?$params';
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
    var urlData = "https://phalcon.sjhinfotech.com/Hellobee_phalcon/api/v1/system/auth";
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
    Fluttertoast.showToast(msg: jsonData['message']);
  }
  print('response.body');
  print(response.body);
  return response.body;
  } else {
    Fluttertoast.showToast(msg: internetConnection);
  }
}

//POST Request
makePostRequest(String endPoint, String params, int woutauth, context) async {
  if (await CommonFun().check()) {
  String username = await CommonFun().getStringData('bearer');
  String password = await CommonFun().getStringData('token');
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  String url = 'https://phalcon.sjhinfotech.com/Hellobee_phalcon/api/v1/$endPoint';
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
        "https://phalcon.sjhinfotech.com/Hellobee_phalcon/api/v1/system/auth";
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
    Fluttertoast.showToast(msg: jsonData['message']);
  }
  return response.body;
  } else {
    Fluttertoast.showToast(msg: internetConnection);
  }
}

//Upload Image
Future uploadImage(File file, endPoint, params, woutauth, context) async {
  if (await CommonFun().check()) {
    var username = await CommonFun().getStringData('bearer');
    var password = await CommonFun().getStringData('token');
    var basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final url = '$domain$endPoint';
    print('url');
    print(url);
    var headers = {'Authorization': basicAuth};
    var stream = http.ByteStream(DelegatingStream(file.openRead()));
    var length = await file.length();
    final multipartRequest = http.MultipartRequest('POST', Uri.parse(url));
    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(http.MultipartFile('profile_pic', stream, length,
        filename: basename(file.path)));
    var data = jsonDecode(params);
    for (var key in data.keys) {
      multipartRequest.fields[key] = data[key];
    }
    var response = await multipartRequest.send();
    var value = await response.stream.bytesToString();
    if (response.statusCode == 401 && woutauth == 0) {
      var json = jsonEncode({'device': 'android'});
      final authEndpoint = 'system/auth';
      final urlData = '$domain$authEndpoint';
      var session = await http.post(Uri.encodeFull(urlData),
          body: jsonDecode(json),
          headers: {'Authorization': 'Bearer $username'});
      if (session.statusCode == 406) {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
              (Route<dynamic> route) => false,
        );
      } else {
        var data = jsonDecode(session.body);
        var token = data['body']['token'];
        CommonFun().saveShare('token', token);
        await uploadImage(file, endPoint, params, 0, context);
      }
    }
    var jsonData = jsonDecode(value);
    if (jsonData['status'] == 1 && jsonData['message'] != 'Session Expiry') {
      Fluttertoast.showToast(msg: jsonData['message']);
    }
    print('data');
    print(value);
    return value;
  } else {
    Fluttertoast.showToast(msg: internetConnection);
  }
}
