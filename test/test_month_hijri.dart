import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/monthHijriGen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'src/timetable_list_sarajevo.dart';
import 'src/timetable_map_dublin.dart';
import 'src/timetable_map_dublin_leap.dart';

String yellow = '\u001b[93m';
String noColor = '\u001b[0m';
String green = '\u001b[32m';
// String red = '\u001b[31m';
String gray = '\u001b[90m';

main() {
  tz.initializeTimeZones();

  DateTime testTime = tz.TZDateTime(tz.getLocation('Europe/Sarajevo'), 2024, 3, 15, 13, 59, 55);

  List<PrayerTimes> list = monthHijriGen(
    testTime,
    // timetable: testTime.year % 4 == 0 ? dublinLeap : dublin,
    list: base,
    hijriOffset: 0,
    timezone: 'Europe/Sarajevo',
  );
  // print(list);
  // print('done');

  print(testTime);

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
