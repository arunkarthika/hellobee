
import 'package:flutter/material.dart';
import 'package:honeybee/ui/audio/profileUi.dart';

Widget broadDataLeft(context, common) {
  return Stack(
    children: <Widget>[
      // Container(width: ,)
      Positioned(
        top: 10,
        left: 25,
        child: Container(
          alignment: Alignment.centerRight,
          width: 110,
          height: 30,
          padding: EdgeInsets.only(right: 15, left: 20),
          child: Text(
            common.broadcasterProfileName,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.50),
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            border: Border.all(
              width: 1.5,
              style: BorderStyle.solid,
              color: Colors.orange,
            ),
          ),
        ),
      ),
      Positioned(
        top: 5,
        left: 5,
        child: GestureDetector(
          onTap: () {
            profileview1(common.broadcasterId, context, common);
          },
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                    image: NetworkImage(
                      common.broadprofilePic,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 15,
        left: 140,
        child: Container(
          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          height: 20,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.50),
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            border: Border.all(
              width: 1.5,
              style: BorderStyle.solid,
              color: Colors.orange,
            ),
          ),
          child: Row(
            children: <Widget>[
              Image(
                image: AssetImage(
                  "assets/images/broadcast/Coin.png",
                ),
                width: 10,
                height: 10,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                common.gold.toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.orange, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget audienceListView(common) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    controller: common.scrollController,
    itemCount: common.audiencelist.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () =>
            profileview1(common.audiencelist[index].userId, context, common),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            border: Border.all(
              color: Colors.red,
              width: 2.0,
            ),
            image: DecorationImage(
              image: NetworkImage(
                common.audiencelist[index].profilePic,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    },
  );
}