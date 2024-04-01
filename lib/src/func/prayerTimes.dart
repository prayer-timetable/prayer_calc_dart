import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/components/PrayerTimes.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/* *********************** */
/* MAIN FUNCTION           */
/* *********************** */
PrayerTimes prayerTimes({
  int hijriOffset = 0,
  DateTime? date,
  String timezone = 'Europe/Dublin',
}) {
  /* *********************** */
  /* TIMES                   */
  /* *********************** */

  // print('###');
  // print(date);
  DateTime timestamp = tz.TZDateTime.from(
      date != null
          ? date.add(Duration(days: hijriOffset))
          : DateTime.now().add(Duration(days: hijriOffset)),
      tz.getLocation(timezone));

  // DateTime timestamp = date ?? DateTime.now();
  int adjDst = isDSTCalc(timestamp) ? 1 : 0;
  // print('adjDst: $adjDst');
  // check if leap year
  // bool isLeap = date.year % 4 == 0;

  /* *********************** */
  /* PRAYER LISTS            */
  /* *********************** */

  List<DateTime> prayerTimes = [];

  List prayerCount = Iterable<int>.generate(6).toList();

  prayerCount.forEach((prayerId) {
    DateTime prayerTime = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
      // timetable[timestamp.month.toString()][timestamp.day.toString()][prayerId][0],
      // timetable[timestamp.month.toString()][timestamp.day.toString()][prayerId][1],
    ).add(Duration(hours: adjDst));

    prayerTimes.insert(
      prayerId,
      prayerTime,
    );
  });

  // next prayer - add isNext
  // prayersList[next.id].isNext = true;//TODO

  PrayerTimes prayers = new PrayerTimes();
  prayers.dawn = prayerTimes[0];
  prayers.sunrise = prayerTimes[1];
  prayers.midday = prayerTimes[2];
  prayers.afternoon = prayerTimes[3];
  prayers.sunset = prayerTimes[4];
  prayers.dusk = prayerTimes[5];

  return prayers;
}

//export { prayersCalc, dayCalc }

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
