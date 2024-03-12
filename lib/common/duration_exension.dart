extension Time on Duration {
  String parseToTimeString() {
    return "${this.inMinutes}:${(this.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}
