import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:prayer_timetable/src/components/TimetableCalc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ignore: unused_import
import 'test.dart';

String timezone = timezoneI;

DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 31, 14, 32, 45), tz.getLocation(timezone));
DateTime testTime = setTime;

TimetableCalc timetableCalc = TimetableCalc(
  // testTime,
  testTime,
  timezone: timezone,
  lat: latI,
  long: lngI,
  madhab: 'shafi',
  precision: true,
);

PrayerTimetable calc(DateTime testTime) => PrayerTimetable.calc(
    year: testTime.year,
    month: testTime.month,
    day: testTime.day,
    timetableCalc: timetableCalc,
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
    timezone: timezone);

PrayerTimetable location = calc(testTime);

main() {
  tz.initializeTimeZones();
  print('\x1B[2J\x1B[0;0H'); // clear entire screen, move cursor to 0;0
  bool live = false;

  infoTest(testTime);

  if (!live) {
    jamaahTest(location);

    // ignore: dead_code
  } else {
    liveTest(location);
  }
  ;
}
