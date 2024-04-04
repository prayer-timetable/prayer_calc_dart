import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_list_sarajevo.dart';
// ignore: unused_import
import 'test.dart';

DateTime now = tz.TZDateTime.now(tz.getLocation(timezoneI));
DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 11, 14, 32, 45), tz.getLocation(timezoneI));
DateTime testTime = now;

PrayerTimetable list(DateTime testTime) => PrayerTimetable.list(
      timetableList: base,
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
      jamaahPerPrayer: [false, false, true, true, false, false],
    );

PrayerTimetable location = list(testTime);

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
