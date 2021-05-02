import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/Prayers.dart';
import 'package:prayer_timetable/src/components/Jamaah.dart';
import 'package:prayer_timetable/src/components/Calc.dart';
import 'package:prayer_timetable/src/func/prayerTimetableAlt.dart';

class PrayerTimetableAlt {
  // PrayersStructure prayers;
  Prayers? current;
  Prayers? next;
  Prayers? previous;
  PrayerTimetableAlt? prayers;
  PrayerTimetableAlt? jamaah;

  Sunnah? sunnah;
  Calc? calc;
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
    DateTime timestamp = DateTime.now();
    DateTime beginingOfYear = DateTime(timestamp.year); // Jan 1, 0:00

    // UTC date
    // DateTime date = DateTime.utc(year ?? timestamp.year,
    //     month ?? timestamp.month, day ?? timestamp.day, 0, 0);
    // DateTime nowUtc = DateTime.now().toUtc();

    // Local dates needed for dst calc and local midnight past (0:00)
    DateTime date = DateTime(
        year ?? timestamp.year,
        month ?? timestamp.month,
        day ?? timestamp.day,
        hour ?? 12,
        minute ?? 0,
        second ?? 0); // using noon of local date to avoid +- 1 hour
    // define now (local)
    DateTime nowLocal = time ?? timestamp;

    // ***** current, next and previous day
    DateTime dayCurrent = date;
    DateTime dayNext = date.add(Duration(days: 1));
    DateTime dayPrevious = date.subtract(Duration(days: 1));

    // ***** today, tomorrow and yesterday
    DateTime dayToday = time ?? timestamp;
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
    Prayers prayersCurrent = prayerTimetable(
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

    Prayers prayersNext = prayerTimetable(
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

    Prayers prayersPrevious = prayerTimetable(
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
    Prayers prayersToday = prayerTimetable(
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

    Prayers prayersTomorrow = prayerTimetable(
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

    Prayers prayersYesterday = prayerTimetable(
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
    Jamaah jamaahCurrent = Jamaah(prayersCurrent, jamaahMethods, jamaahOffsets);

    Jamaah jamaahNext = Jamaah(prayersNext, jamaahMethods, jamaahOffsets);

    Jamaah jamaahPrevious =
        Jamaah(prayersPrevious, jamaahMethods, jamaahOffsets);

    Jamaah jamaahToday = Jamaah(prayersToday, jamaahMethods, jamaahOffsets);

    Jamaah jamaahTomorrow =
        Jamaah(prayersTomorrow, jamaahMethods, jamaahOffsets);

    Jamaah jamaahYesterday =
        Jamaah(prayersYesterday, jamaahMethods, jamaahOffsets);

    // define components
    this.prayers = PrayerTimetableAlt.prayers(
        prayersCurrent, prayersNext, prayersPrevious);

    this.jamaah =
        PrayerTimetableAlt.jamaah(jamaahCurrent, jamaahNext, jamaahPrevious);

    this.sunnah =
        Sunnah(nowLocal, prayersCurrent, prayersNext, prayersPrevious);

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
      prayersCurrent,
      prayersNext,
      prayersPrevious,
      jamaahOn,
      jamaahCurrent,
      jamaahNext,
      jamaahToday,
      lat,
      lng,
    );
    this.dayOfYear = dayOfYearCurrent;
    //end
  }

  PrayerTimetableAlt.prayers(Prayers prayersCurrent, Prayers prayersTomorrow,
      Prayers prayersYesterday) {
    current = prayersCurrent;
    next = prayersTomorrow;
    previous = prayersYesterday;
  }
  PrayerTimetableAlt.jamaah(
      Jamaah jamaahCurrent, Jamaah jamaahNext, Jamaah jamaahPrevious) {
    current = jamaahCurrent;
    next = jamaahNext;
    previous = jamaahPrevious;
  }
}
