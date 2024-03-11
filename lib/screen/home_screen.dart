import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player_ben/constant/colors.dart';
import 'package:video_player_ben/constant/constants.dart';
import 'package:video_player_ben/constant/strings.dart';
import 'package:video_player_ben/screen/widget/base_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? videoXFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videoXFile == null ? getMainWidget() : getVideoWidget(videoXFile!),
    );
  }

  Widget getMainWidget() => Container(
        decoration: _getBoxDecoration(),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Logo(
              onLogoTap: _pickVideo,
            ),
            const SizedBox(
              height: 30.0,
            ),
            const _AppTitle(),
          ],
        ),
      );

  BoxDecoration _getBoxDecoration() => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [COLOR_BLUE, COLOR_BLACK],
        ),
      );

  void _pickVideo() async {
    final videoXFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (videoXFile != null) {
      setState(() {
        this.videoXFile = videoXFile;
      });
    }
  }

  Widget getVideoWidget(XFile videoXFile) => Container(
    color: Colors.black,
    child: Center(
      child: BaseVideoPlayer(
        videoXFile: videoXFile,
        onNewVideoPressed: _pickVideo,
      ),
    ),
  );
}

class _Logo extends StatelessWidget {
  final GestureTapCallback onLogoTap;

  const _Logo({super.key, required this.onLogoTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onLogoTap,
      child: Image.asset(
        HomeScreenConstants.PATH_LOGO,
      ),
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    const titleTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          HomeScreenStrings.TITLE_VIDEO,
          style: titleTextStyle,
        ),
        Text(
          HomeScreenStrings.TITLE_PLAYER,
          style: titleTextStyle.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
