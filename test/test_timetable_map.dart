import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_map_dublin_leap.dart';
// ignore: unused_import
import 'test.dart';

// String timezone = 'Europe/Sarajevo';
// String timezone = 'Europe/Amsterdam';
String timezone = 'Europe/Dublin'; // glitch for dst detection
// String timezone = 'Europe/London';
double lat = latI;
double lng = lngI;

DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
// DateTime setTime =
//     tz.TZDateTime.from(DateTime(now.year, now.month, now.day, 22, 3, 57), tz.getLocation(timezone));
DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 31, 0, 59, 55), tz.getLocation(timezone));
DateTime testTime = setTime;

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
      jamaahMethods: ['afterthis', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
      // jamaahMethods: ['fixed', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
      jamaahOffsets: [
        // [5, 0],
        [0, 15],
        [0, 0],
        [0, 15],
        [0, 15],
        [0, 15],
        [0, 15]
      ],
      // joinDhuhr: true,
      // joinMaghrib: true,

      // jamaahPerPrayer: [false, false, true, true, false, true],

      timezone: timezone,
      lat: lat,
      lng: lng,
      // hijriOffset: 0,
    );

PrayerTimetable location = map(testTime);

main() {
  tz.initializeTimeZones();
  print('\x1B[2J\x1B[0;0H'); // clear entire screen, move cursor to 0;0
  bool live = true;

  // infoTest(testTime);
  // print(location.day);
  // ignore: dead_code
  if (!live) {
    jamaahTest(location, prayer: true, jamaah: false, utils: true, info: true);

    // ignore: dead_code
  } else {
    liveTest(location, show: true, info: true);
  }
}
