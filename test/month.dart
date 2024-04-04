import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/monthMap.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'src/timetable_map_dublin.dart';
import 'src/timetable_map_dublin_leap.dart';

main() {
  tz.initializeTimeZones();

  tz.TZDateTime testTime = tz.TZDateTime(tz.getLocation('Europe/Dublin'), 2024, 3, 20, 13, 59, 55);

  List<PrayerTimes> list =
      monthMap(testTime, testTime.year % 4 == 0 ? dublinLeap : dublin, hijriOffset: 0);

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
