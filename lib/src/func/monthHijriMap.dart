import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/prayerTimetableMap.dart';
// import 'timetable_map.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// import 'package:hijri/digits_converter.dart';
// import 'package:hijri/hijri_array.dart';
import 'package:hijri/hijri_calendar.dart';

List<PrayerTimes> monthHijriMap(DateTime time, Map<dynamic, dynamic> timetable,
    {int hijriOffset = 0, String timezone = 'Europe/Dublin'}) {
  /// Date
  DateTime date = tz.TZDateTime.from(
      DateTime(time.year, time.month, time.day).add(
          Duration(hours: 3)), // making sure it is after 1 am for time change
      tz.getLocation(timezone));

  var hTimeBase = HijriCalendar.fromDate(date);

  // First of the hijri month
  var hTime = hTimeBase;
  hTime.hDay = 1;

  int hYear = hTime.hYear;
  int hMonth = hTime.hMonth;
  int hDay = hTime.hDay;

  print('$hYear $hMonth $hDay');

  int daysInHijriMonth = hTime.lengthOfMonth;

  var g_date = HijriCalendar();
  DateTime startDate =
      g_date.hijriToGregorian(hYear, hMonth, hDay).add(Duration(hours: 3));

  List<PrayerTimes> list = List.generate(daysInHijriMonth, (index) {
    // DateTime newtime =
    //     tz.TZDateTime.from(time, tz.getLocation('Europe/Dublin'));

    return prayerTimetable(
      timetable,
      // date: DateTime(date.year, date.month, index + 1),
      // date: tz.TZDateTime.from(DateTime(time.year, time.month, index + 1),
      //     tz.getLocation(timezone)),
      date: startDate.add(Duration(days: index)),
      timezone: timezone,
      hijriOffset: hijriOffset,
    );
  });

  return list;
}
