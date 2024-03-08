import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player_app/component/video/my_video_player.dart';
import 'package:video_player_app/resources/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? videoFile; // State로 관리할 수 없을까? Idle ... 등등

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videoFile == null ? renderIdle() : renderVideo(),
    );
  }

  Widget renderIdle() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.blue, Colors.white],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTapLogo: onNewVideoPressed,
          ),
          const SizedBox(
            height: 30.0,
          ),
          _AppName(),
        ],
      ),
    );
  }

  Widget renderVideo() {
    return MyVideoPlayer(
      videoFile: videoFile!,
      onNewVideoPressed: onNewVideoPressed,
    );
  }

  void onNewVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      setState(() {
        videoFile = video;
      });
    }
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTapLogo;

  const _Logo({required this.onTapLogo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapLogo,
      child: const Icon(
        Icons.play_circle_rounded,
        size: 200,
        color: Colors.white,
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              Strings.TITLE_VIDEO,
              style: textStyle,
            ),
            Text(
              Strings.TITLE_PLAYER,
              style: textStyle.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(
          Strings.TITLE_MADE_BY_YOONA,
          style: textStyle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}
