import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/monthGen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'src/timetable_list_sarajevo.dart';
// ignore: unused_import
import 'src/timetable_map_dublin.dart';
// ignore: unused_import
import 'src/timetable_map_dublin_leap.dart';

main() {
  tz.initializeTimeZones();

  // DateTime testTime = DateTime(2024, 3, 20, 13, 59, 55);
  DateTime testTime = tz.TZDateTime(tz.getLocation('Europe/Sarajevo'), 2024, 3, 15, 13, 59, 55);

  List<List<Prayer>> list = monthGen(
    testTime,
    // timetable: testTime.year % 4 == 0 ? dublinLeap : dublin,
    list: base,
    hijriOffset: 0,
    timezone: 'Europe/Sarajevo',
  );

  print('----------------------------------------------------------------------');
  print('Date        Fajr      Sunrise   Dhuhr     Asr       Maghrib   Isha');
  print('----------------------------------------------------------------------');

  for (List<Prayer> item in list) {
    print('''${formatDate(item[0].prayerTime, [
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
        ])}  ${formatDate(item[1].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}  ${formatDate(item[2].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}  ${formatDate(item[3].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}  ${formatDate(item[4].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}  ${formatDate(item[5].prayerTime, [HH, ':', nn, ':', ss])}''');
  }
  print('----------------------------------------------------------------------');
}
