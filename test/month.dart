import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/month.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'src/timetable_map.dart';

main() {
  tz.initializeTimeZones();

  List<PrayerTimes> list = monthMap(
      tz.TZDateTime.from(
          DateTime.now().add(
            Duration(days: 31),
          ),
          tz.getLocation('Europe/Dublin')),
      timetableDublin);
  // print(list);
  // print('done');

  for (PrayerTimes item in list) {
    print(
        '${item.dawn.year}-${item.dawn.month}-${item.dawn.day} ${item.dawn.hour}:${item.dawn.minute}, ${item.dawn.weekday}');
  }
}
