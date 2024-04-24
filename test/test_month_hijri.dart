import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/helpers.dart';
import 'package:prayer_timetable/src/func/monthHijriGen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// ignore: unused_import
import 'src/timetable_map_dublin.dart';
// ignore: unused_import
import 'src/timetable_map_dublin_leap.dart';
import 'test.dart';

String timezone = timezoneI;
double lat = latI;
double lng = lngI;

DateTime testTime = tz.TZDateTime(tz.getLocation(timezone), 2024, 3, 15, 13, 59, 55);

// params.madhab = Madhab.Hanafi;
// params.adjustments.fajr = 2;

TimetableCalc calc = TimetableCalc(
  date: testTime,
  timezone: timezone,
  lat: lat,
  lng: lng,
  precision: true,
  fajrAngle: 14.6,
);

List<List<Prayer>> list = monthHijriGen(
  1445, 9,
  // calc: calc,
  timetable: testTime.year % 4 == 0 ? dublinLeap : dublin,
  // list: base,
  hijriOffset: 0,
  timezone: timezone,
);

main() {
  tz.initializeTimeZones();

  // print(list);
  // print('done');

  // print(testTime);

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
}
