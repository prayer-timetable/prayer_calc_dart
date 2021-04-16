// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:prayer_calc/src/components/Sunnah.dart';
import 'package:prayer_calc/src/components/Prayers.dart';
import 'package:prayer_calc/src/components/Durations.dart';
import 'package:prayer_calc/src/func/prayerTimetableMap.dart';
import 'package:prayer_calc/src/func/prayerTimetableMapJamaah.dart';

class PrayerTimetableMap {
  // PrayersStructure prayers;
  Prayers? current;
  Prayers? previous;
  Prayers? next;
  PrayerTimetableMap? prayers;
  PrayerTimetableMap? jamaah;
  Sunnah? sunnah;
  Durations? durations;
  Durations? durationsToday;
  // Jamaah jamaahPrayer;

  PrayerTimetableMap(
    Map timetable, {
    String timezone = 'Europe/Dublin',
    int? year,
    int? month,
    int? day,
    int? hijriOffset,
    bool summerTimeCalc = true,
    bool jamaahOn = false,
    List<String> jamaahMethods = const [
      'afterthis',
      '',
      'afterthis',
      'afterthis',
      'afterthis',
      'afterthis'
    ],
    List<List<int>> jamaahOffsets = const [
      [0, 0],
      [],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0]
    ],
    // for testing:
    bool testing = false,
    int? hour,
    int? minute,
    int? second,
  }) {
    tz.setLocalLocation(tz.getLocation(timezone));

    DateTime timestamp = tz.TZDateTime.now(tz.getLocation(timezone));

    DateTime date = tz.TZDateTime.from(
        DateTime(
          year ?? timestamp.year,
          month ?? timestamp.month,
          day ?? timestamp.day,
          hour ?? timestamp.hour,
          minute ?? timestamp.minute,
          second ?? timestamp.second,
        ),
        tz.getLocation(timezone));

    DateTime now = tz.TZDateTime.from(DateTime.now(), tz.getLocation(timezone));

    // ***** current, next and previous day
    DateTime current = date;
    DateTime next = current.add(Duration(days: 1));
    DateTime previous = current.subtract(Duration(days: 1));

    // ***** today, tomorrow and yesterday
    DateTime today = now;
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

    this.sunnah = Sunnah(now, prayersCurrent, prayersNext, prayersPrevious);

    this.durationsToday = Durations(
        now, prayersToday, prayersTomorrow, prayersYesterday,
        jamaahOn: jamaahOn,
        jamaahToday: jamaahToday,
        jamaahTomorrow: jamaahTomorrow,
        jamaahYesterday: jamaahYesterday);

    this.durations = Durations(
        date, prayersCurrent, prayersNext, prayersPrevious,
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
