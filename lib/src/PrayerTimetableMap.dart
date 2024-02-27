// import 'package:timezone/data/latest.dart' as tz;
// import 'package:prayer_timetable/src/classes/PrayerTimesCalc.dart';
import 'package:prayer_timetable/src/func/monthHijriMap.dart';
import 'package:prayer_timetable/src/func/monthMap.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/PrayerTimes.dart';
import 'package:prayer_timetable/src/components/Calc.dart';
import 'package:prayer_timetable/src/components/JamaahTimes.dart';

import 'package:prayer_timetable/src/func/prayerTimetableMap.dart';

/// Uses predefined map for prayers
class PrayerTimetableMap {
  /// Prayer Times
  PrayerTimes currentPrayerTimes = PrayerTimes.now;
  PrayerTimes previousPrayerTimes = PrayerTimes.now;
  PrayerTimes nextPrayerTimes = PrayerTimes.now;

  /// Jamaah Times
  PrayerTimes currentJamaahTimes = PrayerTimes.now;
  PrayerTimes previousJamaahTimes = PrayerTimes.now;
  PrayerTimes nextJamaahTimes = PrayerTimes.now;

  /// Sunnah times - midnight and last third
  late Sunnah sunnah;

  /// Calculations based on set DateTime
  late Calc calc;

  /// Prayer times for the current month
  late List<PrayerTimes> monthPrayerTimes;

  /// Prayer times for the current hijri month
  late List<PrayerTimes> monthHijriPrayerTimes;

  /// Calculations with forced now for DateTime
  Calc? calcToday;

  PrayerTimetableMap(
    Map timetable, {
    String timezone = 'Europe/Dublin',
    int? year,
    int? month,
    int? day,
    int? hijriOffset,
    bool summerTimeCalc = true,

    /// Enables jamaah times globaly.
    bool jamaahOn = false,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    List<bool>? jamaahPerPrayer,
    //  = const [
    //   false,
    //   false,
    //   false,
    //   false,
    //   false,
    //   false
    // ],
    List<String> jamaahMethods = const [
      'afterthis',
      '',
      'afterthis',
      'afterthis',
      'afterthis',
      'afterthis'
    ],
    List<List<dynamic>> jamaahOffsets = const [
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
    double lat = 0,
    double lng = 0,
    bool joinMaghrib = false,
    bool joinDhuhr = false,
  }) {
    tz.setLocalLocation(tz.getLocation(timezone));

    DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
    // DateTime now = tz.TZDateTime.from(DateTime.now(), tz.getLocation(timezone));

    DateTime date = tz.TZDateTime.from(
        DateTime(
          year ?? now.year,
          month ?? now.month,
          day ?? now.day,
          hour ?? now.hour,
          minute ?? now.minute,
          second ?? now.second,
        ),
        tz.getLocation(timezone));

    // ***** current, next and previous day
    DateTime current = date;
    DateTime next = current.add(Duration(days: 1));
    DateTime previous = current.subtract(Duration(days: 1));

    // ***** today, tomorrow and yesterday
    DateTime today = now;
    DateTime tomorrow = now.add(Duration(days: 1));
    DateTime yesterday = now.subtract(Duration(days: 1));

    // ***** PRAYERS CURRENT, NEXT, PREVIOUS
    PrayerTimes prayersCurrent = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: current,
      timezone: timezone,
    );

    PrayerTimes prayersNext = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: next,
      timezone: timezone,
    );

