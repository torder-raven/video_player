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
  XFile? video; // 동영상을 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // 동영상이 선택됐을 때와 선택 안 됐을 때 보여줄 위젯
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty() {
    // 동영상 선택 전 보여줄 위젯
    return Container(
      width: MediaQuery.of(context).size.width, // 최대 너비로 늘려주기
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
        children: [
          _Logo(
            onTap: onNewVideoPressed,
          ), // 로고 탭하면 실행하는 함수
          SizedBox(height: 30.0),
          _AppName(), // 앱 이름
        ],
      ),
    );
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.color_003973,
          AppColors.color_e5e5be
        ],
      ),
    );
  }

  // 이미지 선택하는 기능을 구현한 함수
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
    // 동영상 선택 후 보여줄 위젯
    return Center(
      child: CustomVideoPlayer(
          video: video!,
          onNewVideoPressed: onNewVideoPressed,
      )
      ,
    );
  }
}

// 로고를 보여줄 위젯
class _Logo extends StatelessWidget {
  final GestureTapCallback onTap;

  const _Logo({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = Strings.FILE_PATH_IMG;
    String logo = Strings.LOGO;
    String fileExtension = Strings.FILE_EXTENSION_PNG;

    return GestureDetector(
      onTap: onTap, // 상위 위젯으로부터 앱 콜백 받기
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
      mainAxisAlignment: MainAxisAlignment.center, // 글자 가운데 정렬
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
