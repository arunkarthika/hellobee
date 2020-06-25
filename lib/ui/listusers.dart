import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:honeybee/constant/http.dart';

class ListUser extends StatefulWidget {
  final String type;
  final String title;
  ListUser({Key key,this.type,this.title}) : super(key: key);
  ListUser1 createState() => ListUser1(type: type,title: title);
}
class ListUser1 extends State<ListUser> {
  int page = 1;
  final String type;
  final String title;
  ListUser1({Key key, @required this.type,@required this.title});
  List _listUser = [];
  var profilePic;
  @override
  void initState() {
    super.initState();
    listData(type);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: _listUser.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
             /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfile(userId: _listUser[index]['user_id'],),
                  ));*/
            },
            child: Container(
                margin: EdgeInsets.only(),
                height: 80,
                child:Stack(
                  children:[
                    Container(
                      height: 40,
                      width: 40,
                      margin: new EdgeInsets.only(left: 10.0,top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        image: DecorationImage(
                          image: NetworkImage((_listUser[index]['profile_pic']),),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                        top: 20,
                        left: 60,
                        right: 0,
                        child: Row(
                          children: <Widget>[
                            Text(
                              _listUser[index]['profileName'],
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black, height: 1.5),
                            ),
                            Container(
                              margin:EdgeInsets.only(left:5.0),
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                border: Border.all(color: Colors.pink),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Image(
                                      image: AssetImage(
                                        "images/profile/Star.png",
                                      ),
                                      width: 12,
                                      height: 12,
                                    ),
                                  ),
                                  Text(
                                    " "+ _listUser[index]['level'],
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.black, height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ],)
                    ),
                    Positioned(
                      top: 45,
                      left: 80,
                      right: 0,
                      child: Text(
                        "ID "+ _listUser[index]['level'],
                        style: TextStyle(
                            fontSize: 15.0, color: Colors.black, height: 1.5),
                      ),
                    ),
                  ],)
            ),
          );
        },
      ),
      /*ListView(
        padding: EdgeInsets.all(0),
        children: [
          ListTile(
            selected:true,
            leading: CircleAvatar(  child: Text("1"), ),
            title: Text("List Name 1"),
            subtitle1: Text("You can specify subtitle1"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),*/
    );
  }
  listData(type) {
    String endPoint = "user/List";
    String params = "length=20&page=1&type="+type+"&action="+type;
    print(params);
    makeGetRequest(endPoint, params, 0,context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      setState(() {
        _listUser = pic['body'][type];
        print(_listUser);
      });
    });
  }
}