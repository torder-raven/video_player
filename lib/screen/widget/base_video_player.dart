import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_ben/constant/constants.dart';

class BaseVideoPlayer extends StatefulWidget {
  final XFile videoXFile;
  final VoidCallback onNewVideoPressed;

  const BaseVideoPlayer(
      {super.key, required this.videoXFile, required this.onNewVideoPressed});

  @override
  State<BaseVideoPlayer> createState() => _BaseVideoPlayerState();
}

class _BaseVideoPlayerState extends State<BaseVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  late VoidCallback videoControllerListener = onChangedVideoController;

  Duration currentPosition = const Duration();
  Duration eventPosition = const Duration();
  bool showControls = false;

  @override
  void initState() {
    super.initState();
    initVideoController();
  }

  @override
  void didUpdateWidget(covariant BaseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoXFile.path != widget.videoXFile.path) {
      onDisposeVideoPlayer();
      initVideoController();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> controls = [
      _VideoControls(
        onPlayPressed: onPlayOrPause,
        onReversePressed: onReverse,
        onForwardPressed: onForward,
        isPlaying: videoPlayerController.value.isPlaying,
      ),
      _NewVideoButton(
        onNewVideoPressed: widget.onNewVideoPressed,
      ),
      _BottomSlider(
        currentPosition: currentPosition,
        maxPosition: videoPlayerController.value.duration,
        onSlideChanged: onSeek,
      )
    ];

    return AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: GestureDetector(
        onTap: () {
          updateEventDuration();
          setState(() {
            showControls = !showControls;
          });
        },
        child: Stack(
          children: [
            VideoPlayer(videoPlayerController),
            if (showControls) ...controls,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    onDisposeVideoPlayer();
    super.dispose();
  }

  void initVideoController() async {
    currentPosition = const Duration();

    videoPlayerController =
        VideoPlayerController.file(File(widget.videoXFile.path))
          ..addListener(videoControllerListener);

    await videoPlayerController.initialize();

    onPlayOrPause();
  }

  void onChangedVideoController() {
    setState(() {
      currentPosition = videoPlayerController.value.position;

      if (showControls &&
          currentPosition - eventPosition >
              const Duration(
                  seconds: BaseVideoPlayerConstants.HIDE_SECONDS)) {
        showControls = false;
      }
    });
  }

  void onDisposeVideoPlayer() {
    videoPlayerController.removeListener(videoControllerListener);
    videoPlayerController.dispose();
  }

  void onPlayOrPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
      updateEventDuration();
    }
  }

  void onReverse() {
    final currentPosition = videoPlayerController.value.position;
    const distance = Duration(seconds: BaseVideoPlayerConstants.MOVE_SECONDS);

    Duration duration = const Duration();

    if (currentPosition.inSeconds > BaseVideoPlayerConstants.MOVE_SECONDS) {
      duration = currentPosition - distance;
    }

    videoPlayerController.seekTo(duration);
    updateEventDuration();
  }

  void onForward() {
    final maxPosition = videoPlayerController.value.duration;
    final currentPosition = videoPlayerController.value.position;
    const distance = Duration(seconds: BaseVideoPlayerConstants.MOVE_SECONDS);

    Duration duration = maxPosition;

    if ((maxPosition - distance).inSeconds > currentPosition.inSeconds) {
      duration = currentPosition + distance;
    }

    videoPlayerController.seekTo(duration);
    updateEventDuration();
  }

  void onSeek(double seconds) {
    videoPlayerController.seekTo(Duration(seconds: seconds.toInt()));
    updateEventDuration();
  }

  void updateEventDuration() {
    eventPosition = videoPlayerController.value.position;
  }

}

class _VideoControls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _VideoControls({
    super.key,
    required this.onPlayPressed,
    required this.onReversePressed,
    required this.onForwardPressed,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _videoIconButton(
            onPressed: onReversePressed,
            iconData: Icons.rotate_left,
          ),
          _videoIconButton(
            onPressed: onPlayPressed,
            iconData: isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          _videoIconButton(
            onPressed: onForwardPressed,
            iconData: Icons.rotate_right,
          ),
        ],
      ),
    );
  }
}

class _NewVideoButton extends StatelessWidget {
  final VoidCallback onNewVideoPressed;

  const _NewVideoButton({super.key, required this.onNewVideoPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: _videoIconButton(
        onPressed: onNewVideoPressed,
        iconData: Icons.photo_camera_back,
      ),
    );
  }
}

class _BottomSlider extends StatelessWidget {
  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> onSlideChanged;

  const _BottomSlider({
    super.key,
    required this.currentPosition,
    required this.maxPosition,
    required this.onSlideChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Row(
        children: [
          videoTime(
            minutes: currentPosition.inMinutes.toString(),
            seconds: (currentPosition.inSeconds % 60).toString(),
          ),
          Expanded(
            child: Slider(
              value: currentPosition.inSeconds.toDouble(),
              max: maxPosition.inSeconds.toDouble(),
              onChanged: onSlideChanged,
            ),
          ),
          videoTime(
            minutes: maxPosition.inMinutes.toString(),
            seconds: (maxPosition.inSeconds % 60).toString(),
          ),
        ],
      ),
    );
  }

  Widget videoTime({required String minutes, required String seconds}) => Text(
        "${minutes.padLeft(2, "0")}:${seconds.padLeft(2, "0")}",
        style: const TextStyle(
          color: Colors.white,
        ),
      );
}

Widget _videoIconButton({
  required VoidCallback onPressed,
  required IconData iconData,
}) =>
    IconButton(
      onPressed: onPressed,
      icon: Icon(iconData),
      iconSize: 30.0,
      color: Colors.white,
    );
