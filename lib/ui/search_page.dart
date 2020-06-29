import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:popup_menu/popup_menu.dart';

class ListPersonPage extends StatefulWidget {
  ListPersonPage({Key key, @required this.tosearch, @required this.touserid})
      : super(key: key);

  final String tosearch;
  final String touserid;

  _ListPersonPageState createState() =>
      _ListPersonPageState(tosearch: tosearch, touserid: touserid);
}

class _ListPersonPageState extends State<ListPersonPage> {
  _ListPersonPageState(
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
  var userId;
  String gender = 'all';
  var types = 'searchList';
  GlobalKey btnKey = GlobalKey();
  var menu = PopupMenu();
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.pink, Colors.green],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  Widget appBarTitle;
  Icon actionIcon = Icon(Icons.search);

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    _filteredList.clear();

    super.dispose();
  }

  @override
  void initState() {
    print('userid');
    print(touserid);
    appBarTitle = Text(tosearch);
    userId = touserid.toString();
    switch (tosearch) {
      case 'Fans':
        types = "fans";
        break;
      case 'Followers':
        types = "followers";
        break;
      case 'Friends':
        types = "friends";
        break;
      case 'Audiences':
        types = "audience";
        break;
      case 'Block List':
        types = 'blocked';
        break;

      default:
        break;
    }
    listData(types, page);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("paginglist" + scrollController.position.toString());
        if (lastpage != page) {
          page++;
          var types = "searchList";
          switch (tosearch) {
            case 'Fans':
              types = "fans";
              break;
            case 'Followers':
              types = "followers";
              break;
            case 'Friends':
              types = "friends";
              break;
            case 'Audiences':
              types = "audience";
              break;
            case 'Block List':
              types = 'blocked';
              break;

            default:
              break;
          }
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
    PopupMenu.context = context;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.deepOrange,
        title: appBarTitle,
        actions: <Widget>[
          types == 'searchList'
              ? IconButton(
                  icon: actionIcon,
                  onPressed: () {
                    setState(() {
                      if (actionIcon.icon == Icons.search) {
                        actionIcon = Icon(Icons.close);
                        appBarTitle = TextField(
                          onEditingComplete: () {
                            _filteredList = [];
                            listData('searchList', page);
                          },
                          controller: controller,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          autofocus: true,
                          cursorColor: Colors.white,
                        );
                      } else {
                        actionIcon = Icon(Icons.search);
                        appBarTitle = Text(tosearch);
                        _filteredList = [];
                        controller.text = '';
                        page = 1;
                        listData('searchList', page);
                      }
                    });
                  },
                )
              : Container(),
          types == 'searchList'
              ? IconButton(
                  key: btnKey,
                  onPressed: customBackground,
                  icon: Icon(Icons.filter_list, color: Colors.white),
                )
              : Container(),
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
                                  if (types == 'blocked') {
                                    userBlockRelation(
                                        _filteredList[index].userrelation,
                                        _filteredList[index].userid,
                                        index,
                                        setState,
                                        context);
                                  } else {
                                    userRelation(
                                      _filteredList[index].userrelation,
                                      _filteredList[index].userid,
                                      index,
                                    );
                                  }
                                },
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                child: Container(
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment(0.8, 0.0),
                                      // 10% of the width, so there are ten blinds.
                                      colors: [Colors.red, Colors.orangeAccent],
                                      // whitish to gray
                                      tileMode: TileMode
                                          .repeated, // repeats the gradient over the canvas
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(80.0)),
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        _filteredList[index].icon,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        _filteredList[index].relationName,
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

  void onClickMenu(MenuItemProvider item) {
    controller.text = '';
    gender = item.menuTitle;
    _filteredList = [];
    page = 1;
    listData('searchList', page);
  }

  dynamic listData(type, page) {
    var endPoint = 'user/List';
    var params = 'length=10&page=$page&user_id=' + userId + '&action=' + type;
    if (type == 'searchList') {
      var search = controller.text == '' || controller.text == null
          ? '1'
          : controller.text;
      endPoint = 'user/search';
      params =
          'length=10&page=$page&gender=' + gender + '&searchTerm=' + search;
    }
    makeGetRequest(endPoint, params, 0, context).then((response) {
      var data = (response).trim();
      var pic = json.decode(data);
      lastpage = pic['body']['last_page'];
      var res = pic['body'][type];
      if (res.length > 0) {
        var indexData = 1;
        for (dynamic v in res) {
          indexData = 1;
          var icon = Icons.add;
          var name = 'Follow';
          if (type == 'blocked') {
            icon = Icons.radio_button_unchecked;
            name = 'Unblock';
          } else {
            var relation = v['userRelation'];
            indexData = v['userRelation'];
            relation = relation ?? 0;
            icon = Icons.add;
            name = 'Follow';
            if (relation == 1) {
              name = 'Unfollow';
              icon = Icons.remove;
            } else if (relation == 3) {
              name = 'Friend';
              icon = Icons.swap_horiz;
            }
          }
          var person = Person(v['profileName'], v['user_id'], v['level'],
              indexData, v['profile_pic'], name, icon);
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

  void userBlockRelation(type, id, index, setState, context) {
    var endPoint = 'user/userRelation';
    var action = '';
    var returnData = '';
    var image = Icons.add;
    var relationInt = 0;
    switch (type) {
      case 0:
        action = 'block';
        image = Icons.radio_button_unchecked;
        returnData = 'Unblock';
        relationInt = 1;
        break;
      case 1:
        action = 'unblock';
        image = Icons.block;
        returnData = 'Block';
        relationInt = 0;
        break;
      default:
    }
    var params = {
      'action': action,
      'user_id': id.toString(),
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      setState(() {
        _filteredList[index].relationName = returnData;
        _filteredList[index].userrelation = relationInt;
        _filteredList[index].icon = image;
      });
    });
  }

  void userRelation(level, id, index) {
    print('level');
    print(level);
    String endPoint = 'user/userRelation';
    var action = "";
    String returnData = "";
    int relationInt = 0;
    IconData icon = Icons.add;
    switch (level) {
      case 0:
        action = "follow";
        returnData = "Unfollow";
        relationInt = 1;
        icon = Icons.remove;
        break;
      case 1:
        action = "unfollow";
        returnData = "Follow";
        icon = Icons.add;
        break;
      case 2:
        action = "follow";
        returnData = "Friends";
        relationInt = 3;
        icon = Icons.swap_horiz;
        break;
      case 3:
        action = "unfollow";
        returnData = "Follow";
        relationInt = 2;
        icon = Icons.add;
        break;
      default:
    }
    var params = {
      "action": action,
      "user_id": id.toString(),
    };
    print(endPoint + jsonEncode(params));
    makePostRequest(endPoint, jsonEncode(params), 0, context)
        .then((response) async {
      setState(() {
        _filteredList[index].relationName = returnData;
        _filteredList[index].userrelation = relationInt;
        _filteredList[index].icon = icon;
      });
      print(returnData);
      // relationData = returnData;
      print(relationInt);
      // userrelation = relationInt;
    });
  }

  void customBackground() {
    menu = PopupMenu(
        maxColumn: 3,
        items: [
          MenuItem(
              title: 'Male',
              image: Image.asset('assets/images/audience/male.png')),
          MenuItem(
              title: 'Female',
              image: Image.asset('assets/images/audience/Female.png')),
          MenuItem(
              title: 'All',
              image: Image.asset('assets/images/audience/maleandfemale.png')),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey);
  }

  void stateChanged(bool isShow) {}

  void onDismiss() {}
}

class Person {
  String personFirstName;
  String userid;
  String lvl;
  int userrelation;
  String profilepic;
  String relationName;
  IconData icon;

  Person(this.personFirstName, this.userid, this.lvl, this.userrelation,
      this.profilepic, this.relationName, this.icon);
}
