import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  // TODO 구현 예정
  Widget renderEmpty() {
    // 동영상 선택 전 보여줄 위젯
    return Container();
  }

  // TODO 구현 예정
  Widget renderVideo() {
    // 동영상 선택 후 보여줄 위젯
    return Container();
  }
}
