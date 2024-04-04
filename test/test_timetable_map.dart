import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_map_dublin_leap.dart';
// ignore: unused_import
import 'test.dart';

DateTime now = tz.TZDateTime.now(tz.getLocation(timezoneI));
DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 11, 14, 32, 45), tz.getLocation(timezoneI));
DateTime testTime = now;

PrayerTimetable map(DateTime testTime) => PrayerTimetable.map(
      timetableMap: dublinLeap,
      // optional parameters:
      year: testTime.year,
      month: testTime.month,
      day: testTime.day,
      hour: testTime.hour,
      minute: testTime.minute,
      second: testTime.second,

      jamaahOn: true,
      jamaahMethods: ['fixed', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
      jamaahOffsets: [
        [6, 0],
        [0, 0],
        [0, 15],
        [0, 15],
        [0, 15],
        [0, 15]
      ],
      // joinDhuhr: true,
      // joinMaghrib: true,

      jamaahPerPrayer: [false, false, true, true, false, false],
      // // testing options
      // hour: newtime.hour,
      // minute: newtime.minute,
      // second: newtime.second,

      // hijriOffset: 0,
    );

PrayerTimetable location = map(testTime);

main() {
  tz.initializeTimeZones();
  print('\x1B[2J\x1B[0;0H'); // clear entire screen, move cursor to 0;0
  bool live = false;

  if (!live) {
    jamaahTest(location);

    // ignore: dead_code
  } else {
    liveTest(location, testTime);
  }
  ;
}
