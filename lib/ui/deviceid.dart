import 'package:flutter/material.dart';
import 'package:honeybee/widget/circularbutton.dart';
import 'package:honeybee/ui/profilecontainer.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 21.0),
              ProfileContainer(),
              SizedBox(height: 21.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircularButton(
                    title: "wallet",
                    icon: Icons.account_balance_wallet,
                    onTap: () {},
                  ),
                  CircularButton(
                    title: "delivery",
                    icon: Icons.send,
                    onTap: () {},
                  ),
                  CircularButton(
                    number: 11,
                    title: "message",
                    icon: Icons.message,
                    onTap: () {},
                  ),
                  CircularButton(
                    title: "service",
                    icon: Icons.attach_money,
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 18.0),
              ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 3.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: () {},
                      leading: Container(
                        padding: EdgeInsets.all(9.0),
                        decoration: BoxDecoration(
                            color: Color(0xff8d7bef),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.location_on,color: Colors.white),
                      ),
                      title: Text("address"),
                      subtitle: Text("ensure_address"),
                      trailing: IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 3.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: () {},
                      leading: Container(
                        padding: EdgeInsets.all(9.0),
                        decoration: BoxDecoration(
                            color: Color(0xfff468b9),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.lock,color: Colors.white),
                      ),
                      title: Text("privacy"),
                      subtitle: Text("system_permission"),
                      trailing: IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 3.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: () {},
                      leading: Container(
                        padding: EdgeInsets.all(9.0),
                        decoration: BoxDecoration(
                            color: Color(0xffffca59),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.settings,color: Colors.white),
                      ),
                      title: Text("general"),
                      subtitle: Text("functional_settings"),
                      trailing: IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 3.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: () {},
                      leading: Container(
                        padding: EdgeInsets.all(9.0),
                        decoration: BoxDecoration(
                            color: Color(0xff5bd2d4),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.notifications,color: Colors.white),
                      ),
                      title: Text("notification"),
                      subtitle: Text("take_new_in_time"),
                      trailing: IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}