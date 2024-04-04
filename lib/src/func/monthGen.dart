import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/prayerTimes.dart';
// import 'timetable_map.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

List<PrayerTimes> monthGen(DateTime time,
    {Map<dynamic, dynamic>? timetable, List? list, int hijriOffset = 0, required String timezone}) {
  /// Date
  DateTime date = tz.TZDateTime.from(
      DateTime(time.year, time.month)
          .add(Duration(hours: 3)), // making sure it is after 1 am for time change
      tz.getLocation(timezone));

  // int daysInYear = date.year % 4 == 0 ? 366 : 365;
  int daysInMonth = DateTime(date.year, date.month + 1, 0).day;

  // print(daysInYear);
  // print(daysInMonth);
  // print(date);

  // var days = [for (var i = 1; i <= daysInMonth; i++) i];

  // print(days);

  List<PrayerTimes> prayerList = List.generate(daysInMonth, (index) {
    return prayerTimesGen(
      date.add(Duration(days: index)),
      // timetableMap: timetable,
      timetableList: list,

      timezone: timezone,
      hijriOffset: hijriOffset,
    );
  });

  // print(list[0].afternoon);

  return prayerList;
}
