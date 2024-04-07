/* *********************** */
/* HELPER FUNCTIONS        */
/* *********************** */

bool isDSTCalc(DateTime d) => new DateTime(d.year, 6, 1).timeZoneOffset == d.timeZoneOffset;

double round2Decimals(value) => double.parse(value.toStringAsFixed(2));

DateTime secondsToDateTime(int seconds, DateTime date, {int offset = 0}) {
  int dstAdjust = isDSTCalc(date) ? 1 : 0;

  return new DateTime(
    date.add(Duration(days: offset)).year,
    date.add(Duration(days: offset)).month,
    date.add(Duration(days: offset)).day,
    0,
    0,
    0,
  ).add(Duration(seconds: seconds)).add(Duration(hours: dstAdjust));
}

DateTime hourFractionToDateTime(
    double hourFraction, DateTime date, bool summerTimeCalc, bool showSeconds) {
  // adjust times for dst
  int dstAdjust = summerTimeCalc && isDSTCalc(date) ? 1 : 0;

  Duration totalSeconds = Duration(seconds: (hourFraction * 3600).round());

  int hour = totalSeconds.inHours;
  int minute = totalSeconds.inMinutes.remainder(60);
  int second = totalSeconds.inSeconds.remainder(60);

  // rounding
  if (second > 30 && !showSeconds) minute++;
  if (minute == 60) minute = 0;

  // int hour;
  // if (hourFraction != double.nan && hourFraction != null)
  //   hour = hourFraction.floor();
  // else
  //   hour = 23;

  // int minute = showSeconds
  //     ? ((hourFraction - hour) * 60).floor()
  //     : ((hourFraction - hour) * 60).round(); // rounding minutes

  // print('###\nhourFraction: $hourFraction\thour: $hour\tminute: $minute');

  // int second = showSeconds ? (hourFraction - hour - minute / 60).floor : 0;

  // print('***** second: $second');
  return DateTime(date.year, date.month, date.day, hour, minute, second)
      .add(Duration(hours: dstAdjust));
}

String appendZero(unit) {
  if (unit < 10) {
    return '0$unit';
  }
  return '$unit';
}

String toTwoDigitString(int value) {
  return value.toString().padLeft(2, '0');
}

bool isDST(DateTime d) {
  var jul = DateTime(d.year, 6, 1).timeZoneOffset;
  return jul == d.timeZoneOffset;
}

String twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}

DateTime dayStart(DateTime time) {
  return DateTime(time.year, time.month, time.day);
}

DateTime dayEnd(DateTime time) {
  return DateTime(time.year, time.month, time.day)
      .add(const Duration(days: 1))
      .subtract(const Duration(microseconds: 1));
}

String printDuration(Duration duration, {adjust = 0, round = false}) {
  String twoDigitMinutes =
      twoDigits((duration + Duration(seconds: adjust)).inMinutes.remainder(60));
  String twoDigitSeconds =
      twoDigits((duration + Duration(seconds: adjust)).inSeconds.remainder(60));

  if (round)
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes';
  else
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

String printDurationAlt(Duration duration, {adjust = 0, round = false}) {
  String hrs = '${((duration + Duration(seconds: adjust)).inHours)}';
  String mins = ((duration + Duration(seconds: adjust)).inMinutes.remainder(60)).toString();
  String secs = ((duration + Duration(seconds: adjust)).inSeconds.remainder(60)).toString();
  if (hrs == '0')
    hrs = '0h';
  else
    hrs = '${hrs}h';

  if (round)
    return '$hrs ${mins}m';
  else
    return '$hrs ${mins}m ${secs}s';
}

String capitalise(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '';

double roundDecimals(double value, int decimals) => double.parse(value.toStringAsFixed(decimals));
