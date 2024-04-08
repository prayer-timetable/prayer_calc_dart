import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_list_sarajevo.dart';
// ignore: unused_import
import 'test.dart';

String timezone = timezoneI;

DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 31, 14, 32, 45), tz.getLocation(timezone));
DateTime testTime = setTime;

PrayerTimetable list(DateTime testTime) => PrayerTimetable.list(
      year: testTime.year,
      month: testTime.month,
      day: testTime.day,
      timetableList: base,
      jamaahOn: true,
      // jamaahMethods: ['fixed', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
      jamaahMethods: ['afterthis', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
      jamaahOffsets: [
        // [6, 0],
        [0, 15],
        [0, 0],
        [0, 15],
        [0, 15],
        [0, 15],
        [0, 15]
      ],
      // jamaahPerPrayer: [false, false, true, true, false, false],
      timezone: timezone,
      useTz: false,
    );

PrayerTimetable location = list(testTime);

main() {
  tz.initializeTimeZones();
  print('\x1B[2J\x1B[0;0H'); // clear entire screen, move cursor to 0;0
  bool live = false;

  infoTest(testTime);

  if (!live) {
    jamaahTest(location, utils: true);

    // ignore: dead_code
  } else {
    liveTest(location);
  }
  ;
}
