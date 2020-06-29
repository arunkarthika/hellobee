import 'dart:async';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/database_hepler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonDashboard {
  CommonDashboard();
  String api = 'https://blive.s3.ap-south-1.amazonaws.com';
  String appDocsDir;
  String gender;
  String date;
  String domain;
  TabController controller;
  TabController bottomController;
  TabController topperController;
  int merge = 0;
  int page = 1;
  int solopage = 1;
  int audiopage = 1;
  int pkpage = 1;
  int hotpage = 1;
  int screenpage = 1;
  int group3page = 1;
  int group6page = 1;
  int group9page = 1;
  int universpage = 1;
  int pageLength = 1;
  int solopageLength = 1;
  int audiopageLength = 1;
  int pkpageLength = 1;
  int hotpageLength = 1;
  int screenpageLength = 1;
  int group3pageLength = 1;
  int group6pageLength = 1;
  int group9pageLength = 1;
  int universpageLength = 1;
  int currentPage = 0;
  int pkRemainingTime = 0;
  int count = 1;
  var userName;
  var userId;
  List oldList = [];
  var tosearch;
  var profilePic;
  int pageIndex = 0;
  var giftVersion;
  var firebaseId;
  var gcmId;
  var xp;
  DateTime currentBackPressTime;
  ScrollController soloscrollController = ScrollController();
  ScrollController audioscrollController = ScrollController();
  ScrollController pkscrollController = ScrollController();
  ScrollController hotscrollController = ScrollController();
  ScrollController group3scrollController = ScrollController();
  ScrollController group6scrollController = ScrollController();
  ScrollController group9scrollController = ScrollController();
  ScrollController screenscrollController = ScrollController();
  ScrollController profilescrollController = ScrollController();

  ScrollController activescrollController = ScrollController();
  ScrollController universscrollController = ScrollController();

  List<String> imageList = [];
  List giftData = [];
  List banner = [];
  List solo = [];
  List screenSharing = [];
  List groupof3 = [];
  List groupof6 = [];
  List groupof9 = [];
  List pk = [];
  List audio = [];
  List hotlive = [];
  List activeList = [];
  List universList = [];
  List hour = [];
  List day = [];
  List week = [];

  List titles = [
    'Message',
    'Level',
    'Wallet',
    // 'Rewards',
    // 'Check In',
    // 'My Assets',
    'History',
    'FAQ',
    'Like Us!'
  ];

  List listofimages = [
    ('assets/images/profile/Message.png'),
    ('assets/images/profile/Level.png'),
    ('assets/images/profile/Wallet.png'),
    // ('assets/images/profile/Rewards.png'),
    // ('assets/images/profile/Checkin.png'),
    // ('assets/images/profile/MyAssets.png'),
    ('assets/images/profile/MyProgress.png'),
    ('assets/images/profile/Topfans.png'),
    ('assets/images/profile/Star.png'),
  ];

  var db = DatabaseHelper();
  String globalType = 'all';
  String country = '';
  String city = '';
  final color = Colors.pink;
  var profileName;
  var level;
  var referenceId;
  String diamond;
  var bGold;
  var friends;
  var fans;
  var followers;
  bool loader = false;
  String topperTitile = 'World Topper';
  Widget webWidget;
  Completer<WebViewController> webViewController =
      Completer<WebViewController>();

  void dataGet(common, setState) {
    var com = CommonFun();
    com.getStringData('username').then((value) {
      userName = value;
      com.getStringData('user_id').then((value) {
        userId = value;
        com.getStringData('profile_pic').then((value) {
          profilePic = value + '?v=1';
          com.getStringData('giftVersion').then((value) {
            giftVersion = value;
            com.getStringData('country').then((value) {
              country = value;
              com.getStringData('city').then((value) {
                city = value;
                com.getStringData('profileName').then((value) {
                  profileName = value;
                  com.getStringData('reference_user_id').then((value) {
                    referenceId = value;
                    com.getStringData('level').then((value) {
                      level = value;
                      com.getStringData('diamond').then((value) {
                        diamond = value;
                        com.getStringData('over_all_gold').then((value) {
                          bGold = value;
                          com.getStringData('login_domain').then((value) {
                            domain = value;
                            com.getStringData('friends').then((value) {
                              friends = value;
                              com.getStringData('fans').then((value) {
                                fans = value;
                                com.getStringData('followers').then((value) {
                                  followers = value;
                                  com
                                      .getStringData('firebaseUID')
                                      .then((value) {
                                    firebaseId = value;
                                    com
                                        .getStringData('gcm_registration_id')
                                        .then((value) {
                                      gcmId = value;
                                      com
                                          .getStringData('date_of_birth')
                                          .then((value) {
                                        date = value;
                                        com.getStringData('xp').then((value) {
                                          xp = value;
                                          com
                                              .getStringData('gender')
                                              .then((value) {
                                            setState(() {
                                              gender = value;
                                            });
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }
}
