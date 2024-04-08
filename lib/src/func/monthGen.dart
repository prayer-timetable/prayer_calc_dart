import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/prayers.dart';
// import 'timetable_map.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

List<List<Prayer>> monthGen(
  DateTime time, {
  Map<dynamic, dynamic>? timetable,
  List? list,
  int hijriOffset = 0,
  required String timezone,
  bool jamaahOn = false,
  List<String> jamaahMethods = defaultJamaahMethods,
  List<List<int>> jamaahOffsets = defaultJamaahOffsets,
  bool joinDhuhr = false,
  bool joinMaghrib = false,
  List<bool> jamaahPerPrayer = defaultJamaahPerPrayerOff,
  bool useTz = false,
}) {
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

  List<List<Prayer>> prayerList = List.generate(daysInMonth, (index) {
    return prayersGen(
      date.add(Duration(days: index)),
      timetableMap: timetable,
      timetableList: list,
      timezone: timezone,
      hijriOffset: hijriOffset,
      jamaahOn: jamaahOn,
      jamaahMethods: jamaahMethods,
      jamaahOffsets: jamaahOffsets,
      joinDhuhr: joinDhuhr,
      joinMaghrib: joinMaghrib,
      jamaahPerPrayer: jamaahPerPrayer,
      useTz: useTz,
    );
  });

  // print(list[0].afternoon);

  return prayerList;
}
