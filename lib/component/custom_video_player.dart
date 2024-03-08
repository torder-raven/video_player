import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player_kite/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import 'package:video_player_kite/constant/colors.dart';

import '../constant/strings.dart';
import '../constant/values.dart';

// 동영상 위젯 생성
class CustomVideoPlayer extends StatefulWidget {
  final XFile video; // 선택한 동영상을 저장할 변수
  final GestureTapCallback onNewVideoPressed; // 새로운 동영상을 선택하면 실행되는 함수

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool showControls = false; // 동영상 조작하는 아이콘을 보일지 여부

  VideoPlayerController? videoPlayerController; // 동영상을 조작하는 컨트롤러

  @override
  void initState() {
    super.initState();
    initializeController(); // 컨트롤러 초기화
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
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      renderTimeTextFromDuration(
                        videoPlayerController!.value.position,
                      ),
                      Expanded(
                        child: buildSlider(),
                      )
                    ],
                  ),
                ),
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
                  child: Row(
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
                  ),
                )
            ],
          )),
    );
  }

  Widget buildSlider() {
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

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      "${duration.inMinutes.toString().padLeft(2, Strings.ZERO)}:${(duration.inSeconds % 60).toString().padLeft(2, Strings.ZERO)}",
      style: const TextStyle(color: AppColors.color_ffffff),
    );
  }

  void onReversePressed() {
    const targetDuration = Duration(seconds: Values.MOVING_SECONDS_UNIT);
    final currentPosition =
        videoPlayerController!.value.position; // 현재 실행 중인 위치

    Duration position = const Duration(); // 0초로 살행 위치 초기화

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - targetDuration;
    }

    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    const targetDuration = Duration(seconds: Values.MOVING_SECONDS_UNIT);
    final maxPosition = videoPlayerController!.value.duration; // 동영상 길이
    final currentPosition = videoPlayerController!.value.position;

    Duration position = maxPosition;
    if ((maxPosition - targetDuration).inSeconds > currentPosition.inSeconds) {
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
    super.dispose();
  }
}
