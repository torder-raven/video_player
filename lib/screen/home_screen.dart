import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player_kite/constant/styles.dart';

import '../constant/colors.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
        children: [
          // _Logo(), // 로고 이미지
          SizedBox(height: 30.0),
          _AppName(), // 앱 이름
        ],
      ),
    );
  }

  Widget renderVideo() {
    // 동영상 선택 후 보여줄 위젯
    return Container();
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 글자 가운데 정렬
      children: [
        const Text(
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
