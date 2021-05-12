import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

import 'package:prayer_timetable/src/PrayerTimetableMap.dart';
import 'src/timetable_map.dart';
import 'test.dart';

DateTime testTime = tz.TZDateTime.from(
    DateTime(2021, 4, 14, 16, 25, 45), tz.getLocation('Europe/Dublin'));

PrayerTimetableMap dublin(newtime) => PrayerTimetableMap(
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
      hour: newtime.hour,
      minute: newtime.minute,
      second: newtime.second,
      joinMaghrib: true,
      joinDhuhr: true,
    );

PrayerTimetableMap location = dublin(testTime);

main() {
  tz.initializeTimeZones();
  jamaahTest(location);
  // timetableTest(location);
  // Timer.periodic(Duration(seconds: 1), (Timer t) {
  //   testTime = testTime.add(Duration(seconds: 1));
  //   location = dublin(testTime);
  //   print("\x1B[2J\x1B[0;0H"); // clear entire screen, move cursor to 0;0
  //   print("$testTime");
  //   print("${location.calc!.percentage}");
  //   print("${location.calc!.currentId}");
  // });
}

// main() => timetableTest(location);
