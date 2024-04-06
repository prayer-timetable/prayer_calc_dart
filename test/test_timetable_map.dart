import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_map_dublin_leap.dart';
// ignore: unused_import
import 'test.dart';

String timezone = timezoneI;
double lat = latI;
double long = longI;

DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 31, 14, 32, 45), tz.getLocation(timezone));
DateTime testTime = setTime;

PrayerTimetable map(DateTime testTime) => PrayerTimetable.map(
      timetableMap: dublinLeap,
      // optional parameters:
      // year: testTime.year,
      // month: testTime.month,
      // day: testTime.day,
      // hour: testTime.hour,
      // minute: testTime.minute,
      // second: testTime.second,
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
      timezone: timezone,

      // hijriOffset: 0,
    );

PrayerTimetable location = map(testTime);

main() {
  tz.initializeTimeZones();
  print('\x1B[2J\x1B[0;0H'); // clear entire screen, move cursor to 0;0
  bool live = false;

  // infoTest(testTime);
  // print(location.day);
  // if (!live) {
  jamaahTest(location, prayer: true, jamaah: true, sunnah: true, utils: true);

  //   // ignore: dead_code
  // } else {
  //   liveTest(location, testTime);
  // }
}
