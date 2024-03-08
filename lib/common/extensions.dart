import 'package:video_player_app/resources/strings.dart';

extension IntFormatter on int {
  String formattingTime() => "$this".padLeft(2, "0");
}

extension DurationFormatter on Duration {
  String formattingTimeWithSeconds() => (inSeconds % 60).formattingTime();

  String formattingTimeWithMinutes() => (inMinutes % 60).formattingTime();

  String formattingTimeWithHours() => (inHours % 24).formattingTime();

  String formattingTimeInMinutes() => [
        formattingTimeWithMinutes(),
        formattingTimeWithSeconds(),
      ].join(
        Strings.TIME_DELIMITER,
      );

  String formattingTimeInHours() => [
        formattingTimeWithHours(),
        formattingTimeInMinutes(),
      ].join(
        Strings.TIME_DELIMITER,
      );
}
