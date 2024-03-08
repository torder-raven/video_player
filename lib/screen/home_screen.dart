import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player_kite/constant/colors.dart';
import 'package:video_player_kite/constant/styles.dart';
import 'package:video_player_kite/component/custom_video_player.dart';

import '../constant/strings.dart';

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
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onNewVideoPressed,
          ),
          const SizedBox(height: 30.0),
          const _AppName(), // 앱 이름
        ],
      ),
    );
  }

  BoxDecoration getBoxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.color_003973, AppColors.color_e5e5be],
      ),
    );
  }

  void onNewVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
        video: video!,
        onNewVideoPressed: onNewVideoPressed,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final GestureTapCallback onTap;

  const _Logo({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath = Strings.FILE_PATH_IMG;
    String logo = Strings.LOGO;
    String fileExtension = Strings.FILE_EXTENSION_PNG;

    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        "$imagePath$logo.$fileExtension",
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Strings.VIDEO,
          style: AppTextStyles.esamanru_30_w300,
        ),
        Text(
          Strings.PLAYER,
          style: AppTextStyles.esamanru_30_w700,
        ),
      ],
    );
  }
}
