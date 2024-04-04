import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/components/CalcPrayers.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/* *********************** */
/* MAIN FUNCTION           */
/* *********************** */
PrayerTimes prayerTimesGen(
  DateTime date, {
  Map? timetableMap,
  List? timetableList,
  CalcPrayers? calcPrayers,
  int hijriOffset = 0,
  required String timezone,
}) {
  /* *********************** */
  /* TIMES                   */
  /* *********************** */
  // print(timetableMap);
  // print('###');
  // print(date);

  print('date: $date');
  DateTime timestamp =
      tz.TZDateTime.from(date.add(Duration(days: hijriOffset)), tz.getLocation(timezone));

  // DateTime timestamp = date ?? DateTime.now();
  // TODO:
  int adjDst = isDSTCalc(timestamp) ? 1 : 0;
  // int adjDst = tz.getLocation(timezone).currentTimeZone.isDst ? 1 : 0;
  // print(tz.getLocation(timezone).currentTimeZone.isDst);

  // print('adjDst: $adjDst');

  /* *********************** */
  /* PRAYER LISTS            */
  /* *********************** */

  List<DateTime> prayerTimes = [];

  List prayerCount = Iterable<int>.generate(6).toList();

  /// Map
  if (timetableMap != null)
    prayerCount.forEach((prayerId) {
      DateTime prayerTime = tz.TZDateTime(
        tz.getLocation(timezone),
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timetableMap[timestamp.month.toString()][timestamp.day.toString()][prayerId][0],
        timetableMap[timestamp.month.toString()][timestamp.day.toString()][prayerId][1],
      ).add(Duration(hours: adjDst));

      // prayerTimes = [...prayerTimes, prayerTime];
      prayerTimes.insert(
        prayerId,
        prayerTime,
      );
    });

  /// List
  else if (timetableList != null) {
    DateTime lastMidnight =
        tz.TZDateTime.from(DateTime(date.year, date.month, date.day), tz.getLocation(timezone));

    // print(lastMidnight);

    prayerCount.forEach((prayerId) {
      // print(adjDst);
      DateTime prayerTime = lastMidnight
          .add(Duration(seconds: timetableList[timestamp.month - 1][timestamp.day - 1][prayerId]))
          .add(Duration(hours: adjDst));

      prayerTimes.insert(
        prayerId,
        prayerTime,
      );
    });
  }

  /// Calc
  else if (calcPrayers != null) {
    print(calcPrayers.prayerTimes!.fajr);
    DateTime fajr = tz.TZDateTime.from(calcPrayers.prayerTimes!.fajr!, tz.getLocation(timezone));
    DateTime sunrise =
        tz.TZDateTime.from(calcPrayers.prayerTimes!.sunrise!, tz.getLocation(timezone));
    DateTime dhuhr = tz.TZDateTime.from(calcPrayers.prayerTimes!.dhuhr!, tz.getLocation(timezone));
    DateTime asr = tz.TZDateTime.from(calcPrayers.prayerTimes!.asr!, tz.getLocation(timezone));
    DateTime maghrib =
        tz.TZDateTime.from(calcPrayers.prayerTimes!.maghrib!, tz.getLocation(timezone));
    DateTime isha = tz.TZDateTime.from(calcPrayers.prayerTimes!.isha!, tz.getLocation(timezone));

    prayerTimes = [fajr, sunrise, dhuhr, asr, maghrib, isha];
  }

  /// Else
  else {
    prayerCount.forEach((prayerId) {
      DateTime prayerTime = DateTime.now().add(Duration(hours: adjDst));
      prayerTimes.insert(
        prayerId,
        prayerTime,
      );
    });
  }

  PrayerTimes prayers = new PrayerTimes();
  prayers.dawn = prayerTimes[0];
  prayers.sunrise = prayerTimes[1];
  prayers.midday = prayerTimes[2];
  prayers.afternoon = prayerTimes[3];
  prayers.sunset = prayerTimes[4];
  prayers.dusk = prayerTimes[5];

  return prayers;
}

PrayerTimes prayerTimesValidate(
    {required PrayerTimes prayerTimes, required JamaahTimes jamaahTimes}) {
  PrayerTimes newPrayerTimes = prayerTimes;
  // Current
  if (jamaahTimes.dawn.isBefore(prayerTimes.dawn)) newPrayerTimes.dawn = jamaahTimes.dawn;
  if (jamaahTimes.midday.isBefore(prayerTimes.midday)) newPrayerTimes.midday = jamaahTimes.midday;
  if (jamaahTimes.afternoon.isBefore(prayerTimes.afternoon))
    newPrayerTimes.afternoon = jamaahTimes.afternoon;
  if (jamaahTimes.sunset.isBefore(prayerTimes.sunset)) newPrayerTimes.sunset = jamaahTimes.sunset;
  if (jamaahTimes.dusk.isBefore(prayerTimes.dusk)) newPrayerTimes.dusk = jamaahTimes.dusk;

  return newPrayerTimes;
}

List prayerJoining(
    {required joinDhuhr,
    required joinMaghrib,
    required PrayerTimes prayerTimes,
    required JamaahTimes jamaahTimes}) {
  // JOINING
  PrayerTimes newPrayerTimes = prayerTimes;
  JamaahTimes newJamaahTimes = jamaahTimes;

  if (joinMaghrib) {
    newPrayerTimes.dusk = newPrayerTimes.sunset;
    newJamaahTimes.dusk = newJamaahTimes.sunset;
  }
  if (joinDhuhr) {
    newPrayerTimes.afternoon = newPrayerTimes.midday;
    newJamaahTimes.afternoon = newJamaahTimes.midday;
  }

  return [newPrayerTimes, newJamaahTimes];
}
