import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:prayer_timetable/src/components/Prayer.dart';
import 'package:prayer_timetable/src/components/TimetableCalc.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

List<String> prayerNames = ['fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha'];

/* *********************** */
/* MAIN FUNCTION           */
/* *********************** */
List<Prayer> prayersGen(
  DateTime date, {
  Map? timetableMap,
  List? timetableList,
  TimetableCalc? timetableCalc,
  required int hijriOffset,
  required String timezone,
  required bool jamaahOn, // = false,
  required List<String> jamaahMethods, // = 'afterthis',
  required List<List<int>> jamaahOffsets, // = const [0, 0],
  required bool joinDhuhr, // = false,
  required bool joinMaghrib, // = false,
  // List<bool> jamaahPerPrayer = defaultJamaahPerPrayerOff,
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

  List<Prayer> prayers = [];

  List prayerCount = Iterable<int>.generate(6).toList();

  prayerCount.forEach((prayerId) {
    Prayer prayer = Prayer();
    DateTime prayerTime = DateTime.now();

    ///map
    if (timetableMap != null) {
      prayerTime = tz.TZDateTime(
        tz.getLocation(timezone),
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timetableMap[timestamp.month.toString()][timestamp.day.toString()][prayerId][0],
        timetableMap[timestamp.month.toString()][timestamp.day.toString()][prayerId][1],
      ).add(Duration(hours: adjDst));
    }

    ///list
    else if (timetableList != null) {
      DateTime lastMidnight =
          tz.TZDateTime.from(DateTime(date.year, date.month, date.day), tz.getLocation(timezone));
      prayerTime = lastMidnight
          .add(Duration(seconds: timetableList[timestamp.month - 1][timestamp.day - 1][prayerId]))
          .add(Duration(hours: adjDst));
    }

    ///calc
    else if (timetableCalc != null) {
      if (prayerId == 0)
        prayerTime = tz.TZDateTime.from(timetableCalc.prayerTimes!.fajr!, tz.getLocation(timezone));
      else if (prayerId == 1)
        prayerTime =
            tz.TZDateTime.from(timetableCalc.prayerTimes!.sunrise!, tz.getLocation(timezone));
      else if (prayerId == 2)
        prayerTime =
            tz.TZDateTime.from(timetableCalc.prayerTimes!.dhuhr!, tz.getLocation(timezone));
      else if (prayerId == 3)
        prayerTime = tz.TZDateTime.from(timetableCalc.prayerTimes!.asr!, tz.getLocation(timezone));
      else if (prayerId == 4)
        prayerTime =
            tz.TZDateTime.from(timetableCalc.prayerTimes!.maghrib!, tz.getLocation(timezone));
      else if (prayerId == 5)
        prayerTime = tz.TZDateTime.from(timetableCalc.prayerTimes!.isha!, tz.getLocation(timezone));
    }

    /// define
    prayer.id = prayerId;
    prayer.name = prayerNames[prayerId];
    prayer.prayerTime = prayerTime;

    ///jamaah
    int jamaahOffsetMin = 0;
    prayer.jamaahTime = prayerTime;
    jamaahOffsetMin = jamaahOffsets[prayerId][0] * 60 + jamaahOffsets[prayerId][1];
    // if (!jamaahPerPrayer[prayerId])
    //   prayer.jamaahTime = prayerList[index];
    if (jamaahMethods[prayerId] == 'afterthis') {
      // print('it is');
      prayer.jamaahTime = prayerTime.add(Duration(minutes: jamaahOffsetMin));
    } else if (jamaahMethods[prayerId] == 'fixed') {
      prayer.jamaahTime = DateTime(prayerTime.year, prayerTime.month, prayerTime.day,
          jamaahOffsets[prayerId][0], jamaahOffsets[prayerId][1]);
      // .add(Duration(minutes: offset));
      //
    } else {
      prayer.jamaahTime = prayerTime;
    }

    ///validate if jammah time is before prayer time
    if (prayer.jamaahTime.isBefore(prayer.prayerTime)) prayer.prayerTime = prayer.jamaahTime;

    ///prayer joining
    if (joinMaghrib && prayerId == 5) {
      prayer.prayerTime = prayers[4].prayerTime;
      prayer.jamaahTime = prayers[4].jamaahTime;
    }
    if (joinDhuhr && prayerId == 3) {
      prayer.prayerTime = prayers[2].prayerTime;
      prayer.jamaahTime = prayers[2].jamaahTime;
    }

    /// define
    if (jamaahOn)
      prayer.isJamaahPending =
          timestamp.isAfter(prayer.jamaahTime) && timestamp.isBefore(prayer.jamaahTime);

    // prayerTimes = [...prayerTimes, prayerTime];
    prayers.insert(
      prayerId,
      prayer,
    );
  });

  /// Determine current, next, previous
  // for (final (int index, Prayer prayer) in prayers.indexed) {
  //   if (prayer.prayerTime.isBefore(timestamp))

  // }

  // PrayerTimes prayers = new PrayerTimes();
  // prayers.dawn = prayerTimes[0];
  // prayers.sunrise = prayerTimes[1];
  // prayers.midday = prayerTimes[2];
  // prayers.afternoon = prayerTimes[3];
  // prayers.sunset = prayerTimes[4];
  // prayers.dusk = prayerTimes[5];

  return prayers;
}
