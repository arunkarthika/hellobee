import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/http.dart';

void main() => runApp(Privacy());

class Privacy extends StatefulWidget {
  @override
  State createState() => PrivacyPage();
}

class PrivacyPage extends State<Privacy> {
  bool age = false;
  bool dob = false;
  bool location = false;
  bool gender = false;
  bool userid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy')),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  SwitchListTile(
                    title: Text('Hide Location'),
                    subtitle: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
                    value: location,
                    onChanged: (value) => setState(() => location = value),
                  ),
                  SwitchListTile(
                    title: Text('Hide Age'),
                    subtitle: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
                    value: age,
                    onChanged: (value) => setState(() => age = value),
                  ),
                  SwitchListTile(
                    title: Text('Hide Date of Birth'),
                    subtitle: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
                    value: dob,
                    onChanged: (value) => setState(() => dob = value),
                  ),
                  SwitchListTile(
                    title: Text('Hide ID'),
                    subtitle: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
                    value: userid,
                    onChanged: (value) => setState(() => userid = value),
                  ),
                  SwitchListTile(
                    title: Text('Hide Gender'),
                    subtitle: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
                    value: gender,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                dataProccessor();
              },
              color: Colors.red,
              child: Text(
                "Submit",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  void dataProccessor() {
    int gen = gender == true ? 1 : 0;
    int id = userid == true ? 1 : 0;
    int ages = age == true ? 1 : 0;
    int dateofbirth = dob == true ? 1 : 0;
    int locations = location == true ? 1 : 0;
    String endPoint = 'user/privacy';
    var params = {
      "action": "privacy",
      "reference_user_id": id.toString(),
      "gender": gen.toString(),
      "dob": dateofbirth.toString(),
      "age": ages.toString(),
      "location": locations.toString(),
    };

    print(endPoint + jsonEncode(params));
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = jsonDecode(response);
      if (data['status'] == 0) {
        toast(data['message'], Colors.green);
      }
    });
  }
}
