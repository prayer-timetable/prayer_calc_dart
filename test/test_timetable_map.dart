import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:prayer_timetable/src/components/CalcPrayers.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_list.dart';
import 'src/timetable_map_leap.dart';
// ignore: unused_import
import 'test.dart';

// ICCI
double latI = 53.3046593;
double longI = -6.2344076;
double altitudeI = 85;
double angleI = 14.6; //18
double iangleI = 14.6; //16
String timezoneI = 'Europe/Dublin';

// Sarajevo
double latS = 43.8563;
double longS = 18.4131;
double altitudeS = 518;
double angleS = 14.6; //iz =19
double iangleS = 14.6; // iz = 17
String timezoneS = 'Europe/Sarajevo';

DateTime now = tz.TZDateTime.now(tz.getLocation(timezoneI));

DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 11, 14, 32, 45), tz.getLocation(timezoneI));

DateTime testTime = now;

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
      jamaahMethods: ['fixed', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
      jamaahOffsets: [
        [6, 0],
        [0, 0],
        [0, 15],
        [0, 15],
        [0, 15],
        [0, 15]
      ],
      // joinDhuhr: true,
      // joinMaghrib: true,

      jamaahPerPrayer: [false, false, true, true, false, false],
      // // testing options
      // hour: newtime.hour,
      // minute: newtime.minute,
      // second: newtime.second,

      // hijriOffset: 0,
    );

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
    // jamaahTest(map);
    // jamaahTest(list);
    jamaahTest(calc(testTime));

    // ignore: dead_code
  } else {
    liveTest(location, testTime);
  }
  ;
}

// main() => timetableTest(location);


// exports.colors = {
//   pass: 90,
//   fail: 31,
//   'bright pass': 92,
//   'bright fail': 91,
//   'bright yellow': 93,
//   pending: 36,
//   suite: 0,
//   'error title': 0,
//   'error message': 31,
//   'error stack': 90,
//   checkmark: 32,
//   fast: 90,
//   medium: 33,
//   slow: 31,
//   green: 32,
//   light: 90,
//   'diff gutter': 90,
//   'diff added': 32,
//   'diff removed': 31
// };