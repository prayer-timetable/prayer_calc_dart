// import 'package:timezone/data/latest.dart' as tz;
// import 'package:prayer_timetable/src/classes/PrayerTimesCalc.dart';
import 'package:prayer_timetable/src/func/month.dart';
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

  /// Calculations based on set DateTime
  late List<PrayerTimes> monthPrayerTimes;

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
    PrayerTimes _currentPrayerTimes = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: current,
      timezone: timezone,
    );

    PrayerTimes _nextPrayerTimes = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: next,
      timezone: timezone,
    );

    PrayerTimes _previousPrayerTimes = prayerTimetable(
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
        JamaahTimes(_currentPrayerTimes, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahNext =
        JamaahTimes(_nextPrayerTimes, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahPrevious =
        JamaahTimes(_previousPrayerTimes, jamaahMethods, jamaahOffsets);

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
      _currentPrayerTimes.dusk = _currentPrayerTimes.sunset;
      _previousPrayerTimes.dusk = _previousPrayerTimes.sunset;
      _nextPrayerTimes.dusk = _nextPrayerTimes.sunset;

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
      _currentPrayerTimes.afternoon = _currentPrayerTimes.midday;
      _previousPrayerTimes.afternoon = _previousPrayerTimes.midday;
      _nextPrayerTimes.afternoon = _nextPrayerTimes.midday;

      jamaahToday.afternoon = jamaahToday.midday;
      jamaahYesterday.afternoon = jamaahYesterday.midday;
      jamaahTomorrow.afternoon = jamaahTomorrow.midday;
      jamaahCurrent.afternoon = jamaahCurrent.midday;
      jamaahPrevious.afternoon = jamaahPrevious.midday;
      jamaahNext.afternoon = jamaahNext.midday;
    }

    /// Define prayer times
    this.currentPrayerTimes = _currentPrayerTimes;
    this.nextPrayerTimes = _nextPrayerTimes;
    this.previousPrayerTimes = _previousPrayerTimes;

    /// Define jamaah times
    this.currentJamaahTimes =
        JamaahTimes(_currentPrayerTimes, jamaahMethods, jamaahOffsets);
    this.nextJamaahTimes =
        JamaahTimes(_nextPrayerTimes, jamaahMethods, jamaahOffsets);
    this.previousJamaahTimes =
        JamaahTimes(_previousPrayerTimes, jamaahMethods, jamaahOffsets);

    /// Define sunnah
    this.sunnah = Sunnah(
        now, _currentPrayerTimes, _nextPrayerTimes, _previousPrayerTimes);

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
      _currentPrayerTimes,
      _nextPrayerTimes,
      _previousPrayerTimes,
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
