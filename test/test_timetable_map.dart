import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

import 'package:prayer_timetable/src/PrayerTimetableMap.dart';
import 'src/timetable_map.dart';
import 'test.dart';

DateTime testTime = tz.TZDateTime.from(DateTime(2021, 4, 14, 17, 15, 45),
    tz.getLocation('Europe/Dublin')); // asr jamaah pending

// **************** Today *****************
// dawn:		  2021-04-14 04:46:00.000
// sunrise:	  2021-04-14 06:27:00.000
// midday:		2021-04-14 13:27:00.000
// afternoon:	2021-04-14 17:14:00.000
// sunset:		2021-04-14 20:24:00.000
// dusk:		  2021-04-14 21:59:00.000
// *********** Today Jamaah *************
// dawn:		  2021-04-14 06:00:00.000
// sunrise:	  2021-04-14 06:27:00.000
// midday:		2021-04-14 13:32:00.000
// afternoon:	2021-04-14 17:19:00.000
// sunset:		2021-04-14 20:29:00.000
// dusk:		  2021-04-14 21:59:00.000

PrayerTimetableMap dublin(newtime) => PrayerTimetableMap(
      timetableDublin,
      // optional parameters:
      year: testTime.year,
      month: testTime.month,
      day: testTime.day,

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
        [6, 0],
        [],
        [0, 5],
        [0, 5],
        [0, 5],
        [0, 0]
      ],
      jamaahPerPrayer: [false, false, false, true, false, false],
      // testing options
      testing: true,
      hour: newtime.hour,
      minute: newtime.minute,
      second: newtime.second,
      joinMaghrib: false,
      joinDhuhr: false,
    );

PrayerTimetableMap location = dublin(testTime);

main() {
  tz.initializeTimeZones();

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
