
import 'package:flutter/material.dart';
import 'package:honeybee/utils/string.dart';

class AudioStory extends StatelessWidget {

  final String heart = 'assets/liveroom/heart.svg';

  final widgets = [
    storyAdd(),
    storyOnline(userProfileUrl1),
    storyOffline(userProfileUrl2),
    storyOnline(userProfileUrl2),
    storyOnline(userProfileUrl1),
    storyOffline(userProfileUrl1),
    storyOffline(userProfileUrl1),
  ];

  final List tags = [
    "↑Lv 10",
    '🌝 Happy face',
    "💎 50K",
    "♀ Male",
    "💐 Life style🤳",
    "Bio: 😚 Forget Whoe Forgets U 👍"
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  static Widget storyAdd() {
    BuildContext context;
    return Padding(
      padding: const EdgeInsets.only(right: 35,top: 10,left: 15),
     child: GestureDetector(
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.only(left: 0),
            child: Image(
              image: AssetImage(
                "assets/broadcast/tropy.png",
              ),
              width: 8,
              height: 8,
            ),
          ),
        ],
      ),
      onTap: (){
       /* profileview(context);*/
      },
    )
    );
  }

  static Widget storyOnline(String img) {
    BuildContext context;
    return Padding(
      padding: const EdgeInsets.only(right: 15,top: 10),
    child: GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      img,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: (){
       /* profileview(context);*/
      },
    )
    );
  }

  static Widget storyOffline(String img) {
    BuildContext context;
    return Padding(
      padding: const EdgeInsets.only(right: 15,top: 10),
      child: GestureDetector(
       child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      img,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
        onTap: (){
        /*  profileview(context);*/
        },
      )
    );
  }

   profileview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: 350,
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 75),
                      height: double.infinity,
                      color: Colors.white,
                    ),
                    Positioned(
                        top: 90,
                        right: 22,
                        child: GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Icon(Icons.report, color: Colors.black)
                                    ),
                                    Text(
                                      " Report",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: (){
                            asyncSimpleDialog(context);
                          },
                        )
                    ),
                    Positioned(
                      top: 25,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://i.pinimg.com/736x/0b/a9/63/0ba963472e12aefd5b6e903f673405c4.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Amelia',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 160,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          "ID" +
                              ' ' +
                              '100025'+
                              ' ' +
                              "|" +
                              ' ' +
                              "India",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 190,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tags.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black)),
                              margin: const EdgeInsets.only(right: 5),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                                child: Text(
                                  tags[index],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 230,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Text("12K",
                                        style: TextStyle(color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,)),
                                    Text("Friends",
                                        style: TextStyle(color: Colors.black,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,)),
                                  ],
                                ),
                                onPressed: () {

                                },
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Text("13K",
                                        style: TextStyle(color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,)),
                                    Text("Fans",
                                        style: TextStyle(color: Colors.black,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,)),
                                  ],
                                ),
                                onPressed: () {

                                },
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Text("9k",
                                        style: TextStyle(color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,)),
                                    Text("Followers",
                                        style: TextStyle(color: Colors.black,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,)),
                                  ],
                                ),
                                onPressed: () {

                                },
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Text("102K",
                                        style: TextStyle(color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,)),
                                    Text("B-Gold",
                                        style: TextStyle(color: Colors.black,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,)),
                                  ],
                                ),
                                onPressed: () {

                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 280,
                      left: 0,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white),
                            ),
                            color: Colors.white,
                            label: Text('Chat',
                              style: TextStyle(color: Colors.black),),
                            icon: Icon(Icons.message, color:Colors.black,size: 18,),
                            onPressed: () {

                            },
                          ),
                          RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.deepOrange),
                            ),
                            color: Colors.deepOrange,
                            splashColor: Colors.yellow[200],
                            animationDuration: Duration(seconds: 4),
                            label: Text('Follow',
                              style: TextStyle(color: Colors.white),),
                            icon: Icon(Icons.add, color:Colors.white,size: 18,),

                            onPressed: ()  {

                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<Dialog> asyncSimpleDialog(BuildContext context) async {
    return await showDialog<Dialog>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('Block'),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('Report'),
              ),
            ],
          );
        });
  }
}