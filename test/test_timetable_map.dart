import 'dart:async';

import 'package:prayer_timetable/src/PrayerTimetableMap.dart';
import 'src/timetable_map.dart';
import 'test.dart';

DateTime testTime =
    DateTime(2021, 4, 14, 16, 25, 45);

PrayerTimetableMap dublin(newtime) => PrayerTimetableMap(
      timetableDublin,
      // optional parameters:
      year: 2020,
      month: 3,
      day: 28,

      jamaahOn: true,
      jamaahMethods: [
        'fixed',
        '',
        'fixed',
        'afterthis',
        'afterthis',
        'afterthis'
      ],
      jamaahOffsets: [
        [6, 0],
        [],
        [13, 5],
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
  print(testTime);
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
