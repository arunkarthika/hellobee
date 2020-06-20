import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:honeybee/constant/common.dart';
import 'package:honeybee/constant/http.dart';
import 'package:zego_express_engine/zego_express_engine.dart';


class ZegoClass {
  ZegoCanvas previewCanvas;
  ZegoViewMode viewMode = ZegoViewMode.AspectFill;
  var backgroundColor = 0xFF00FF;

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
  bool isUseSpeaker = false;
  bool isCameraEnabled = true;
  bool _isMirrored = false;
  bool isUseMic = true;
  bool broadOffline = false;

  int width;
  int height;

  ZegoClass() {
    CommonFun().getStringData('userType').then((res) {});
  }

  void setPreview(setState, streamID, broadcastType) {
    if (broadcastType != 'audio') {
      // Create a Texture Renderer
      ZegoExpressEngine.instance
          .createTextureRenderer(width, height)
          .then((textureID) {
        previewViewID = textureID;
        previewID[streamID] = previewViewID;

        setState(() {
          // Create a Texture Widget
          playViewWidget.add(Texture(textureId: textureID));
        });

        // Start preview using texture renderer
        startPreview(textureID, broadcastType);
      });
    } else {
      startPreview(1, broadcastType);
    }
  }

  void startPublish(streamID) {
    ZegoExpressEngine.instance.startPublishingStream(streamID.toString());
  }

  void playRemoteStream(String streamID, setState, broadcastType) {
    if (broadcastType == 'audio') {
      //for audio call
      ZegoExpressEngine.instance.enableCamera(false);
      ZegoExpressEngine.instance.startPlayingStream(streamID);
      //for audio call
      previewID[streamID] = -1;
    } else {
      // Create a Texture Renderer
      ZegoExpressEngine.instance
          .createTextureRenderer(width, height)
          .then((textureID) {
        previewViewID = textureID;
        previewID[streamID] = previewViewID;

        setState(() {
          // Create a Texture Widget
          playViewWidget.add(Texture(textureId: textureID));
        });
        // Start playing stream

        previewCanvas = ZegoCanvas(textureID, viewMode, backgroundColor);
        ZegoExpressEngine.instance
            .startPlayingStream(streamID, canvas: previewCanvas);
        // ZegoExpressEngine.instance
        //     .startPlayingStream(streamID, canvas: ZegoCanvas.view(textureID));
      });
    }
  }

  void startPreview(int viewID, broadcastType) {
    //for audio call
    if (broadcastType == 'audio') {
      ZegoExpressEngine.instance.enableCamera(false);
      ZegoExpressEngine.instance.startPreview();
    } else {
      //for audio call

      // Set the preview canvas
      previewCanvas = ZegoCanvas(viewID, viewMode, backgroundColor);

      // Start preview
      ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
    }
  }

  void beautify(skin, x, y, z) {
    switch (skin) {
      case 'Sharpen':
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.Sharpen);
        toast('Sharpen Applied Success!', Colors.green);
        break;
      case 'Polish':
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.Polish);
        toast('Polish Applied Success!', Colors.green);
        break;
      case 'Whiten':
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.Whiten);
        toast('Whiten Applied Success!', Colors.green);
        break;
      case 'SkinWhiten':
        ZegoExpressEngine.instance
            .enableBeautify(ZegoBeautifyFeature.SkinWhiten);
        toast('SkinWhiten Applied Success!', Colors.green);
        break;
      case 'None':
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.None);
        toast('Beauty Removed Success!', Colors.green);
        break;
      case 'Mychoice':
        var option = ZegoBeautifyOption(x, y, z);
        ZegoExpressEngine.instance.setBeautifyOption(option);
        toast('Beauty Choice Applied Success!', Colors.green);
        break;
      default:
        ZegoExpressEngine.instance.enableBeautify(ZegoBeautifyFeature.None);
        break;
    }
  }

  void setCallback(setState) {
    ZegoExpressEngine.onRoomStateUpdate = (String roomID, ZegoRoomState state,
        int errorCode, Map<String, dynamic> extendedData) {};

    ZegoExpressEngine.onRoomStreamUpdate = (String roomID,
        ZegoUpdateType updateType, List<ZegoStream> streamList) {
      // toast('onRoomStreamUpdate  Changed $updateType', Colors.orange);
      if (updateType == ZegoUpdateType.Add) {
        // for (ZegoStream stream in streamList) {
        //   // playRemoteStream(stream.streamID, setState);
        // }
      } else {}
    };
    // Set the publisher state callback
    ZegoExpressEngine.onRoomUserUpdate =
        (String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {};

    ZegoExpressEngine.onPlayerStateUpdate = (String streamID,
        ZegoPlayerState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
//      if (errorCode.toString() == '1004020' &&
//          streamID == common.broadcasterId) {
//        // broadOffline=true;
//      }
    };
    ZegoExpressEngine.onPublisherStateUpdate = (String streamID,
        ZegoPublisherState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      if (errorCode == 0) {
        isPublishing = true;
      } else {}
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
      publishWidth = width;
      publishHeight = height;
    };
  }

  void onCamStateChanged() {
    _isUseFrontCamera = !_isUseFrontCamera;
    ZegoExpressEngine.instance.useFrontCamera(_isUseFrontCamera);
  }

   void videoMute(common, setState, context) {
    setState(() {
      isCameraEnabled = !isCameraEnabled;
      ZegoExpressEngine.instance.enableCamera(isCameraEnabled);
    });
    var action = 'videoUnmute';
    if (isCameraEnabled == false) {
      action = 'videoMute';
    }
    var endPoint = 'user/userRelation';
    var params = {
      'action': action,
      'user_id': common.userId,
    };
    makePostRequest(endPoint, jsonEncode(params), 0, context).then((response) {
      var data = jsonDecode(response);
      if (data['status'] == 0) {
        common.publishMessage(
            common.broadcastUsername,
            '£01refreshAudience01£*£' +
                common.userId +
                '£*£' +
                common.name +
                '£*£' +
                common.username +
                '£*£' +
                common.profilePic);
      }
    });
  }

  void mirror() {
    _isMirrored = !_isMirrored;
    if (_isMirrored) {
      ZegoExpressEngine.instance
          .setVideoMirrorMode(ZegoVideoMirrorMode.BothMirror);
    } else {
      ZegoExpressEngine.instance
          .setVideoMirrorMode(ZegoVideoMirrorMode.NoMirror);
    }
  }

  void onMicStateChanged(common, setState) {
    setState(() {
      common.zego.isUseMic = !common.zego.isUseMic;
      ZegoExpressEngine.instance.muteMicrophone(!common.zego.isUseMic);
    });
  }

  void onSpeakerStateChanged() {
    isUseSpeaker = !isUseSpeaker;
    ZegoExpressEngine.instance.muteSpeaker(!isUseSpeaker);
  }
}