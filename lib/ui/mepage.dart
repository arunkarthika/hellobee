
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/utils/string.dart';

void main() => runApp(new MeProfile());

class MeProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MEpage(),
    );
  }
}

class MEpage extends StatefulWidget {
  _Mepage createState() => _Mepage();
}

class _Mepage extends State<MEpage> {

  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController referalCode = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController bio = TextEditingController();

  int _radioValue1 = -1;
  String genderValue;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue1 = value;
      print("----------------");
      print(value);
      if(value == 1){
        genderValue = _radioValue1.toString();
        genderValue ="male";
      }else{
        genderValue = _radioValue1.toString();
        genderValue ="female";
      }
    });
  }
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: null,
      body: new ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              Container(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(child:
                        Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://images.pexels.com/photos/1308881/pexels-photo-1308881.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500')
                            )
                        ),
                      ),)
                    ],
                    ),
                    Positioned(
                      top: 120.0,
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage('https://i.pinimg.com/originals/0b/c0/be/0bc0be8eebb2988d7dd5b814e8d04173.jpg'),
                            ),
                            border: Border.all(
                                color: Colors.white,
                                width: 4.0
                            )
                        ),
                      ),
                    ),
                  ],),
              ),
              SizedBox(height: 40.0,),
               Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: username,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Enter User Name',
                          labelText: 'Username',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: name,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          labelText: 'Enter Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: referalCode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Enter Refferal Code (if any)',
                          labelText: 'Refferal Code (if any)',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: dob,
                        keyboardType: TextInputType.text,
                        onTap: (){
                          _selectDate(context);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Date of Birth',
                          labelText: 'Date of Birth',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: bio,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Enter Bio (optional)',
                          labelText: 'Bio',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: bio,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Country (optional)',
                          labelText: 'Country',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: bio,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'State (optional)',
                          labelText: 'State ',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: bio,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'City (optional)',
                          labelText: 'City',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                          ),
                          Align(
                            alignment: Alignment(-0.9,0.7),
                            child: Text("Gender",
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Radio(
                                value: 0,
                                groupValue: _radioValue1,
                                onChanged: _handleRadioValueChange,
                              ),
                              new Text(
                                'Male',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              new Radio(
                                value: 1,
                                groupValue: _radioValue1,
                                onChanged: _handleRadioValueChange,
                              ),
                              new Text(
                                'Female',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RaisedButton(
                        child: Text("Update Profile"),
                        onPressed: () {
                          Fluttertoast.showToast(msg: profileSuccess);
                        },
                        color: Colors.orange,
                        textColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
                        splashColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
            ],
          )
        ],
      ),
    );
  }

}