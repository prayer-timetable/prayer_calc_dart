import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:prayer_timetable/src/components/CalcPrayers.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_list.dart';
import 'src/timetable_map_leap.dart';
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

DateTime testTime =
    tz.TZDateTime.from(DateTime(2024, 3, 11, 14, 32, 45), tz.getLocation(timezoneI));

DateTime now = tz.TZDateTime.now(tz.getLocation(timezoneI));

PrayerTimetable map = PrayerTimetable.map(
  timetableMap: dublinLeap,
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

PrayerTimetable list = PrayerTimetable.list(
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
  now,
  timezone: timezoneI,
  lat: latI,
  long: longI,
  madhab: 'shafi',
  precision: true,
);

PrayerTimetable calc = PrayerTimetable.calc(
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

main() {
  tz.initializeTimeZones();

  // print(calcPrayers.prayerTimes.dhuhr);
  // print(calcPrayers.prayerTimes.asr);
  // print(calcPrayers.prayerTimes.maghrib);
  // print(calcPrayers.coordinates.latitude);
  // print(calcPrayers.coordinates.longitude);

  // print(testTime);

  // print(dublin.currentPrayerTimes.dawn);
  // print(dublin.currentJamaahTimes.dawn);

  // jamaahTest(map);
  // jamaahTest(list);
  jamaahTest(calc);

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
