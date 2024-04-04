import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:prayer_timetable/src/components/CalcPrayers.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ignore: unused_import
import 'test.dart';

DateTime now = tz.TZDateTime.now(tz.getLocation(timezoneI));
DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 11, 14, 32, 45), tz.getLocation(timezoneI));
DateTime testTime = now;

CalcPrayers calcPrayers = CalcPrayers(
  // testTime,
  testTime,
  timezone: timezoneI,
  lat: latI,
  long: longI,
  madhab: 'shafi',
  precision: true,
);

PrayerTimetable calc(DateTime testTime) => PrayerTimetable.calc(
      year: testTime.year,
      month: testTime.month,
      day: testTime.day,
      calcPrayers: calcPrayers,
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

PrayerTimetable location = calc(testTime);

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
