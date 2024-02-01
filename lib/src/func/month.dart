import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/prayerTimetableMap.dart';
// import 'timetable_map.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

List<PrayerTimes> monthMap(DateTime time, Map<dynamic, dynamic> timetable,
    {int hijriOffset = 0, String timezone = 'Europe/Dublin'}) {
  /// Date
  DateTime date = tz.TZDateTime.from(
      DateTime(time.year, time.month).add(
          Duration(hours: 3)), // making sure it is after 1 am for time change
      tz.getLocation(timezone));

  // int daysInYear = date.year % 4 == 0 ? 366 : 365;
  int daysInMonth = DateTime(date.year, date.month + 1, 0).day;

  // print(daysInYear);
  // print(daysInMonth);
  // print(date);

  // var days = [for (var i = 1; i <= daysInMonth; i++) i];

  // print(days);

  List<PrayerTimes> list = List.generate(daysInMonth, (index) {
    // DateTime newtime =
    //     tz.TZDateTime.from(time, tz.getLocation('Europe/Dublin'));

    return prayerTimetable(timetable,
        // date: DateTime(date.year, date.month, index + 1),
        // date: tz.TZDateTime.from(DateTime(time.year, time.month, index + 1),
        //     tz.getLocation(timezone)),
        date: date.add(Duration(days: index)),
        timezone: timezone,
        hijriOffset: hijriOffset);
  });

  // print(list[0].afternoon);

  return list;
}

// main() {
//   tz.initializeTimeZones();

//   monthMap(DateTime.now(), timetableDublin);
// }
