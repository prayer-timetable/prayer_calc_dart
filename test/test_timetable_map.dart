import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_map.dart';
import 'src/timetable_map_leap.dart';
import 'test.dart';

DateTime testTime = tz.TZDateTime.from(
    DateTime(2024, 3, 11, 14, 32, 45), tz.getLocation('Europe/Dublin')); // asr jamaah pending

PrayerTimetable dublin = PrayerTimetable.map(
  dublinLeap,
  // dublin,
  // optional parameters:
  // year: testTime.year,
  // month: testTime.month,
  // day: testTime.day,

  jamaahOn: true,
  jamaahMethods: ['fixed', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
  jamaahOffsets: [
    [6, 0],
    [0, 0],
    [0, 5],
    [0, 5],
    [0, 5],
    [0, 0]
  ],
  // // jamaahPerPrayer: [false, false, false, true, false, false],
  // // testing options
  // hour: newtime.hour,
  // minute: newtime.minute,
  // second: newtime.second,
  // joinMaghrib: false,
  // joinDhuhr: false,
  // hijriOffset: 0,
);

main() {
  tz.initializeTimeZones();

  print(testTime);

  // print(location.currentPrayerTimes.dawn);

  jamaahTest(dublin);

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
