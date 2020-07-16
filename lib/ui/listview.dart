
import 'package:flutter/material.dart';

void main()=> runApp(
    MaterialApp(
      home: Listview(),
      debugShowCheckedModeBanner: false,
    )
);

class Listview extends StatelessWidget {

  String exit_warning = "under Development!!";

  final String pk = 'assets/liveroom/pk.svg';
  final String gallery = 'assets/liveroom/gallery.svg';
  final String music = 'assets/liveroom/music.svg';
  final String games = 'assets/liveroom/games.svg';
  final String heart = 'assets/liveroom/heart.svg';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("List view"),
      ),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          ListTile(
            selected:true,
            leading: CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
             ),
            title: Text("Name 1"),
            subtitle: Text(" ID 150122"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
            ),
            title: Text("Name 2"),
            subtitle: Text(" ID 100122"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading:CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
            ),
            title: Text("Name 3"),
            subtitle: Text(" ID 102122"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
              NetworkImage("https://cdn.pixabay.com/photo/2015/02/04/08/03/baby-623417_960_720.jpg"),
            ),
            title: Text("Name 4"),
              subtitle: Text(" ID 100122"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
            ),
            title: Text("Name 5"),
            subtitle: Text(" ID 100016"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading:CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
            ),
            title: Text("Name 6"),
            subtitle: Text(" ID 100356"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading:CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
            ),
            title: Text("Name 7"),
            subtitle: Text(" ID 100045"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading:CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
            ),
            title: Text("Name 8"),
            subtitle: Text(" ID 100754"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading:CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
            ),
            title: Text("Name 9"),
            subtitle: Text(" ID 100098"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading:CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
            ),
            title: Text("Name 10"),
            subtitle: Text(" ID 100854"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading:CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_EnpIjYdJ6EXvPNdf2AUOntAXLFWwJN2b_OlgrkWiPDyf9KAT&usqp=CAU"),
            ),
            title: Text("Name 11"),
            subtitle: Text(" ID 100583"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              _profileview(context);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
              NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlVxZj9IjLTtsm59zhidbtTHalYlcMJKFkmnvjPpzvd_mpc-hc&usqp=CAU"),
            ),
            title: Text("Name 12"),
            subtitle: Text(" ID 100560"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){

            },
          ),
        ],
      ),
    );
  }

  _profileview(BuildContext context) {
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
                            _asyncSimpleDialog(context);
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

  Future<Dialog> _asyncSimpleDialog(BuildContext context) async {
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