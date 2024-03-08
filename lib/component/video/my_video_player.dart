import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_app/component/video/seeker.dart';

import 'controls.dart';
import 'find_video.dart';

class MyVideoPlayer extends StatefulWidget {
  final XFile videoFile; // 네트워크 대응 해보면 좋을 듯?
  final VoidCallback onNewVideoPressed;

  const MyVideoPlayer({
    required this.videoFile,
    required this.onNewVideoPressed,
    super.key,
  });

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  final Duration timeDelimiter = const Duration(seconds: 3);
  Duration currentPosition = const Duration();
  late VideoPlayerController videoPlayerController;
  late VoidCallback videoPlayerListener = onChangeCurrentPosition;
  Timer? autoHideControlTimer;
  bool isShowControls = false;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayerController();
  }

  @override
  void didUpdateWidget(covariant MyVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.videoFile.path != oldWidget.videoFile.path) {
      disposeVideoPlayer();
      initializeVideoPlayerController();
    }
  }

  initializeVideoPlayerController() async {
    isShowControls = false;
    currentPosition = const Duration();
    videoPlayerController = VideoPlayerController.file(
      File(widget.videoFile.path),
    );
    await videoPlayerController.initialize();
    videoPlayerController
      ..addListener(videoPlayerListener)
      ..play();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!videoPlayerController.hasListeners) {
      return const CircularProgressIndicator();
    }

    return GestureDetector(
      onTap: onShowControls,
      child: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(
                  videoPlayerController,
                ),
                if (isShowControls)
                  Controls(
                    videoPlayerValue: videoPlayerController.value,
                    onReveredPressed: onReveredPressed,
                    onPlayPressed: onPlayPressed,
                    onForwardPressed: onForwardPressed,
                  ),
                if (isShowControls)
                  FindVideo(
                    onPressed: widget.onNewVideoPressed,
                  ),
                if (isShowControls)
                  Seeker(
                    videoPlayerValue: videoPlayerController.value,
                    onSeekerChanged: onSeekerChanged,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  cancelAutoHideControlTimer() {
    if (autoHideControlTimer?.isActive == true) {
      autoHideControlTimer?.cancel();
    }
  }

  onSetControlTimer() {
    if (isShowControls) {
      cancelAutoHideControlTimer();
      autoHideControlTimer = Timer.periodic(timeDelimiter, (Timer timer) {
        isShowControls = false;
      });
    }
  }

  onShowControls() {
    setState(() {
      isShowControls = !isShowControls;
      onSetControlTimer();
    });
  }

  onReveredPressed() {
    final currentPosition = videoPlayerController.value.position;
    final position = currentPosition.inSeconds >= timeDelimiter.inSeconds
        ? currentPosition - timeDelimiter
        : const Duration();
    seekToVideoPlayer(position);
  }

  onPlayPressed() {
    setState(() {
      videoPlayerController.value.isPlaying
          ? videoPlayerController.pause()
          : videoPlayerController.play();
      onSetControlTimer();
    });
  }

  onForwardPressed() {
    final maxPosition = videoPlayerController.value.duration;
    final currentPosition = videoPlayerController.value.position;
    final position =
        ((maxPosition - timeDelimiter).inSeconds > currentPosition.inSeconds)
            ? currentPosition + timeDelimiter
            : maxPosition;
    seekToVideoPlayer(position);
  }

  seekToVideoPlayer(Duration position) {
    setState(() {
      videoPlayerController.seekTo(position);
      onSetControlTimer();
    });
  }

  onChangeCurrentPosition() {
    setState(() {
      currentPosition = videoPlayerController.value.position;
    });
  }

  onSeekerChanged(double value) {
    seekToVideoPlayer(
      Duration(
        seconds: value.toInt(),
      ),
    );
  }

  disposeVideoPlayer() {
    videoPlayerController
      ..removeListener(videoPlayerListener)
      ..dispose();
  }

  disposeTimer() {
    cancelAutoHideControlTimer();
    autoHideControlTimer = null;
  }

  @override
  void dispose() {
    disposeVideoPlayer();
    disposeTimer();
    super.dispose();
  }
}
