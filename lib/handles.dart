int position = 0;

String currentPosition() {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitHours = twoDigits(position ~/ 3600000);
  String twoDigitMinutes = twoDigits(position ~/ 60000);
  String twoDigitSeconds = twoDigits(position ~/ 1000);
  if (twoDigitHours != '00') {
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  } else if (twoDigitMinutes != '00') {
    return '$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return twoDigitSeconds;
  }
}

String totalDuration(int duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitHours = twoDigits(duration ~/ 3600000);
  String twoDigitMinutes = twoDigits(duration ~/ 60000);
  String twoDigitSeconds = twoDigits(duration ~/ 1000);
  if (twoDigitHours != '00') {
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  } else if (twoDigitMinutes != '00') {
    return '$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return twoDigitSeconds;
  }
}
