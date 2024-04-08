import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/helpers.dart';
import 'package:prayer_timetable/src/func/monthGen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'src/timetable_list_sarajevo.dart';
// ignore: unused_import
import 'src/timetable_map_dublin.dart';
// ignore: unused_import
import 'src/timetable_map_dublin_leap.dart';
import 'test.dart';

main() {
  tz.initializeTimeZones();
  String timezone = timezoneS;
  double lat = latI;
  double lng = lngI;

  // DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
// DateTime setTime =
//     tz.TZDateTime.from(DateTime(now.year, now.month, now.day, 22, 3, 57), tz.getLocation(timezone));
  DateTime setTime =
      tz.TZDateTime.from(DateTime(2024, 3, 11, 10, 00, 55), tz.getLocation(timezone));
  DateTime testTime = setTime;

  // DateTime testTime = tz.TZDateTime(tz.getLocation(timezoneI), 2024, 3, 11, 13, 59, 55);

  List<List<Prayer>> list = monthGen(
    testTime,
    // timetable: testTime.year % 4 == 0 ? dublinLeap : dublin,
    list: base,
    hijriOffset: 0,
    timezone: timezone,
    useTz: false,
  );

  print('----------------------------------------------------------------------');
  print('Date        Fajr      Sunrise   Dhuhr     Asr       Maghrib   Isha');
  print('----------------------------------------------------------------------');

  for (List<Prayer> item in list) {
    print(
        '''${testTime.day == item[0].prayerTime.day ? green : noColor}${formatDate(item[0].prayerTime, [
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
  print(noColor);
}
