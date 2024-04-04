import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/components/CalcPrayers.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/* *********************** */
/* MAIN FUNCTION           */
/* *********************** */
PrayerTimes prayerTimesGen({
  Map? timetableMap,
  List? timetableList,
  CalcPrayers? calcPrayers,
  int hijriOffset = 0,
  DateTime? date,
  String timezone = 'Europe/Dublin',
}) {
  /* *********************** */
  /* TIMES                   */
  /* *********************** */
  // print(timetableMap);
  // print('###');
  // print(date);
  DateTime timestamp = tz.TZDateTime.from(
      date != null
          ? date.add(Duration(days: hijriOffset))
          : DateTime.now().add(Duration(days: hijriOffset)),
      tz.getLocation(timezone));

  // DateTime timestamp = date ?? DateTime.now();
  // TODO:
  int adjDst = isDSTCalc(timestamp) ? 1 : 0;
  // print('adjDst: $adjDst');

  /* *********************** */
  /* PRAYER LISTS            */
  /* *********************** */

  List<DateTime> prayerTimes = [];

  List prayerCount = Iterable<int>.generate(6).toList();

  if (timetableMap != null)
    prayerCount.forEach((prayerId) {
      DateTime prayerTime = DateTime(
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
  else if (timetableList != null) {
    var lastMidnight = DateTime(timestamp.year, timestamp.month, timestamp.day);

    prayerCount.forEach((prayerId) {
      DateTime prayerTime = lastMidnight
          .add(Duration(seconds: timetableList[timestamp.month][timestamp.day][prayerId]))
          .add(Duration(hours: adjDst));
      prayerTimes.insert(
        prayerId,
        prayerTime,
      );
    });
  } else if (calcPrayers != null) {
    DateTime fajr = calcPrayers.prayerTimes.fajr!.add(Duration(hours: adjDst));
    DateTime sunrise = calcPrayers.prayerTimes.sunrise!.add(Duration(hours: adjDst));
    DateTime dhuhr = calcPrayers.prayerTimes.dhuhr!.add(Duration(hours: adjDst));
    DateTime asr = calcPrayers.prayerTimes.asr!.add(Duration(hours: adjDst));
    DateTime maghrib = calcPrayers.prayerTimes.maghrib!.add(Duration(hours: adjDst));
    DateTime isha = calcPrayers.prayerTimes.isha!.add(Duration(hours: adjDst));
    prayerTimes = [fajr, sunrise, dhuhr, asr, maghrib, isha];
  } else {
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
