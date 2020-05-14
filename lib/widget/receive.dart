import 'package:flutter/material.dart';
import 'package:honeybee/utils/global.dart';

import 'mycircleavatar.dart';

class ReceivedMessagesWidget1 extends StatelessWidget {
  final int i;
  const ReceivedMessagesWidget1({
    Key key,
    @required this.i,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: <Widget>[
          MyCircleAvatar(
            imgUrl: messages1[i]['contactImgUrl'],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Color(0xfff9f9f9),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  "${messages1[i]['message']}",
                  style: Theme.of(context).textTheme.body1.apply(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }
}
