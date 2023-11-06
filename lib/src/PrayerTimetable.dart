import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:timezone/timezone.dart' as tz;

import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/PrayerTimes.dart'
    as prayertimes;
import 'package:prayer_timetable/src/components/Calc.dart';
import 'package:prayer_timetable/src/components/JamaahTimes.dart';

// import 'package:timezone/data/latest.dart' as tz;

class PrayerTimetable {
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
    List<List<dynamic>> jamaahOffsets = const [
      [0, 0],
      [],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0]
    ],
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
    adhan.Coordinates coordinates = adhan.Coordinates(lat, lng);
    adhan.CalculationParameters params = adhan.CalculationMethod.Other();
    // params.highLatitudeRule = HighLatitudeRule.SeventhOfTheNight;
    params.highLatitudeRule = adhan.HighLatitudeRule.TwilightAngle;
    params.madhab = asrMethod == 2 ? adhan.Madhab.Hanafi : adhan.Madhab.Shafi;
    // params.methodAdjustments = {'dhuhr': 0};
    params.fajrAngle = angle;
    params.ishaAngle = ishaAngle ?? angle;

    // print(date.toLocal());

    prayertimes.PrayerTimes toPrayers(adhan.PrayerTimes prayerTimes) {
      prayertimes.PrayerTimes prayers = new prayertimes.PrayerTimes();

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
    prayertimes.PrayerTimes _currentPrayerTimes = toPrayers(adhan.PrayerTimes(
        coordinates, dayCurrent, params,
        precision: precision));
    prayertimes.PrayerTimes _nextPrayerTimes = toPrayers(
        adhan.PrayerTimes(coordinates, dayNext, params, precision: precision));
    prayertimes.PrayerTimes _previousPrayerTimes = toPrayers(adhan.PrayerTimes(
        coordinates, dayPrevious, params,
        precision: precision));
    prayertimes.PrayerTimes prayersToday = toPrayers(
        adhan.PrayerTimes(coordinates, dayToday, params, precision: precision));
    prayertimes.PrayerTimes prayersTomorrow = toPrayers(adhan.PrayerTimes(
        coordinates, dayTomorrow, params,
        precision: precision));
    prayertimes.PrayerTimes prayersYesterday = toPrayers(adhan.PrayerTimes(
        coordinates, dayYesterday, params,
        precision: precision));

    // int _summerTime = (isDSTCalc(now.toLocal()) && summerTimeCalc) ? 1 : 0;

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
      _currentPrayerTimes,
      _nextPrayerTimes,
      _previousPrayerTimes,
      jamaahOn,
      _currentJamaahTimes,
      _nextJamaahTimes,
      _previousJamaahTimes,
      lat,
      lng,
    );
    //end
  }
}
