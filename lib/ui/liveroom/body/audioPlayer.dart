import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class AudioAppState {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  AudioAppState() {
    initAudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
  }

  Future playURL(kUrl) async {
    await audioPlayer.play(kUrl);
    playerState = PlayerState.playing;
  }

  Future playLocal(kUrl) async {
    await audioPlayer.play(kUrl, isLocal: true);
    playerState = PlayerState.playing;
  }

  Future pause() async {
    await audioPlayer.pause();
    playerState = PlayerState.paused;
  }

  Future stop() async {
    print("stop");
    await audioPlayer.stop();
    playerState = PlayerState.stopped;
    position = Duration();
  }

  Future mute(bool muted) async {
    await audioPlayer.setVolume(0.0);
  }

  void onComplete() {
    print("oncomplete");
  }
}
