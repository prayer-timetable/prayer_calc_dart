import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/prayers.dart';
// import 'timetable_map.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// import 'package:hijri/digits_converter.dart';
// import 'package:hijri/hijri_array.dart';
import 'package:hijri/hijri_calendar.dart';

List<List<Prayer>> monthHijriGen(
  DateTime time, {
  Map<dynamic, dynamic>? timetable,
  List? list,
  List? differences,
  TimetableCalc? calc,
  int hijriOffset = 0,
  required String timezone,
  bool jamaahOn = false,
  List<String> jamaahMethods = defaultJamaahMethods,
  List<List<int>> jamaahOffsets = defaultJamaahOffsets,
  bool joinDhuhr = false,
  bool joinMaghrib = false,
  List<bool> jamaahPerPrayer = defaultJamaahPerPrayerOff,
  // bool useTz = false,
}) {
  /// Date
  DateTime date = tz.TZDateTime.from(
      DateTime(time.year, time.month, time.day)
          .add(Duration(hours: 3)), // making sure it is after 1 am for time change
      tz.getLocation(timezone));

  var hTimeBase = HijriCalendar.fromDate(date);

  // First of the hijri month
  var hTime = hTimeBase;
  hTime.hDay = 1;

  int hYear = hTime.hYear;
  int hMonth = hTime.hMonth;
  int hDay = hTime.hDay;

  // print('$hYear $hMonth $hDay');

  int daysInHijriMonth = hTime.lengthOfMonth;

  var g_date = HijriCalendar();
  DateTime startDate = g_date.hijriToGregorian(hYear, hMonth, hDay).add(Duration(hours: 3));

  List<List<Prayer>> prayerList = List.generate(daysInHijriMonth, (index) {
    return prayersGen(
      startDate.add(Duration(days: index)),
      timetableMap: timetable,
      timetableList: list,
      differences: differences,
      timetableCalc:
          calc != null ? calc.copyWith(date: startDate.add(Duration(days: index))) : null,
      timezone: timezone,
      hijriOffset: hijriOffset,
      jamaahOn: jamaahOn,
      jamaahMethods: jamaahMethods,
      jamaahOffsets: jamaahOffsets,
      joinDhuhr: joinDhuhr,
      joinMaghrib: joinMaghrib,
      jamaahPerPrayer: jamaahPerPrayer,
      // useTz: useTz,
    );
  });

  return prayerList;
}
