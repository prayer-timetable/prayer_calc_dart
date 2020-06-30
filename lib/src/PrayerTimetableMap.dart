import 'package:prayer_calc/src/components/Sunnah.dart';
import 'package:prayer_calc/src/components/Prayers.dart';
import 'package:prayer_calc/src/components/Durations.dart';
import 'package:prayer_calc/src/func/prayerTimetableMap.dart';
import 'package:prayer_calc/src/func/prayerTimetableMapJamaah.dart';

class PrayerTimetableMap {
  // PrayersStructure prayers;
  Prayers current;
  Prayers previous;
  Prayers next;
  PrayerTimetableMap prayers;
  PrayerTimetableMap jamaah;
  Sunnah sunnah;
  Durations durations;
  // Jamaah jamaahPrayer;

  PrayerTimetableMap(
    Map timetable, {
    int year,
    int month,
    int day,
    int hijriOffset,
    bool summerTimeCalc = true,
    bool jamaahOn = false,
    List<String> jamaahMethods,
    List<List<int>> jamaahOffsets,
    // for testing:
    int hour,
    int minute,
    int second,
  }) {
    DateTime timestamp = DateTime.now();
    DateTime beginingOfYear = DateTime(timestamp.year); // Jan 1, 0:00

    // Local dates needed for dst calc and local midnight past (0:00)
    DateTime date = DateTime(
      year ?? timestamp.year,
      month ?? timestamp.month,
      day ?? timestamp.day,
      hour ?? 12,
      minute ?? 0,
      second ?? 0,
    ); // using noon of local date to avoid +- 1 hour
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
      hijriOffset: hijriOffset ?? 0,
      date: current,
    );

    Prayers prayersNext = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: next,
    );

    Prayers prayersPrevious = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: previous,
    );

    // ***** PRAYERS TODAY, TOMORROW, YESTERDAY
    Prayers prayersToday = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: today,
    );

    Prayers prayersTomorrow = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: tomorrow,
    );

    Prayers prayersYesterday = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: yesterday,
    );

    // JAMAAH
    Prayers jamaahCurrent = jamaahOn
        ? jamaahTimetable(prayersCurrent, jamaahMethods, jamaahOffsets)
        : prayersCurrent;

    Prayers jamaahNext = jamaahOn
        ? jamaahTimetable(prayersNext, jamaahMethods, jamaahOffsets)
        : prayersNext;

    Prayers jamaahPrevious = jamaahOn
        ? jamaahTimetable(prayersPrevious, jamaahMethods, jamaahOffsets)
        : prayersPrevious;

    Prayers jamaahToday = jamaahOn
        ? jamaahTimetable(prayersToday, jamaahMethods, jamaahOffsets)
        : prayersCurrent;

    Prayers jamaahTomorrow = jamaahOn
        ? jamaahTimetable(prayersTomorrow, jamaahMethods, jamaahOffsets)
        : prayersNext;

    Prayers jamaahYesterday = jamaahOn
        ? jamaahTimetable(prayersYesterday, jamaahMethods, jamaahOffsets)
        : prayersPrevious;

    // define components
    this.prayers = PrayerTimetableMap.prayers(
        prayersCurrent, prayersNext, prayersPrevious);

    this.jamaah =
        PrayerTimetableMap.prayers(jamaahCurrent, jamaahNext, jamaahPrevious);

    this.sunnah =
        Sunnah(nowLocal, prayersCurrent, prayersNext, prayersPrevious);

    this.durations = Durations(
        nowLocal, prayersToday, prayersTomorrow, prayersYesterday,
        jamaahOn: jamaahOn,
        jamaahToday: jamaahToday,
        jamaahTomorrow: jamaahTomorrow,
        jamaahYesterday: jamaahYesterday);

    //end
  }

  PrayerTimetableMap.prayers(
      Prayers prayersCurrent, Prayers prayersNext, Prayers prayersPrevious) {
    current = prayersCurrent;
    next = prayersNext;
    previous = prayersPrevious;
  }
}