    PrayerTimes prayersPrevious = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: previous,
      timezone: timezone,
    );

    // ***** PRAYERS TODAY, TOMORROW, YESTERDAY
    PrayerTimes prayersToday = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: today,
      timezone: timezone,
    );

    PrayerTimes prayersTomorrow = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: tomorrow,
      timezone: timezone,
    );

    PrayerTimes prayersYesterday = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: yesterday,
      timezone: timezone,
    );

    // JAMAAH
    JamaahTimes jamaahCurrent =
        JamaahTimes(prayersCurrent, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahNext =
        JamaahTimes(prayersNext, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahPrevious =
        JamaahTimes(prayersPrevious, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahToday =
        JamaahTimes(prayersToday, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahTomorrow =
        JamaahTimes(prayersTomorrow, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahYesterday =
        JamaahTimes(prayersYesterday, jamaahMethods, jamaahOffsets);

    // JOINING
    if (joinMaghrib) {
      prayersToday.dusk = prayersToday.sunset;
      prayersYesterday.dusk = prayersYesterday.sunset;
      prayersTomorrow.dusk = prayersTomorrow.sunset;
      prayersCurrent.dusk = prayersCurrent.sunset;
      prayersPrevious.dusk = prayersPrevious.sunset;
      prayersNext.dusk = prayersNext.sunset;

      jamaahToday.dusk = jamaahToday.sunset;
      jamaahYesterday.dusk = jamaahYesterday.sunset;
      jamaahTomorrow.dusk = jamaahTomorrow.sunset;
      jamaahCurrent.dusk = jamaahCurrent.sunset;
      jamaahPrevious.dusk = jamaahPrevious.sunset;
      jamaahNext.dusk = jamaahNext.sunset;
    }
    if (joinDhuhr) {
      prayersToday.afternoon = prayersToday.midday;
      prayersYesterday.afternoon = prayersYesterday.midday;
      prayersTomorrow.afternoon = prayersTomorrow.midday;
      prayersCurrent.afternoon = prayersCurrent.midday;
      prayersPrevious.afternoon = prayersPrevious.midday;
      prayersNext.afternoon = prayersNext.midday;

      jamaahToday.afternoon = jamaahToday.midday;
      jamaahYesterday.afternoon = jamaahYesterday.midday;
      jamaahTomorrow.afternoon = jamaahTomorrow.midday;
      jamaahCurrent.afternoon = jamaahCurrent.midday;
      jamaahPrevious.afternoon = jamaahPrevious.midday;
      jamaahNext.afternoon = jamaahNext.midday;
    }

    /// ********************************************
    /// Check if jammah is before the prayer
    /// ********************************************
    // Today
    if (jamaahToday.dawn.isBefore(prayersToday.dawn))
      prayersToday.dawn = jamaahToday.dawn;
    if (jamaahToday.midday.isBefore(prayersToday.midday))
      prayersToday.midday = jamaahToday.midday;
    if (jamaahToday.afternoon.isBefore(prayersToday.afternoon))
      prayersToday.afternoon = jamaahToday.afternoon;
    if (jamaahToday.sunset.isBefore(prayersToday.sunset))
      prayersToday.sunset = jamaahToday.sunset;
    if (jamaahToday.dusk.isBefore(prayersToday.dusk))
      prayersToday.dusk = jamaahToday.dusk;
    // Yesterday
    if (jamaahYesterday.dawn.isBefore(prayersYesterday.dawn))
      prayersYesterday.dawn = jamaahYesterday.dawn;
    if (jamaahYesterday.midday.isBefore(prayersYesterday.midday))
      prayersYesterday.midday = jamaahYesterday.midday;
    if (jamaahYesterday.afternoon.isBefore(prayersYesterday.afternoon))
      prayersYesterday.afternoon = jamaahYesterday.afternoon;
    if (jamaahYesterday.sunset.isBefore(prayersYesterday.sunset))
      prayersYesterday.sunset = jamaahYesterday.sunset;
    if (jamaahYesterday.dusk.isBefore(prayersYesterday.dusk))
      prayersYesterday.dusk = jamaahYesterday.dusk;
    // Tomorrow
    if (jamaahYesterday.dawn.isBefore(prayersTomorrow.dawn))
      prayersTomorrow.dawn = jamaahTomorrow.dawn;
    if (jamaahTomorrow.midday.isBefore(prayersTomorrow.midday))
      prayersTomorrow.midday = jamaahTomorrow.midday;
    if (jamaahTomorrow.afternoon.isBefore(prayersTomorrow.afternoon))
      prayersTomorrow.afternoon = jamaahTomorrow.afternoon;
    if (jamaahTomorrow.sunset.isBefore(prayersTomorrow.sunset))
      prayersTomorrow.sunset = jamaahTomorrow.sunset;
    if (jamaahTomorrow.dusk.isBefore(prayersTomorrow.dusk))
      prayersTomorrow.dusk = jamaahTomorrow.dusk;

    // Current
    if (jamaahYesterday.dawn.isBefore(prayersCurrent.dawn))
      prayersCurrent.dawn = jamaahCurrent.dawn;
    if (jamaahCurrent.midday.isBefore(prayersCurrent.midday))
      prayersCurrent.midday = jamaahCurrent.midday;
    if (jamaahCurrent.afternoon.isBefore(prayersCurrent.afternoon))
      prayersCurrent.afternoon = jamaahCurrent.afternoon;
    if (jamaahCurrent.sunset.isBefore(prayersCurrent.sunset))
      prayersCurrent.sunset = jamaahCurrent.sunset;
    if (jamaahCurrent.dusk.isBefore(prayersCurrent.dusk))
      prayersCurrent.dusk = jamaahCurrent.dusk;

    // Next
    if (jamaahYesterday.dawn.isBefore(prayersNext.dawn))
      prayersNext.dawn = jamaahNext.dawn;
    if (jamaahNext.midday.isBefore(prayersNext.midday))
      prayersNext.midday = jamaahNext.midday;
    if (jamaahNext.afternoon.isBefore(prayersNext.afternoon))
      prayersNext.afternoon = jamaahNext.afternoon;
    if (jamaahNext.sunset.isBefore(prayersNext.sunset))
      prayersNext.sunset = jamaahNext.sunset;
    if (jamaahNext.dusk.isBefore(prayersNext.dusk))
      prayersNext.dusk = jamaahNext.dusk;

    // Previous
    if (jamaahYesterday.dawn.isBefore(prayersPrevious.dawn))
      prayersPrevious.dawn = jamaahPrevious.dawn;
    if (jamaahPrevious.midday.isBefore(prayersPrevious.midday))
      prayersPrevious.midday = jamaahPrevious.midday;
    if (jamaahPrevious.afternoon.isBefore(prayersPrevious.afternoon))
      prayersPrevious.afternoon = jamaahPrevious.afternoon;
    if (jamaahPrevious.sunset.isBefore(prayersPrevious.sunset))
      prayersPrevious.sunset = jamaahPrevious.sunset;
    if (jamaahPrevious.dusk.isBefore(prayersPrevious.dusk))
      prayersPrevious.dusk = jamaahPrevious.dusk;

    /// ********************************************

    /// Define prayer times
    this.currentPrayerTimes = prayersCurrent;
    this.nextPrayerTimes = prayersNext;
    this.previousPrayerTimes = prayersPrevious;

    /// Define jamaah times
    this.currentJamaahTimes =
        JamaahTimes(prayersCurrent, jamaahMethods, jamaahOffsets);
    this.nextJamaahTimes =
        JamaahTimes(prayersNext, jamaahMethods, jamaahOffsets);
    this.previousJamaahTimes =
        JamaahTimes(prayersPrevious, jamaahMethods, jamaahOffsets);

    /// Define sunnah
    this.sunnah = Sunnah(now, prayersCurrent, prayersNext, prayersPrevious);

    /// Today only.
    this.calcToday = Calc(
      /// TNow
      now,
      prayersToday,
      prayersTomorrow,
      prayersYesterday,
      jamaahOn,
      jamaahToday,
      jamaahTomorrow,
      jamaahYesterday,
      lat,
      lng,
      jamaahPerPrayer,
    );

    this.calc = Calc(
      date,
      prayersCurrent,
      prayersNext,
      prayersPrevious,
      jamaahOn,
      jamaahCurrent,
      jamaahNext,
      jamaahPrevious,
      lat,
      lng,
      jamaahPerPrayer,
    );

    this.monthPrayerTimes = monthMap(date, timetable,
        hijriOffset: hijriOffset ?? 0, timezone: timezone);

    this.monthHijriPrayerTimes = monthHijriMap(date, timetable,
        hijriOffset: hijriOffset ?? 0, timezone: timezone);
    //end
    //
  }

  // PrayerTimetableMap.prayers(PrayerTimes _currentPrayerTimes,
  //     PrayerTimes _nextPrayerTimes, PrayerTimes _previousPrayerTimes) {
  //   current = _currentPrayerTimes;
  //   next = _nextPrayerTimes;
  //   previous = _previousPrayerTimes;
  // }
  // PrayerTimetableMap.jamaah(
  //     Jamaah jamaahCurrent, Jamaah jamaahNext, Jamaah jamaahPrevious) {
  //   current = jamaahCurrent;
  //   next = jamaahNext;
  //   previous = jamaahPrevious;
  // }
}
