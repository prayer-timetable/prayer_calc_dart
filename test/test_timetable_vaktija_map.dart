import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/timetable_vaktija_bh.dart';
// ignore: unused_import
import 'test.dart';

String timezone = timezoneS;

DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
// DateTime setTime = tz.TZDateTime.from(DateTime(2024, 3, 31, 14, 32, 45), tz.getLocation(timezone));
DateTime setTime = DateTime(2024, 3, 31, 14, 32, 45);
DateTime testTime = now;

PrayerTimetable vaktijaMap(DateTime testTime) => PrayerTimetable.vaktija(
      year: testTime.year,
      month: testTime.month,
      day: testTime.day,
      hour: testTime.hour,
      minute: testTime.minute,
      second: testTime.second,
      timetableVaktijaMap: vaktija,
      cityNo: 33,
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
      // useTz: false,
    );

PrayerTimetable location = vaktijaMap(testTime);

main() {
  tz.initializeTimeZones();
  print('\x1B[2J\x1B[0;0H'); // clear entire screen, move cursor to 0;0
  bool live = false;

  // infoTest(testTime);

  // print(vaktija['vaktija']['months'][0]['days'][0]['vakat']);
  // print(vaktija['differences'][77]['months'][0]['vakat'][0]); // 0

  print(vaktija['locations'].length); // 118
  print(vaktija['locations'][77]); // Sarajevo
  // print(vaktija['locations'][55]); // Lopare
  // print(vaktija['locations'][33]); // Goražde

  if (!live) {
    jamaahTest(location,
        utils: false, jamaah: false, prayer: true, tomorrow: true, yesterday: true);

    // ignore: dead_code
  } else {
    liveTest(location);
  }
}
