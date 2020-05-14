import 'package:flutter/material.dart';

class AdminBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Your ID is reset due to inappropriate actions, so your session'
              ' is currently invisible to other viewers. Please login after few minutes. '
              'For more details e-mail to support@blive24hrs.com'
              '. \nNote: Mention your Blive ID and issues faced.\nThank You!'),
        ),
      ),
    );
  }
}