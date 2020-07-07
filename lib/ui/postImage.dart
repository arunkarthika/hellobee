import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/ui/insta/feed.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:honeybee/ui/insta/main12.dart';

class PostImage extends StatefulWidget {
  PostImage({Key key, @required this.fileimage}) : super(key: key);

  final String fileimage;

  _PostImage createState() => _PostImage(fileimage: fileimage);
}

class _PostImage extends State<PostImage> {
  _PostImage({Key key, @required this.fileimage});

  final String fileimage;
  File file;
  bool uploading = false;
  Address address;
  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Widget build(BuildContext context) {
    return new Scaffold(
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
            postdats(),
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

  void clearImage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new Feed();
        }));
    setState(() {
      file = null;
    });
  }

  void postImage() {
    if (file != null) {
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
          Navigator.of(context).pushReplacement(
              MaterialPageRoute<Null>(builder: (BuildContext context) {
                return new Feed();
              }));

          file = null;
          uploading = false;
        });
      });
    } else {
      Fluttertoast.showToast(msg: 'Select A Image First');
    }
  }

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    StorageReference ref =
    FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl =
    await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl;
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

  Widget postdats() {
    return Column(
      children: <Widget>[
        uploading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: currentUserModel.photoUrl == null
                  ? NetworkImage(
                  'https://s3.ap-south-1.amazonaws.com/bliveprod-profile-pic/logo.png')
                  : NetworkImage(currentUserModel.photoUrl),
            ),
            Container(
              width: 250.0,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: "Write a caption...", border: InputBorder.none),
              ),
            ),
            GestureDetector(
              onTap: () {
                _selectImage(context);
              },
              child: file != null
                  ? Container(
                height: 45.0,
                width: 45.0,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: FileImage(file))),
                  ),
                ),
              )
                  : Container(
                height: 45.0,
                width: 45.0,
                child: SizedBox(
                  width: 30,
                  height: 30, // specific value

                  child: RaisedButton(
                    onPressed: () {
                      _selectImage(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.8, 0.0),
                          // 10% of the width, so there are ten blinds.
                          colors: [Colors.red, Colors.orangeAccent],
                          // whitish to gray
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(80.0)),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 30.0, minHeight: 30.0),
                        // min sizes for Material buttons
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.file_upload,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
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

void postToFireStore(
    {String mediaUrl, String location, String description}) async {
  var name = "";
  var reference = Firestore.instance.collection('insta_posts');

  var uid = "";
  var profile = "";

  CommonFun().getStringData('username').then((value) {
    name = value;
    CommonFun().getStringData('user_id').then((value) {
      uid = value;
      CommonFun().getStringData('profile_pic').then((value) {
        profile = value;
        reference.add({
          "username": name,
          "location": location,
          "likes": {},
          "mediaUrl": mediaUrl,
          "description": description,
          "ownerId": uid,
          "timestamp": DateTime.now(),
        }).then((DocumentReference doc) {
          String docId = doc.documentID;
          reference.document(docId).updateData({"postId": docId});
        });
      });
    });
  });
}
