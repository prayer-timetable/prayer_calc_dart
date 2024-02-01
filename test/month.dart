import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/month.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'src/timetable_map.dart';
import 'src/timetable_map_leap.dart';

main() {
  tz.initializeTimeZones();

  tz.TZDateTime testTime =
      tz.TZDateTime(tz.getLocation('Europe/Dublin'), 2024, 2, 20, 13, 59, 55);

  List<PrayerTimes> list = monthMap(
      testTime, testTime.year % 4 == 0 ? timetableDublinLeap : timetableDublin);
  // print(list);
  // print('done');

  for (PrayerTimes item in list) {
    print(
        '${item.dawn.year}-${item.dawn.month}-${item.dawn.day} ${item.dawn.hour}:${item.dawn.minute}, ${item.dawn.weekday}');
  }
}
