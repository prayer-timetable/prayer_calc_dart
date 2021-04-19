import 'package:prayer_calc/src/components/Sunnah.dart';
import 'package:prayer_calc/src/components/Prayers.dart';
import 'package:prayer_calc/src/components/Calc.dart';
import 'package:prayer_calc/src/func/prayerTimetableAlt.dart';

class PrayerTimetable {
  // PrayersStructure prayers;
  Prayers? current;
  Prayers? next;
  Prayers? previous;
  PrayerTimetable? prayers;
  Sunnah? sunnah;
  Calc? calc;
  int? dayOfYear;

  PrayerTimetable(
    int timezone,
    double lat,
    double long,
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
      long: long,
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
      long: long,
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
      long: long,
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
      long: long,
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
      long: long,
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
      long: long,
      altitude: altitude,
      angle: angle,
      date: dayYesterday,
      dayOfYear: dayOfYearYesterday,
      asrMethod: asrMethod,
      ishaAngle: ishaAngle,
      summerTimeCalc: summerTimeCalc,
      showSeconds: showSeconds,
    );

    // define components
    this.prayers =
        PrayerTimetable.prayers(prayersCurrent, prayersNext, prayersPrevious);

    this.sunnah =
        Sunnah(nowLocal, prayersCurrent, prayersNext, prayersPrevious);

    this.calc = Calc(nowLocal, prayersToday, prayersTomorrow, prayersYesterday);

    this.dayOfYear = dayOfYearCurrent;
    //end
  }

  PrayerTimetable.prayers(Prayers prayersCurrent, Prayers prayersTomorrow,
      Prayers prayersYesterday) {
    current = prayersCurrent;
    next = prayersTomorrow;
    previous = prayersYesterday;
  }
}
