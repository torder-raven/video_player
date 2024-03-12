import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'custom_controller.dart';
import 'custom_new_video_widget.dart';
import 'custom_video_slider.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onNewPressed;

  const CustomVideoPlayer(
      {super.key, required this.video, required this.onNewPressed});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  Duration currentPosition = Duration();
  bool showControls = false;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  //들어온 비디오가 변경되었으먄 컨트롤러 init();
  @override
  void didUpddateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null)
      return CircularProgressIndicator();
    else
      return AspectRatio(
        aspectRatio: videoPlayerController!.value.aspectRatio,
        child: GestureDetector(
          onTap: () {
            setState(() {
              showControls = !showControls;
            });
          },
          child: Stack(
            children: [
              VideoPlayer(videoPlayerController!),
              if (showControls)
                CustomController(
                  onPlayPressed: onPlayPressed,
                  onReversedPressed: onReversedPressed,
                  onForwardPressed: onForwardPressed,
                  isPlaying: videoPlayerController!.value.isPlaying,
                ),
              if (showControls) NewVideo(onPressed: widget.onNewPressed),
              CustomSlider(
                currentPosition: currentPosition,
                onSliderChange: onSliderChanged,
                maxPosition: videoPlayerController!.value.duration,
              ),
            ],
          ),
        ),
      );
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    videoPlayerController?.removeListener(
      () {
        onPositonMoved;
      },
    );
    super.dispose();
  }

  initializeController() async {
    videoPlayerController = VideoPlayerController.file(File(widget.video.path));
    await videoPlayerController!.initialize();

    videoPlayerController!.addListener(() {
      onPositonMoved();
    });
  }

  onPositonMoved() {
    final currentPosition = videoPlayerController!.value.position;

    setState(() {
      this.currentPosition = currentPosition;
    });
  }

  void onReversedPressed() {
    final defaultTime = 3;
    final currentPosition = videoPlayerController!.value.position;
    final canScrollToThreeSecondsBefort =
        currentPosition.inSeconds > defaultTime;
    Duration position = Duration();

    if (canScrollToThreeSecondsBefort)
      position = currentPosition - Duration(seconds: defaultTime);

    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    final defaultTime = 3;
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value!.position;
    final canScrollToThreeSecondsLater =
        (maxPosition - Duration(seconds: defaultTime)).inSeconds >
            currentPosition.inSeconds;
    Duration position = maxPosition;

    if (canScrollToThreeSecondsLater)
      position = currentPosition + Duration(seconds: defaultTime);

    videoPlayerController!.seekTo(position);
  }

  void onPlayPressed() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
    } else
      videoPlayerController!.play();
  }

  void onSliderChanged(double value) {
    videoPlayerController!.seekTo(
      Duration(
        seconds: value.toInt(),
      ),
    );
  }
}
