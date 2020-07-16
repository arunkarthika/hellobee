import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/ui/insta/models/user.dart';
import 'package:honeybee/ui/insta/upload_page.dart';
import 'package:honeybee/ui/postImage.dart';
import 'package:image_picker/image_picker.dart';
import 'image_post.dart';
import 'dart:async';
import 'main12.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

  class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
  }

  class _Feed extends State<Feed>
  with AutomaticKeepAliveClientMixin<Feed>, WidgetsBindingObserver {
  List<ImagePost> feedData;
  File file;
  bool uploading = false;
  Address address;
  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  User currentUserModel;


  @override
  void initState() {
  super.initState();
//  instastoredetailsnew();
  WidgetsBinding.instance.addObserver(this);
  this._loadFeed();


  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state.toString() == 'AppLifecycleState.paused') {}
    if (state.toString() == 'AppLifecycleState.resumed') {
    }
    super.didChangeAppLifecycleState(state);
  }

  buildFeed() {
    print('buildfeed');
    if (feedData != null) {
      return ListView(
        children: feedData,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Activity Feed",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: buildActivityFeed(),
      floatingActionButton: Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFFC6767),
            onPressed: () {
             /* _selectImage(context);*/

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new PostImage();
                  }));

            },
            child: Container(
              /*decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(0.0, 0.0),
                  radius: 0.5,
                  colors: [Colors.orange, Colors.deepOrangeAccent],
                ),
              ),*/
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );

    /*body: Container(
        child: FloatingActionButton(
          onPressed: () {

          },
          child: Icon(Icons.add),
        ),
        child: buildActivityFeed(),
      ),*/

    /*  body: StreamBuilder(
        stream: Firestore.instance.collection('insta_posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink)));
          } else {
            print(snapshot.data.documents.length.toString());

            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
            );
          }
        },
      ),*/
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = imageFile;
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1000,
                      maxHeight: 1000,
                      imageQuality: 80);
                  setState(() {
                    file = imageFile;
                    print('files' + file.length().toString());
                  });

                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    print(document['mediaUrl']);
    String media = document['mediaUrl'];
    return Container(child: Image.network(media));
  }

  Future<Null> _refresh() async {
    await _getFeed();
    setState(() {});
    return;
  }

  buildActivityFeed() {
    return Container(
      child: FutureBuilder(
          future: _getFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else {
              return ListView(children: snapshot.data);
            }
          }),
    );
  }

  _loadFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("feed");

    if (json != null) {
      List<Map<String, dynamic>> data =
          jsonDecode(json).cast<Map<String, dynamic>>();
      List<ImagePost> listOfPosts = _generateFeed(data);
      setState(() {
        feedData = listOfPosts;
      });
    } else {
      _getFeed();
    }
  }

  _getFeed() async {
    print("Staring getFeed");
    List<ImagePost> items = [];
    var snap =
        await Firestore.instance.collection('insta_posts').getDocuments();

    for (var doc in snap.documents) {
      items.add(ImagePost.fromDocument(doc));
    }
    return items;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = googleSignIn.currentUser.id.toString();
    print("Google UserId " + userId);
    var url =
        'https://us-central1-mp-rps.cloudfunctions.net/getFeed?uid=' + userId;
    var httpClient = HttpClient();
    List<ImagePost> listOfPosts;
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      print("responsefeed" + response.toString());
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        prefs.setString("feed", json);
        List<Map<String, dynamic>> data =
            jsonDecode(json).cast<Map<String, dynamic>>();
        listOfPosts = _generateFeed(data);
        result = "Success in http request for feed";
      } else {
        result =
            'Error getting a feed: Http status ${response.statusCode} | userId $userId';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
      print("responsefeed" + exception.toString());
    }
    print(result);

    setState(() {
      feedData = listOfPosts;
    });
  }

  List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
    List<ImagePost> listOfPosts = [];

    for (var postData in feedData) {
      listOfPosts.add(ImagePost.fromJSON(postData));
    }

    return listOfPosts;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;

  void instastoredetails(userid,username,photourl,displayname) async {

    DocumentSnapshot userRecord = await ref.document(userid).get();
    if (userRecord.data == null) {
      print('newuser');
      // no user record exists, time to create
        ref.document(userid).setData({
          "id": userid,
          "username": username,
          "photoUrl": photourl,
          "email": "emptyurl",
          "displayName": displayname,
          "bio": "",
          "followers": {},
          "following": {},
        });
      }
      userRecord = await ref.document(userid).get();
    print('olduser');

    currentUserModel = User.fromDocument(userRecord);
    this._loadFeed();

  }

  void instastoredetailsnew() {
    var userid,photourl,displayname,username;
    CommonFun().getStringData('user_id').then((value) {
      userid = value;
      CommonFun().getStringData('profile_pic').then((value) {
        photourl = value;
        CommonFun().getStringData('username').then((value) {
          username = value;
          CommonFun().getStringData('profileName').then((value) {
            displayname = value;
            instastoredetails(userid,username,photourl,displayname);
          });
        });
      });
    });
    }


  }


