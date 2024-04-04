import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/monthHijriMap.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'src/timetable_map.dart';
import 'src/timetable_map_leap.dart';

String yellow = '\u001b[93m';
String noColor = '\u001b[0m';
String green = '\u001b[32m';
// String red = '\u001b[31m';
String gray = '\u001b[90m';

main() {
  tz.initializeTimeZones();

  tz.TZDateTime testTime = tz.TZDateTime(tz.getLocation('Europe/Dublin'), 2024, 3, 15, 13, 59, 55);

  List<PrayerTimes> list =
      monthHijriMap(testTime, testTime.year % 4 == 0 ? dublinLeap : dublin, hijriOffset: 0);
  // print(list);
  // print('done');
  print('----------------------------------------------------------------------');
  print('Date        Fajr      Sunrise   Dhuhr     Asr       Maghrib   Isha');
  print('----------------------------------------------------------------------');

  for (PrayerTimes item in list) {
    print('''${formatDate(item.dawn, [
          yyyy,
          '-',
          mm,
          '-',
          dd,
          '  ',
          HH,
          ':',
          nn,
          ':',
          ss
        ])}  ${formatDate(item.sunrise, [HH, ':', nn, ':', ss])}  ${formatDate(item.midday, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}  ${formatDate(item.afternoon, [HH, ':', nn, ':', ss])}  ${formatDate(item.sunset, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}  ${formatDate(item.dusk, [HH, ':', nn, ':', ss])}''');
  }
  print('----------------------------------------------------------------------');
}
