import 'package:timezone/timezone.dart' as tz;

DateTime nowTZ(String timezone,
    {int? year, int? month, int? day, int? hour, int? minute, int? second}) {
  tz.setLocalLocation(tz.getLocation(timezone));
  DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));

  DateTime newTime = tz.TZDateTime.from(
      DateTime(
        year ?? now.year,
        month ?? now.month,
        day ?? now.day,
        hour ?? now.hour,
        minute ?? now.minute,
        second ?? now.second,
      ),
      tz.getLocation(timezone));

  return newTime;
}
