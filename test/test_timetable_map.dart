import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
import 'package:prayer_calc/src/PrayerTimetableMap.dart';
import 'src/timetable_map.dart';
import 'test.dart';

PrayerTimetableMap dublin = PrayerTimetableMap(
  timetableDublin,
  // optional parameters:
  // year: 2020,
  // month: 3,
  // day: 28,

  jamaahOn: true,
  jamaahMethods: [
    'fixed',
    '',
    'afterthis',
    'afterthis',
    'afterthis',
    'afterthis'
  ],
  jamaahOffsets: [
    [4, 0],
    [],
    [0, 5],
    [0, 5],
    [0, 5],
    [0, 0]
  ],
  // testing options
  testing: true,
  hour: 13,
  minute: 33,
  second: 55,
);

PrayerTimetableMap location = dublin;

main() {
  tz.initializeTimeZones();
  // jamaahTest(location);
  timetableTest(location);
}

// main() => timetableTest(location);
