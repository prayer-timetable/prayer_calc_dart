import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/PrayerTimes.dart'
    as prayertimes;
import 'package:prayer_timetable/src/components/JamaahTimes.dart';
import 'package:prayer_timetable/src/components/Calc.dart';
import 'package:prayer_timetable/src/func/prayerTimetableAlt.dart';

class PrayerTimetableAlt {
  /// Prayer Times
  prayertimes.PrayerTimes currentPrayerTimes = prayertimes.PrayerTimes.now;
  prayertimes.PrayerTimes previousPrayerTimes = prayertimes.PrayerTimes.now;
  prayertimes.PrayerTimes nextPrayerTimes = prayertimes.PrayerTimes.now;

  /// Jamaah Times
  prayertimes.PrayerTimes currentJamaahTimes = prayertimes.PrayerTimes.now;
  prayertimes.PrayerTimes previousJamaahTimes = prayertimes.PrayerTimes.now;
  prayertimes.PrayerTimes nextJamaahTimes = prayertimes.PrayerTimes.now;

  /// Sunnah
  Sunnah? sunnah;

  /// Calculations based on set DateTime
  Calc? calc;

  /// Calculations with forced now for DateTime
  Calc? calcToday;

  int? dayOfYear;

  PrayerTimetableAlt(
    int timezone,
    double lat,
    double lng,
    double altitude,
    double angle, {
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? asrMethod,
    double? ishaAngle,
    bool summerTimeCalc: true,
    DateTime? time,
    bool? showSeconds,
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
    bool jamaahOn = false,
  }) {
    DateTime now = DateTime.now();
    DateTime beginingOfYear = DateTime(now.year); // Jan 1, 0:00

    // UTC date
    // DateTime date = DateTime.utc(year ?? timestamp.year,
    //     month ?? timestamp.month, day ?? timestamp.day, 0, 0);
    // DateTime nowUtc = DateTime.now().toUtc();

    // Local dates needed for dst calc and local midnight past (0:00)
    DateTime date = DateTime(
        year ?? now.year,
        month ?? now.month,
        day ?? now.day,
        hour ?? 12,
        minute ?? 0,
        second ?? 0); // using noon of local date to avoid +- 1 hour
    // define now (local)
    DateTime nowLocal = time ?? now;

    // ***** current, next and previous day
    DateTime dayCurrent = date;
    DateTime dayNext = date.add(Duration(days: 1));
    DateTime dayPrevious = date.subtract(Duration(days: 1));

    // ***** today, tomorrow and yesterday
    DateTime dayToday = time ?? now;
    DateTime dayTomorrow = dayToday.add(Duration(days: 1));
    DateTime dayYesterday = dayToday.subtract(Duration(days: 1));

    //	Day of Year current, next, previous
    // date needs to be utc for accurate calculation
    int dayOfYearCurrent = dayCurrent.difference(beginingOfYear).inDays;
    int dayOfYearNext = dayNext.difference(beginingOfYear).inDays;
    int dayOfYearPrevious = dayPrevious.difference(beginingOfYear).inDays;

    //	Day of Year today, tomorrow, previous
    // date needs to be utc for accurate calculation
    int dayOfYearToday = dayToday.difference(beginingOfYear).inDays;
    int dayOfYearTomorrow = dayTomorrow.difference(beginingOfYear).inDays;
    int dayOfYearYesterday = dayYesterday.difference(beginingOfYear).inDays;

    // ***** PRAYERS CURRENT, NEXT, PREVIOUS
    prayertimes.PrayerTimes _currentPrayerTimes = prayerTimetable(
      timezone: timezone,
      lat: lat,
      lng: lng,
      altitude: altitude,
      angle: angle,
      date: dayCurrent,
      dayOfYear: dayOfYearCurrent,
      asrMethod: asrMethod,
      ishaAngle: ishaAngle,
      summerTimeCalc: summerTimeCalc,
      showSeconds: showSeconds,
    );

    prayertimes.PrayerTimes _nextPrayerTimes = prayerTimetable(
      timezone: timezone,
      lat: lat,
      lng: lng,
      altitude: altitude,
      angle: angle,
      date: dayNext,
      dayOfYear: dayOfYearNext,
      asrMethod: asrMethod,
      ishaAngle: ishaAngle,
      summerTimeCalc: summerTimeCalc,
      showSeconds: showSeconds,
    );

    prayertimes.PrayerTimes _previousPrayerTimes = prayerTimetable(
      timezone: timezone,
      lat: lat,
      lng: lng,
      altitude: altitude,
      angle: angle,
      date: dayPrevious,
      dayOfYear: dayOfYearPrevious,
      asrMethod: asrMethod,
      ishaAngle: ishaAngle,
      summerTimeCalc: summerTimeCalc,
      showSeconds: showSeconds,
    );

    // ***** PRAYERS TODAY, TOMORROW, YESTERDAY
    prayertimes.PrayerTimes prayersToday = prayerTimetable(
      timezone: timezone,
      lat: lat,
      lng: lng,
      altitude: altitude,
      angle: angle,
      date: dayToday,
      dayOfYear: dayOfYearToday,
      asrMethod: asrMethod,
      ishaAngle: ishaAngle,
      summerTimeCalc: summerTimeCalc,
      showSeconds: showSeconds,
    );

    prayertimes.PrayerTimes prayersTomorrow = prayerTimetable(
      timezone: timezone,
      lat: lat,
      lng: lng,
      altitude: altitude,
      angle: angle,
      date: dayTomorrow,
      dayOfYear: dayOfYearTomorrow,
      asrMethod: asrMethod,
      ishaAngle: ishaAngle,
      summerTimeCalc: summerTimeCalc,
      showSeconds: showSeconds,
    );

    prayertimes.PrayerTimes prayersYesterday = prayerTimetable(
      timezone: timezone,
      lat: lat,
      lng: lng,
      altitude: altitude,
      angle: angle,
      date: dayYesterday,
      dayOfYear: dayOfYearYesterday,
      asrMethod: asrMethod,
      ishaAngle: ishaAngle,
      summerTimeCalc: summerTimeCalc,
      showSeconds: showSeconds,
    );

    // JAMAAH
    JamaahTimes _currentJamaahTimes =
        JamaahTimes(_currentPrayerTimes, jamaahMethods, jamaahOffsets);

    JamaahTimes _nextJamaahTimes =
        JamaahTimes(_nextPrayerTimes, jamaahMethods, jamaahOffsets);

    JamaahTimes _previousJamaahTimes =
        JamaahTimes(_previousPrayerTimes, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahToday =
        JamaahTimes(prayersToday, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahTomorrow =
        JamaahTimes(prayersTomorrow, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahYesterday =
        JamaahTimes(prayersYesterday, jamaahMethods, jamaahOffsets);

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

    this.calcToday = Calc(
      nowLocal,
      prayersToday,
      prayersTomorrow,
      prayersYesterday,
      jamaahOn,
      jamaahToday,
      jamaahTomorrow,
      jamaahYesterday,
      lat,
      lng,
    );

    this.calc = Calc(
      date,
      _currentPrayerTimes,
      _nextPrayerTimes,
      _previousPrayerTimes,
      jamaahOn,
      _currentJamaahTimes,
      _nextJamaahTimes,
      jamaahToday,
      lat,
      lng,
    );
    this.dayOfYear = dayOfYearCurrent;
    //end
  }
}
