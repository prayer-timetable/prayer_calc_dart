// import 'package:prayer_timetable/src/classes/SunnahTimes.dart';

import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/Prayers.dart';
import 'package:prayer_timetable/src/components/Calc.dart';
import 'package:prayer_timetable/src/components/Jamaah.dart';

import 'package:adhan_dart/adhan_dart.dart';

class PrayerTimetable {
  // PrayersStructure prayers;
  Prayers? current;
  Prayers? next;
  Prayers? previous;
  PrayerTimetable? prayers;
  PrayerTimetable? jamaah;
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
    double? ishaAngle,
    bool summerTimeCalc: true,
    bool precision = false,
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
  }) {

    // DateTime timestamp = DateTime.now().toUtc();
    DateTime timestamp = DateTime.now();

    // UTC date
    // DateTime date = DateTime.utc(year ?? timestamp.year,
    //     month ?? timestamp.month, day ?? timestamp.day, 0, 0);
    // DateTime nowUtc = DateTime.now().toUtc();

    // Local dates needed for dst calc and local midnight past (0:00)
    DateTime date = 
        DateTime(year ?? timestamp.year, month ?? timestamp.month,
            day ?? timestamp.day, hour ?? 12, minute ?? 0, second ?? 0);
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
    DateTime now = DateTime.now();

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
    params.ishaAngle = ishaAngle ?? angle;

    // print(date.toLocal());

    Prayers toPrayers(PrayerTimes prayerTimes) {
      Prayers prayers = new Prayers();

      // TODO: summertime
      // int summerTime =
      //     (isDSTCalc(prayerTimes.date.toLocal()) && summerTimeCalc) ? 1 : 0;

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
          prayerTimes.fajr!;
      prayers.sunrise =
          prayerTimes.sunrise!;
      prayers.midday =
          prayerTimes.dhuhr!;
      prayers.afternoon =
          prayerTimes.asr!;
      prayers.sunset =
          prayerTimes.maghrib!;
      prayers.dusk =
          prayerTimes.isha!;
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
    this.prayers =
        PrayerTimetable.prayers(prayersCurrent, prayersNext, prayersPrevious);

    this.jamaah =
        PrayerTimetable.jamaah(jamaahCurrent, jamaahNext, jamaahPrevious);

    this.sunnah = Sunnah(now, prayersCurrent, prayersNext, prayersPrevious);
    // this.sunnah = SunnahTimes(PrayerTimes(coordinates, dayCurrent, params, precision: precision));

    // this.calc = Calc(now.add(Duration(hours: timezone + _summerTime)),
    //     prayersToday, prayersTomorrow, prayersYesterday);

    this.calcToday = Calc(
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
    );
    //end
  }

  PrayerTimetable.prayers(Prayers prayersCurrent, Prayers prayersTomorrow,
      Prayers prayersYesterday) {
    current = prayersCurrent;
    next = prayersTomorrow;
    previous = prayersYesterday;
  }
  PrayerTimetable.jamaah(
      Jamaah jamaahCurrent, Jamaah jamaahNext, Jamaah jamaahPrevious) {
    current = jamaahCurrent;
    next = jamaahNext;
    previous = jamaahPrevious;
  }
}
