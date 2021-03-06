import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:zego_express_engine/zego_express_engine.dart';


class ZegoClass {
  ZegoCanvas previewCanvas;
  // List<Widget> playViewWidget = [];
  List playViewWidget = [];
  List guest = [];
  var previewID = {};
  int previewViewID = -1;
  bool isPublishing = false;

  int publishWidth = 0;
  int publishHeight = 0;

  double publishFps = 0.0;
  double publishBitrate = 0.0;
  bool isHardwareEncode = false;
  String networkQuality = '';
  bool _isUseFrontCamera = true;
  bool _isUseSpeaker = true;

  // int width = int.tryParse(double.infinity.toString());
  // int height = int.tryParse(double.infinity.toString());

  // int width = 300;
  // int height = 300;

  int width;
  int height;

  ZegoClass() {
    // ZegoExpressEngine.createEngine(
    //     1263844657,
    //     '6fd98a7be6002228918436de65cff64556cc4fb01c88b266f6b3904cd83692e6',
    //     true,
    //     ZegoScenario.General,
    //     enablePlatformView: false);
    CommonFun().getStringData('userType').then((res) {
      // if(res=="broad"){
      //   setPreview();
      // }
    });
  }

  void setPreview(setState, streamID,broadcastType) {
    if(broadcastType!="audio"){
    // Create a Texture Renderer
    ZegoExpressEngine.instance
        .createTextureRenderer(width, height)
        .then((textureID) {
      previewViewID = textureID;
      previewID[int.tryParse(streamID)] = previewViewID;

      setState(() {
        // Create a Texture Widget
        playViewWidget.add(Texture(textureId: textureID));
      });

      // Start preview using texture renderer
      startPreview(textureID,broadcastType);
    });  
    }
    else
    {
       startPreview(1,broadcastType); 
    }
    
  }

  void startPublish(streamID) {
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    print("insidepublish stream " + streamID);
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    ZegoExpressEngine.instance.startPublishingStream(streamID.toString());
  }

  void playRemoteStream(String streamID, setState,broadcastType) {
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    print("inside play remote stream " + streamID);
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");


if(broadcastType=="audio"){

  //for audio call
ZegoExpressEngine.instance.enableCamera(false);
 ZegoExpressEngine.instance.startPlayingStream(streamID);
      //for audio call

}
else{
  // Create a Texture Renderer
    ZegoExpressEngine.instance
        .createTextureRenderer(width, height)
        .then((textureID) {
      previewViewID = textureID;
      previewID[int.tryParse(streamID)] = previewViewID;

      setState(() {
        // Create a Texture Widget
        playViewWidget.add(Texture(textureId: textureID));
      });
      // Start playing stream

      ZegoExpressEngine.instance
          .startPlayingStream(streamID, canvas: ZegoCanvas.view(textureID));

      print("inside startpreview");
      print(streamID);
      print("inside startpreview");
      print(playViewWidget.length);
    });
}
    

    
  }

  void startPreview(int viewID, broadcastType) {
    //for audio call
    if (broadcastType == "audio") {
      ZegoExpressEngine.instance.enableCamera(false);
      ZegoExpressEngine.instance.startPreview();
    } else {
      //for audio call

      // Set the preview canvas
      previewCanvas = ZegoCanvas.view(viewID);
      // Start preview
      ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
      print("inside startpreview");
      print(viewID);
      print("inside startpreview");
      print(playViewWidget.length);
    }
    //for beautification

    // ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.SkinWhiten);
    // ZegoBeautifyOption option = ZegoBeautifyOption(1.0, 1.0, 1.0);
    // ZegoExpressEngine.instance.setBeautifyOption(option);
//for beautification

// audio mute
  }

  void beautify(skin) {
    switch (skin) {
      case "sharpen":
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.Sharpen);
        break;
      case "polish":
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.Polish);
        break;
      case "whiten":
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.Whiten);
        break;
      case "skinWhiten":
        ZegoExpressEngine.instance
            .enableBeautify(ZegoBeautifyFeature.SkinWhiten);
        break;
      default:
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.None);
        break;
    }
    ZegoBeautifyOption option = ZegoBeautifyOption(1.0, 1.0, 1.0);
    ZegoExpressEngine.instance.setBeautifyOption(option);
  }

  void setCallback(setState) {
    ZegoExpressEngine.onRoomStreamUpdate = (String roomID,
        ZegoUpdateType updateType, List<ZegoStream> streamList) {
      print('onRoomStreamUpdate');
      print('roomID' + roomID);
      print(streamList);
      print('updateType' + updateType.toString());
      if (updateType == ZegoUpdateType.Add) {
        // for (ZegoStream stream in streamList) {
        //   // playRemoteStream(stream.streamID, setState);
        // }
      } else {}
    };
    // Set the publisher state callback
    ZegoExpressEngine.onRoomUserUpdate =
        (String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {
      print('onroomuserupdate');
      print('roomID' + roomID);
      print('updateType' + userList.toString());
    };

    ZegoExpressEngine.onPublisherStateUpdate = (String streamID,
        ZegoPublisherState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      if (errorCode == 0) {
        // setState(() {
        isPublishing = true;
        print("---------------------onroomuser update " +
            streamID +
            "--------------------------");
        // });

      } else {
        print('Publish error: $errorCode');
      }
    };

    // Set the publisher quality callback
    ZegoExpressEngine.onPublisherQualityUpdate =
        (String streamID, ZegoPublishStreamQuality quality) {
      // setState(() {
      publishFps = quality.videoSendFPS;
      publishBitrate = quality.videoKBPS;
      isHardwareEncode = quality.isHardwareEncode;

      switch (quality.level) {
        case ZegoStreamQualityLevel.Excellent:
          networkQuality = '☀️';
          break;
        case ZegoStreamQualityLevel.Good:
          networkQuality = '⛅️️';
          break;
        case ZegoStreamQualityLevel.Medium:
          networkQuality = '☁️';
          break;
        case ZegoStreamQualityLevel.Bad:
          networkQuality = '🌧';
          break;
        case ZegoStreamQualityLevel.Die:
          networkQuality = '❌';
          break;
        default:
          break;
      }
      // });
    };

    // Set the publisher video size changed callback
    ZegoExpressEngine.onPublisherVideoSizeChanged =
        (int width, int height, ZegoPublishChannel channel) {
      // setState(() {
      publishWidth = width;
      publishHeight = height;
      // });
    };
  }

  void onCamStateChanged() {
    _isUseFrontCamera = !_isUseFrontCamera;
    ZegoExpressEngine.instance.useFrontCamera(_isUseFrontCamera);
  }

  void onSpeakerStateChanged() {
    // setState(() {
    _isUseSpeaker = !_isUseSpeaker;
    ZegoExpressEngine.instance.muteSpeaker(!_isUseSpeaker);
    // });

    // CupertinoButton(
    //             padding: const EdgeInsets.all(0.0),
    //             pressedOpacity: 1.0,
    //             borderRadius: BorderRadius.circular(0.0),
    //             child: Image(
    //               width: 44.0,
    //               image: _isUseSpeaker
    //                   ? AssetImage(
    //                       'resources/images/bottom_microphone_on_icon.png')
    //                   : AssetImage(
    //                       'resources/images/bottom_microphone_off_icon.png'),
    //             ),
    //             onPressed: onSpeakerStateChanged,
    //           ),
  }
}
