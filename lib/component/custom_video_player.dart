import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player_kite/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import 'package:video_player_kite/constant/colors.dart';
import '../constant/values.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    super.key,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool showControls = false;
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  // 선택한 동영상으로 컨트롤러 초기화
  // 컨트롤러의 속성이 변경될 때마다 실행할 함수 등록
  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    videoController.addListener(videoControllerListener);
    setState(() {
      this.videoPlayerController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
          aspectRatio: videoPlayerController!.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(
                videoPlayerController!,
              ),
              if (showControls)
                Container(
                  color: AppColors.color_000000.withOpacity(0.5),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: buildController(),
              ),
              if (showControls)
                Align(
                  alignment: Alignment.topRight,
                  child: CustomIconButton(
                    onPressed: widget.onNewVideoPressed,
                    iconData: Icons.photo_camera_back,
                  ),
                ),
              if (showControls)
                Align(
                  alignment: Alignment.center,
                  child: buildPlayerButtons(),
                )
            ],
          )),
    );
  }

  Padding buildController() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          renderTimeTextFromDuration(
            videoPlayerController!.value.position,
          ),
          Expanded(
            child: buildSlider(),
          ),
        ],
      ),
    );
  }

  Slider buildSlider() {
    return Slider(
      onChanged: (double val) {
        videoPlayerController!.seekTo(
          Duration(seconds: val.toInt()),
        );
      },
      value: videoPlayerController!.value.position.inSeconds.toDouble(),
      min: 0,
      max: videoPlayerController!.value.duration.inSeconds.toDouble(),
    );
  }

  Row buildPlayerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomIconButton(
          onPressed: onReversePressed,
          iconData: Icons.rotate_left,
        ),
        CustomIconButton(
          onPressed: onPlayPressed,
          iconData: videoPlayerController!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
        CustomIconButton(
          onPressed: onForwardPressed,
          iconData: Icons.rotate_right,
        ),
      ],
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      "${duration.inMinutes.toString().padLeft(2, Values.ZERO)}:${(duration.inSeconds % 60).toString().padLeft(2, Values.ZERO)}",
      style: const TextStyle(color: AppColors.color_ffffff),
    );
  }

  void onReversePressed() {
    const targetDuration = Duration(seconds: Values.MOVING_SECONDS_UNIT);
    final currentPosition = videoPlayerController!.value.position;

    Duration position = const Duration();

    if (currentPosition.inSeconds > Values.MOVING_SECONDS_UNIT) {
      position = currentPosition - targetDuration;
    }

    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    const targetDuration = Duration(seconds: Values.MOVING_SECONDS_UNIT);
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value.position;

    Duration position = maxPosition;
    bool canMoveSeekbar =
        (maxPosition - targetDuration).inSeconds > currentPosition.inSeconds;
    if (canMoveSeekbar) {
      position = currentPosition + targetDuration;
    }

    videoPlayerController!.seekTo(position);
  }

  void onPlayPressed() {
    videoPlayerController!.value.isPlaying
        ? videoPlayerController!.pause()
        : videoPlayerController!.play();
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(videoControllerListener);
    videoPlayerController?.dispose();
    super.dispose();
  }
}
