import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/http.dart';
import 'package:honeybee/ui/search_page.dart';

class BLockListPersonPage extends StatefulWidget {
  BLockListPersonPage(
      {Key key, @required this.tosearch, @required this.touserid})
      : super(key: key);

  final String tosearch;
  final String touserid;

  _BLockListPersonPageState createState() =>
      _BLockListPersonPageState(tosearch: tosearch, touserid: touserid);
}

class _BLockListPersonPageState extends State<BLockListPersonPage> {
  _BLockListPersonPageState(
      {Key key, @required this.tosearch, @required this.touserid});

  final String tosearch;
  final String touserid;

  List<Person> _filteredList = [];
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  String filter = "";
  bool isLoading = false;
  int page = 1;
  int lastpage = 0;
  var types;
  var userId;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.pink, Colors.green],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  Widget appBarTitle;
  Icon actionIcon = Icon(Icons.search);

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    // _personList.clear();
    _filteredList.clear();

    super.dispose();
  }

  @override
  void initState() {
    print('userid');
    print(touserid);
    appBarTitle = Text(tosearch);
    userId = touserid.toString();
    types = "blocked";
    listData(types, page);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("paginglist" + scrollController.position.toString());
        if (lastpage != page) {
          page++;
          types = "blocked";
          listData(types, page);
          // } else {
          // toast('you Reached the Last Page', Colors.red);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(Icons.close);
                  this.appBarTitle = TextField(
                    onEditingComplete: () {
                      _filteredList.clear();
                      listData("searchList", page);
                    },
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    autofocus: true,
                    cursorColor: Colors.white,
                  );
                } else {
                  this.actionIcon = Icon(Icons.search);
                  this.appBarTitle = Text(tosearch);
                  _filteredList.clear();
                  controller.clear();
                  listData("searchList", 1);
                }
              });
            },
          ),
        ],
      ),
      body: !isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _filteredList.length > 0
              ? Container(
                  child: ListView.builder(
                    controller: scrollController,
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      // print("_filteredList" + _filteredList[index].relationName);

                      return Card(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  print(
                                      "------------------userid-----------------");
                                  print(_filteredList[index].userid);
//                                  Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                      builder: (context) => FullProfile(
//                                          userId: _filteredList[index].userid),
//                                    ),
//                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      _filteredList[index].profilepic),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(3.0),
                                width: 80,
                                height: 40,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      _filteredList[index].personFirstName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text('ID - ' + _filteredList[index].userid,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Text(
                                '⭐ ' + _filteredList[index].lvl,
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  methodsa(
                                    _filteredList[index].userid,
                                  );
                                },
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                child: Container(
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xFF0D47A1),
                                          Color(0xFF1976D2),
                                          Color(0xFF42A5F5),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(80.0))),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.block,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Unblock",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  child: Center(
                    child: Text("No Data"),
                  ),
                ),
    );
  }

  listData(type, page) {
    String endPoint = "user/List";
    String params =
        "length=10&page=$page&user_id=" + userId + "&action=" + type;
    print(type);
    if (type == "searchList") {
      print("==========controller.text=====================");
      print(controller.text);
      var search = controller.text == "" || controller.text == null
          ? "1"
          : controller.text;
      endPoint = "user/search";
      params = "length=10&page=$page&gender=all&searchTerm=" + search;
      // print(type);
    }
    print(params);
    makeGetRequest(endPoint, params, 0, context).then((response) {
      _filteredList.clear();
      var data = (response).trim();
      var pic = json.decode(data);
      lastpage = pic['body']["last_page"];
      var res = pic['body'][type];
      if (type == "audience") {
        res = pic['body']['audience']['viewers_list'];
      }
      if (res.length > 0) {
        for (dynamic v in res) {
          var relation = v['F'];
          relation = relation == null ? 0 : relation;
          IconData icon = Icons.add;
          var name = "Follow";
          print("relation");
          print(relation);
          if (relation == 1) {
            name = "Unfollow";
            icon = Icons.remove;
          } else if (relation == 3) {
            name = "Friend";
            icon = Icons.swap_horiz;
          }
          Person person = Person(v["profileName"], v["user_id"], v["level"],
              v['userRelation'], v['profile_pic'], name, icon);
          _filteredList.add(person);
        }
      }
      if (page == 1) {
        setState(() {
          isLoading = true;
        });
      }
    });
  }


  void methodsa(id) {
    String endPoint = 'user/userRelation';
    var params = {
      "action": "unblock",
      "user_id": id,
    };
    print(endPoint + jsonEncode(params));
    makePostRequest(endPoint, jsonEncode(params), 0, context)
        .then((response) async {
      print(response);
      setState(() {
        listData(types, page);
      });
    });
  }
}
