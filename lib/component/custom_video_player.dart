import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player_kite/constant/styles.dart';
import 'package:video_player_kite/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

// 동영상 위젯 생성
class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상을 저장할 변수
  // XFile은 ImagePicker로 영상 또는 이미지를 선택했을 때 반환하는 타입
  final XFile video;

  const CustomVideoPlayer({
    required this.video,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  // 동영상을 조작하는 컨트롤러
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();

    initializeController(); // 컨트롤러 초기화
  }

  initializeController() async {
    // 선택한 동영상으로 컨트롤러 초기화
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    setState(() {
      this.videoPlayerController = videoController;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 동영상 컨트롤러가 준비 중일 때 로딩 표시
    if (videoPlayerController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
        aspectRatio: videoPlayerController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              videoPlayerController!,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Slider(
                // 슬라이더가 이동할 때마다 실행할 함수
                onChanged: (double val) {
                  videoPlayerController!.seekTo(
                    Duration(seconds: val.toInt()),
                  );
                },

                // 동영상 재생 위치를 초 단위로 구현
                value:
                    videoPlayerController!.value.position.inSeconds.toDouble(),
                min: 0,
                max: videoPlayerController!.value.duration.inSeconds.toDouble(),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: CustomIconButton(
                onPressed: () {},
                iconData: Icons.photo_camera_back,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomIconButton(
                    onPressed: () {},
                    iconData: Icons.rotate_left,
                  ),
                  CustomIconButton(
                    onPressed: () {},
                    iconData: videoPlayerController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  CustomIconButton(
                    onPressed: () {},
                    iconData: Icons.rotate_right,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
