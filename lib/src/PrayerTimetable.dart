// import 'package:prayer_timetable/src/classes/SunnahTimes.dart';

import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/Prayers.dart';
import 'package:prayer_timetable/src/components/Calc.dart';
// import 'package:prayer_timetable/src/func/prayerTimetable.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:adhan_dart/adhan_dart.dart';

import 'package:prayer_timetable/src/func/helpers.dart';

class PrayerTimetable {
  // PrayersStructure prayers;
  Prayers? current;
  Prayers? next;
  Prayers? previous;
  PrayerTimetable? prayers;
  Sunnah? sunnah;
  // SunnahTimes sunnah;
  Calc? calc;
  Calc? calcToday;

  PrayerTimetable(
    String timezone,
    double lat,
    double lng,
    double angle, {
    double altitude = 0.1,
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int asrMethod = 1,
    double ishaAngle = 0,
    bool summerTimeCalc: true,
    DateTime? time,
    bool precision = false,
  }) {
    tz.setLocalLocation(tz.getLocation(timezone));

    // DateTime timestamp = DateTime.now().toUtc();
    DateTime timestamp = tz.TZDateTime.now(tz.getLocation(timezone));

    // UTC date
    // DateTime date = DateTime.utc(year ?? timestamp.year,
    //     month ?? timestamp.month, day ?? timestamp.day, 0, 0);
    // DateTime nowUtc = DateTime.now().toUtc();

    // Local dates needed for dst calc and local midnight past (0:00)
    DateTime date = tz.TZDateTime.from(
        DateTime(year ?? timestamp.year, month ?? timestamp.month,
            day ?? timestamp.day, hour ?? 12, minute ?? 0, second ?? 0),
        tz.getLocation(timezone));
    // DateTime date = DateTime.utc(
    //     year ?? timestamp.year,
    //     month ?? timestamp.month,
    //     day ?? timestamp.day,
    //     hour ?? 12,
    //     minute ?? 0,
    //     second ?? 0); // using noon of local date to avoid +- 1 hour

    // define now (local)
    // DateTime nowLocal = time ?? timestamp;
    //     DateTime now = time ?? timestamp;
    DateTime now = tz.TZDateTime.from(DateTime.now(), tz.getLocation(timezone));

    // ***** current, next and previous day
    DateTime dayCurrent = date;
    DateTime dayNext = date.add(Duration(days: 1));
    DateTime dayPrevious = date.subtract(Duration(days: 1));

    // ***** today, tomorrow and yesterday
    DateTime dayToday = now;
    DateTime dayTomorrow = dayToday.add(Duration(days: 1));
    DateTime dayYesterday = dayToday.subtract(Duration(days: 1));

    // DEFINITIONS
    Coordinates coordinates = Coordinates(lat, lng);
    CalculationParameters params = CalculationMethod.Other();
    params.highLatitudeRule = HighLatitudeRule.SeventhOfTheNight;
    params.madhab = asrMethod == 2 ? Madhab.Hanafi : Madhab.Shafi;
    // params.methodAdjustments = {'dhuhr': 0};
    params.fajrAngle = angle;
    params.ishaAngle = ishaAngle != null ? ishaAngle : angle;

    // print(date.toLocal());

    Prayers toPrayers(PrayerTimes prayerTimes) {
      Prayers prayers = new Prayers();
      int summerTime =
          (isDSTCalc(prayerTimes.date.toLocal()) && summerTimeCalc) ? 1 : 0;

      // (toLocal?)
      // prayers.dawn =
      //     prayerTimes.fajr.add(Duration(hours: timezone + summerTime));
      // prayers.sunrise =
      //     prayerTimes.sunrise.add(Duration(hours: timezone + summerTime));
      // prayers.midday =
      //     prayerTimes.dhuhr.add(Duration(hours: timezone + summerTime));
      // prayers.afternoon =
      //     prayerTimes.asr.add(Duration(hours: timezone + summerTime));
      // prayers.sunset =
      //     prayerTimes.maghrib.add(Duration(hours: timezone + summerTime));
      // prayers.dusk =
      //     prayerTimes.isha.add(Duration(hours: timezone + summerTime));
      //
      prayers.dawn =
          tz.TZDateTime.from(prayerTimes.fajr!, tz.getLocation(timezone));
      prayers.sunrise =
          tz.TZDateTime.from(prayerTimes.sunrise!, tz.getLocation(timezone));
      prayers.midday =
          tz.TZDateTime.from(prayerTimes.dhuhr!, tz.getLocation(timezone));
      prayers.afternoon =
          tz.TZDateTime.from(prayerTimes.asr!, tz.getLocation(timezone));
      prayers.sunset =
          tz.TZDateTime.from(prayerTimes.maghrib!, tz.getLocation(timezone));
      prayers.dusk =
          tz.TZDateTime.from(prayerTimes.isha!, tz.getLocation(timezone));
      return prayers;
    }

    // print(PrayerTimes(coordinates, dayCurrent, params).fajr);
    // ***** PRAYERS CURRENT, NEXT, PREVIOUS
    Prayers prayersCurrent = toPrayers(
        PrayerTimes(coordinates, dayCurrent, params, precision: precision));
    Prayers prayersNext = toPrayers(
        PrayerTimes(coordinates, dayNext, params, precision: precision));
    Prayers prayersPrevious = toPrayers(
        PrayerTimes(coordinates, dayPrevious, params, precision: precision));
    Prayers prayersToday = toPrayers(
        PrayerTimes(coordinates, dayToday, params, precision: precision));
    Prayers prayersTomorrow = toPrayers(
        PrayerTimes(coordinates, dayTomorrow, params, precision: precision));
    Prayers prayersYesterday = toPrayers(
        PrayerTimes(coordinates, dayYesterday, params, precision: precision));

    // int _summerTime = (isDSTCalc(now.toLocal()) && summerTimeCalc) ? 1 : 0;

    // define components
    this.prayers =
        PrayerTimetable.prayers(prayersCurrent, prayersNext, prayersPrevious);

    this.sunnah = Sunnah(now, prayersCurrent, prayersNext, prayersPrevious);
    // this.sunnah = SunnahTimes(PrayerTimes(coordinates, dayCurrent, params, precision: precision));

    // this.calc = Calc(now.add(Duration(hours: timezone + _summerTime)),
    //     prayersToday, prayersTomorrow, prayersYesterday);

    this.calcToday = Calc(
      now,
      prayersToday,
      prayersTomorrow,
      prayersYesterday,
      // jamaahOn: jamaahOn,
      // jamaahToday: jamaahToday,
      // jamaahTomorrow: jamaahTomorrow,
      // jamaahYesterday: jamaahYesterday,
      lat: lat,
      lng: lng,
    );

    this.calc = Calc(
      date,
      prayersCurrent,
      prayersNext,
      prayersPrevious,
      // jamaahOn: jamaahOn,
      // jamaahToday: jamaahToday,
      // jamaahTomorrow: jamaahTomorrow,
      // jamaahYesterday: jamaahYesterday,
      lat: lat,
      lng: lng,
    );
    //end
  }

  PrayerTimetable.prayers(Prayers prayersCurrent, Prayers prayersTomorrow,
      Prayers prayersYesterday) {
    current = prayersCurrent;
    next = prayersTomorrow;
    previous = prayersYesterday;
  }
}
