import 'package:prayer_calc/src/components/Sunnah.dart';
import 'package:prayer_calc/src/components/Prayers.dart';
import 'package:prayer_calc/src/components/Calc.dart';
import 'package:prayer_calc/src/func/prayerTimetableList.dart';

class PrayerTimetableList {
  // PrayersStructure prayers;
  Prayers? current;
  Prayers? previous;
  Prayers? next;
  PrayerTimetableList? prayers;
  Sunnah? sunnah;
  Calc? calc;

  PrayerTimetableList(
    List timetable, {
    List<int> difference = const [0, 0, 0, 0, 0, 0],
    int? year,
    int? month,
    int? day,
    int hijriOffset = 0,
    bool summerTimeCalc: true,
  }) {
    DateTime timestamp = DateTime.now();
    // DateTime beginingOfYear = DateTime(timestamp.year); // Jan 1, 0:00

    // Local date
    DateTime date = DateTime(year ?? timestamp.year, month ?? timestamp.month,
        day ?? timestamp.day, 0, 0);

    // Local dates needed for dst calc and local midnight past (0:00)
    DateTime dateLocal = DateTime(
        year ?? timestamp.year,
        month ?? timestamp.month,
        day ?? timestamp.day,
        12,
        0); // using noon of local date to avoid +- 1 hour
    // define now (local)
    DateTime nowLocal = DateTime.now();

    // ***** current, next and previous
    DateTime current = date;
    DateTime next = date.add(Duration(days: 1));
    DateTime previous = date.subtract(Duration(days: 1));

    // ***** today, tomorrow and yesterday
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime yesterday = today.subtract(Duration(days: 1));

    // ***** PRAYERS CURRENT, NEXT, PREVIOUS
    Prayers prayersCurrent = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: current,
    );

    Prayers prayersNext = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: next,
    );

    Prayers prayersPrevious = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: previous,
    );

    // ***** PRAYERS TODAY, TOMORROW, YESTERDAY
    Prayers prayersToday = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: today,
    );

    Prayers prayersTomorrow = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: tomorrow,
    );

    Prayers prayersYesterday = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: yesterday,
    );

    // define components
    this.prayers = PrayerTimetableList.prayers(
        prayersCurrent, prayersNext, prayersPrevious);

    this.sunnah =
        Sunnah(nowLocal, prayersCurrent, prayersNext, prayersPrevious);

    this.calc = Calc(nowLocal, prayersToday, prayersTomorrow, prayersYesterday);

    //end
  }

  PrayerTimetableList.prayers(
      Prayers prayersCurrent, Prayers prayersNext, Prayers prayersPrevious) {
    current = prayersCurrent;
    next = prayersNext;
    previous = prayersPrevious;
  }
}
