class VideoPath {
  VideoPath._();

  static const PATH_ASSET = "asset";
  static const PATH_ASSET_IMAGE = "$PATH_ASSET/image";
  static const PATH_ASSET_VIDEO = "$PATH_ASSET/video";
}

class HomeScreenConstants {
  HomeScreenConstants._();

  static const String PATH_LOGO = "${VideoPath.PATH_ASSET_IMAGE}/logo.png";
}

class BaseVideoPlayerConstants {
  BaseVideoPlayerConstants._();

  static const int MOVE_SECONDS = 10;
  static const int HIDE_SECONDS = 3;
}
