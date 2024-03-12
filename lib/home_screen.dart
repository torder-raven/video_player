import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/common/constant/label_text.dart';
import 'package:vid_player/component/custom_video_player.dart';
import 'common/constant/asset_path.dart';
import 'common/constant/color_code.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: video == null ? renderEmpty() : renderVideo());
  }

  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: selectVideo,
          ),
          SizedBox(
            height: 50.0,
          ),
          _AppName(),
        ],
      ),
    );
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
        video: video!,
        onNewPressed: selectVideo,
      ),
    );
  }

  void selectVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    setState(() {
      video?.let((it) => this.video = video);
    });
  }
}

BoxDecoration getBoxDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(ColorCode.GRADIENT_START_COLOR_CODE),
        Color(ColorCode.GRADIENT_END_COLOR_CODE),
      ],
    ),
  );
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(AssetPath.LOGO_IMAGE),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white, fontSize: 30.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(LabelText.VIDEO,
            style: textStyle.copyWith(fontWeight: FontWeight.w300)),
        Text(LabelText.PLAYER,
            style: textStyle.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