/*class Uploader extends StatefulWidget {
  _Uploader createState() => _Uploader();
}

class _Uploader extends State<Uploader> {
  File file;

  //Strings required to save address
  Address address;

  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  bool uploading = false;

  @override
  initState() {
    //variables with location assigned as 0.0
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState(); //method to call location
    super.initState();
  }

  //method to get Location and save into variables
  initPlatformState() async {
    Address first = await getUserLocation();
    setState(() {
      address = first;
    });
  }

  Widget build(BuildContext context) {
    return file == null
        ? IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () => {_selectImage(context)})
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: clearImage),
              title: const Text(
                'Post to',
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: postImage,
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ))
              ],
            ),
            body: ListView(
              children: <Widget>[
                PostForm(
                  imageFile: file,
                  descriptionController: descriptionController,
                  locationController: locationController,
                  loading: uploading,
                ),
                Divider(), //scroll view where we will show location to users
                (address == null)
                    ? Container()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        child: Row(
                          children: <Widget>[
                            buildLocationButton(address.featureName),
                            buildLocationButton(address.subLocality),
                            buildLocationButton(address.locality),
                            buildLocationButton(address.subAdminArea),
                            buildLocationButton(address.adminArea),
                            buildLocationButton(address.countryName),
                          ],
                        ),
                      ),
                (address == null) ? Container() : Divider(),
              ],
            ));
  }

  //method to build buttons with location.
  buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {
          locationController.text = locationName;
        },
        child: Center(
          child: Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                locationName,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = imageFile;
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = imageFile;
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  void postImage() {
    setState(() {
      uploading = true;
    });
    uploadImage(file).then((String data) {
      postToFireStore(
          mediaUrl: data,
          description: descriptionController.text,
          location: locationController.text);
    }).then((_) {
      setState(() {
        file = null;
        uploading = false;
      });
    });
  }
}

class PostForm extends StatelessWidget {
  final imageFile;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final bool loading;

  PostForm(
      {this.imageFile,
      this.descriptionController,
      this.loading,
      this.locationController});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(currentUserModel.photoUrl),
            ),
            Container(
              width: 250.0,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: "Write a caption...", border: InputBorder.none),
              ),
            ),
            Container(
              height: 45.0,
              width: 45.0,
              child: AspectRatio(
                aspectRatio: 487 / 451,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fill,
                    alignment: FractionalOffset.topCenter,
                    image: FileImage(imageFile),
                  )),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.pin_drop),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none),
            ),
          ),
        )
      ],
    );
  }
}

Future<String> uploadImage(var imageFile) async {
  var uuid = Uuid().v1();
  StorageReference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
  StorageUploadTask uploadTask = ref.putFile(imageFile);

  String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  return downloadUrl;
}

void postToFireStore(
    {String mediaUrl, String location, String description}) async {
  var reference = Firestore.instance.collection('insta_posts');

  reference.add({
    "username": currentUserModel.username,
    "location": location,
    "likes": {},
    "mediaUrl": mediaUrl,
    "description": description,
    "ownerId": googleSignIn.currentUser.id,
    "timestamp": DateTime.now(),
  }).then((DocumentReference doc) {
    String docId = doc.documentID;
    reference.document(docId).updateData({"postId": docId});
  });
}*/
