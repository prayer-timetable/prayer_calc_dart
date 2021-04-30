import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
//
import 'package:prayer_timetable/src/PrayerTimetableMap.dart';
import 'src/timetable_map.dart';
import 'test.dart';

DateTime testTime = tz.TZDateTime.from(
    DateTime(2021, 4, 14, 16, 25, 45), tz.getLocation('Europe/Dublin'));

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
  hour: testTime.hour,
  minute: testTime.minute,
  second: testTime.second,
);

PrayerTimetableMap location = dublin;

main() {
  tz.initializeTimeZones();
  // jamaahTest(location);
  timetableTest(location);
  print(location.calc!.percentage);
}

// main() => timetableTest(location);
