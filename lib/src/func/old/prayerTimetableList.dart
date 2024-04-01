import 'package:prayer_timetable/src/components/PrayerTimes.dart';
import 'package:prayer_timetable/src/func/helpers.dart';
import 'package:timezone/timezone.dart' as tz;

/* *********************** */
/* MAIN FUNCTION           */
/* *********************** */
PrayerTimes prayerTimetable(
  List timetable, {
  List difference = const [0, 0, 0, 0, 0, 0],
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

  // check if leap year
  // bool isLeap = date.year % 4 == 0;

  /* *********************** */
  /* PRAYER LISTS            */
  /* *********************** */

  List<DateTime> prayerTimes = [];

  List prayerCount = Iterable<int>.generate(6).toList();

  prayerCount.forEach((prayerId) {
    DateTime prayerTime = secondsToDateTime(
            timetable[timestamp.month - 1][timestamp.day - 1][prayerId], timestamp,
            offset: 0)
        .add(Duration(seconds: difference[prayerId]));

    // DateTime time, int id, bool hasPassed, String name, String when, bool isNext,
    prayerTimes.insert(
      prayerId,
      prayerTime,
    );
  });

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
