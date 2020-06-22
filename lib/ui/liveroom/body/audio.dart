import 'package:flutter/material.dart';

import '../footer.dart';

Widget audio(context, setState, common) {
  if (common.c == 0) {
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    common.zego.setCallback(setState);

    if (common.userTypeGlob == "broad") {
      common.zego.playViewWidget = [];
      common.zego.playViewWidget.clear();
      common.zego.setPreview(
          setState, common.broadcasterId.toString(), common.broadcastType);
      common.zego.startPublish(common.broadcasterId.toString());
    }
    print("----------------------------counter " +
        common.c.toString() +
        " ---------------------------");
    common.c++;
  } else {
    print("----------------------------counter " +
        common.c.toString() +
        " ---------------------------");
  }
  return Stack(
    children: <Widget>[
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Image(
          image: AssetImage(
            "assets/broadcast/AudioBG.jpg",
          ),
          fit: BoxFit.cover,
        ),

       /* decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFE51E4D), const Color(0xFF181437)],
            stops: [0.1, 1],
          ),
        ),*/

      ),
      Container(
        margin: EdgeInsets.only(top: 120),
        width: double.infinity,
        height: double.infinity,
        child: GridView.count(
          controller: common.audioScrollcontroller,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 1,
          primary: false,
          crossAxisCount: 4,
          children: List.generate(8, (index) {
            return Container(
              width: 150,
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (common.userTypeGlob == "broad") {
                          print("broad");
                          common.giftUserId = common.guestData[index].userId;
                          giftShow(context, common);
                        } else if (common.guestData.length > index &&
                            common.userTypeGlob != "broad") {
                          giftShow(context, common);
                          common.giftUserId = common.guestData[index].userId;
                        }
                        print(common.giftUserId);
                      });
                    },
                    child: common.guestData.length > index
                        ? Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: NetworkImage(
                                  common.guestData[index].image,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 0, 0, 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Image(
                              image: AssetImage(
                                "assets/broadcast/chair.png",
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  common.guestData.length > index
                      ? Container(
                          child: Text(
                            common.guestData[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.white),
                          ),
                        )
                      : Container(
                          child: Text((++index).toString()),
                        ),
                  common.guestData.length > index
                      ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Text(
                                common.guestData[index].points.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          }),
        ),
      ),
    ],
  );
}