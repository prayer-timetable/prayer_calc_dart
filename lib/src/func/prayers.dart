import 'package:prayer_timetable/prayer_timetable.dart';

// ignore: unused_import
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
  List? differences,
  TimetableCalc? timetableCalc,
  required int hijriOffset,
  required String timezone,
  required bool jamaahOn, // = false,
  required List<String> jamaahMethods, // = 'afterthis',
  required List<List<int>> jamaahOffsets, // = const [0, 0],
  required bool joinDhuhr, // = false,
  required bool joinMaghrib, // = false,
  required List<bool> jamaahPerPrayer, // = defaultJamaahPerPrayerOff,
  // bool isAfterIsha = false,
  // DateTime? ishaTime,
  // useTz = true,

  /// for adding time when prayers are joined
  int? prayerLength = 10,
}) {
  /* *********************** */
  /* TIMES                   */
  /* *********************** */
  // print(timetableMap);
  // print('###');
  // print(date);

  // tz.Location tzGet = useTz ? tz.getLocation(timezone) : tz.UTC;
  tz.Location tzGet = tz.getLocation(timezone);

  tz.TZDateTime timestamp = tz.TZDateTime.from(date.add(Duration(days: hijriOffset)), tzGet);
  tz.TZDateTime timestampTZsafe = timestamp.add(Duration(hours: 3));

  /// For list
  DateTime dayBegin = tz.TZDateTime(tzGet, timestamp.year, timestamp.month, timestamp.day)
      .add(Duration(days: hijriOffset));
  DateTime dayEnd = tz.TZDateTime(tzGet, timestamp.year, timestamp.month, timestamp.day + 1)
      .add(Duration(days: hijriOffset));

  // DateTime timestamp = date ?? DateTime.now();
  // TODO:
  // int adjDst = isDSTCalc(timestamp) && useTz ? 1 : 0;
  // int adjDst = isDSTCalc(timestamp) ? 1 : 0;
  int adjDst = timestampTZsafe.timeZone.isDst ? 1 : 0;

  // TODO: glitch in tz package
  // if (timezone == 'Europe/Dublin') adjDst = isDSTCalc(timestamp) ? 1 : 0;
  if (timezone == 'Europe/Dublin') adjDst = timestampTZsafe.timeZone.isDst ? 0 : 1; // reverse

  // print('kk ${timetableCalc!.timezone}');

  /// timestamp.timeZone.offset : int, miliseconds
  /// timestamp.timeZoneOffset: Duration

  // if (!useTz) {
  //   // tz.TZDateTime newTime =
  //   //     tz.TZDateTime.from(date.add(Duration(days: hijriOffset)), tz.getLocation(timezone));
  //   // print('${newTime.timeZoneOffset.inHours} ${newTime.toLocal()} ');

  //   adjDst = -utcOffsetHours;
  // }

  // int adjDst = tzGet.currentTimeZone.isDst ? 1 : 0;
  // print(tzGet.currentTimeZone.isDst);

  // print('adjDst: $adjDst');

  /* *********************** */
  /* PRAYER LISTS            */
  /* *********************** */

  List<Prayer> prayers = [];

  List prayerCount = Iterable<int>.generate(6).toList();

  prayerCount.forEach((prayerId) {
    Prayer prayer = Prayer();
    DateTime prayerTime = DateTime.now();
    DateTime prayerEndTime = DateTime.now();

    ///map
    if (timetableMap != null) {
      // print(
      //     'timestamp ${timestamp} | dayEnd ${dayEnd} | adjDst ${adjDst} | isDst ${timestamp.timeZone.isDst}');

      prayerTime = tz.TZDateTime(
        tzGet,
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timetableMap[timestamp.month.toString()][timestamp.day.toString()][prayerId][0],
        timetableMap[timestamp.month.toString()][timestamp.day.toString()][prayerId][1],
      ).add(Duration(hours: adjDst));

      prayerEndTime = prayerId == 5
          ? dayEnd
          : tz.TZDateTime(
              tzGet,
              timestamp.year,
              timestamp.month,
              timestamp.day,
              timetableMap[timestamp.month.toString()][timestamp.day.toString()][prayerId + 1][0],
              timetableMap[timestamp.month.toString()][timestamp.day.toString()][prayerId + 1][1],
            ).add(Duration(hours: adjDst));
    }

    ///list
    else if (timetableList != null) {
      // print(
      // 'dayBegin ${dayBegin} | dayEnd ${dayEnd} | utcOffsetHours ${utcOffsetHours} | adjDst ${adjDst}');
      // print(
      //     'dayBegin ${dayBegin} | sec ${timetableList[timestamp.month - 1][timestamp.day - 1][0]} | dur ${Duration(seconds: timetableList[timestamp.month - 1][timestamp.day - 1][0])} | time ${dayEnd.add(Duration(hours: -24 + adjDst, seconds: timetableList[timestamp.month - 1][timestamp.day - 1][0]))}');

      prayerTime = dayEnd
          .add(Duration(
              hours: -24 + adjDst,
              seconds: timetableList[timestamp.month - 1][timestamp.day - 1][prayerId]))
          .add(Duration(
              seconds: differences != null ? differences[timestamp.month - 1][prayerId] : 0));

      prayerEndTime = prayerId == 5
          ? dayEnd
          : dayEnd
              .add(Duration(
                  hours: -24 + adjDst,
                  seconds: timetableList[timestamp.month - 1][timestamp.day - 1][prayerId + 1]))
              .add(Duration(
                  seconds:
                      differences != null ? differences[timestamp.month - 1][prayerId + 1] : 0));
    }

    ///calc
    else if (timetableCalc != null) {
      // print(
      //     'timestamp ${timestamp} | dayEnd ${dayEnd} | adjDst ${adjDst} | isDst ${timestamp.timeZone.isDst}');

      DateTime fajrTime = tz.TZDateTime.from(timetableCalc.prayerTimes.fajr, tzGet);
      DateTime sunriseTime = tz.TZDateTime.from(timetableCalc.prayerTimes.sunrise, tzGet);
      DateTime dhuhrTime = tz.TZDateTime.from(timetableCalc.prayerTimes.dhuhr, tzGet);
      DateTime asrTime = tz.TZDateTime.from(timetableCalc.prayerTimes.asr, tzGet);
      DateTime maghribTime = tz.TZDateTime.from(timetableCalc.prayerTimes.maghrib, tzGet);
      DateTime ishaTime = tz.TZDateTime.from(timetableCalc.prayerTimes.isha, tzGet);

      if (prayerId == 0) {
        prayerTime = fajrTime;
        prayerEndTime = sunriseTime;
      } else if (prayerId == 1) {
        prayerTime = sunriseTime;
        prayerEndTime = dhuhrTime;
      } else if (prayerId == 2) {
        prayerTime = dhuhrTime;
        prayerEndTime = asrTime;
      } else if (prayerId == 3) {
        prayerTime = asrTime;
        prayerEndTime = maghribTime;
      } else if (prayerId == 4) {
        prayerTime = maghribTime;
        prayerEndTime = ishaTime;
      } else if (prayerId == 5) {
        prayerTime = ishaTime;
        prayerEndTime = dayEnd;
      }
    }

    /// define
    prayer.id = prayerId;
    prayer.name = prayerNames[prayerId];
    prayer.prayerTime = prayerTime;
    prayer.endTime = prayerEndTime;

    ///jamaah
    int jamaahOffsetMin = 0;
    prayer.jamaahTime = prayerTime;
    jamaahOffsetMin = jamaahOffsets[prayerId][0] * 60 + jamaahOffsets[prayerId][1];
    //if jamaah not enabled for the prayer
    if (!jamaahPerPrayer[prayerId]) {
      prayer.jamaahTime = prayerTime;
    }
    //if afterthis
    else if (jamaahMethods[prayerId] == 'afterthis') {
      prayer.jamaahTime = prayerTime.add(Duration(minutes: jamaahOffsetMin));
    }
    //if fixed
    else if (jamaahMethods[prayerId] == 'fixed') {
      prayer.jamaahTime = tz.TZDateTime(tzGet, prayerTime.year, prayerTime.month, prayerTime.day,
          jamaahOffsets[prayerId][0], jamaahOffsets[prayerId][1]);
    }
    //all else
    else {
      prayer.jamaahTime = prayerTime;
    }

    ///validate if jammah time is before prayer time
    if (prayer.jamaahTime.isBefore(prayer.prayerTime)) prayer.prayerTime = prayer.jamaahTime;

    ///prayer joining
    if (joinMaghrib) {
      if (prayerId == 5) {
        prayer.prayerTime = prayers[4].jamaahTime.add(Duration(minutes: prayerLength ?? 10));
        prayer.jamaahTime = prayers[4].jamaahTime.add(Duration(minutes: prayerLength ?? 10));
      }
    }
    if (joinDhuhr) {
      if (prayerId == 3) {
        prayer.prayerTime = prayers[2].jamaahTime.add(Duration(minutes: prayerLength ?? 10));
        prayer.jamaahTime = prayers[2].jamaahTime.add(Duration(minutes: prayerLength ?? 10));
      }
    }

    /// define
    if (jamaahOn)
      prayer.isJamaahPending =
          timestamp.isAfter(prayer.prayerTime) && timestamp.isBefore(prayer.jamaahTime);

    /// is next
    prayer.isNext = false;
    // int previousId = prayerId - 1;
    // if (previousId < 0) previousId = 5;
    // if (prayerId == 5) {
    //   prayer.isNext = prayer.isJamaahPending;
    // } else if (prayerId == 0) {
    //   // prayer.isNext = prayer.isJamaahPending || prayer.prayerTime.isAfter(timestamp);
    //   prayer.isNext = timestamp.isAfter(ishaJamaahTime) ||
    //       timestamp.isAfter(dayBegin) ||
    //       prayer.isJamaahPending;

    //   // print('${clear}$mode');
    //   // print('${yellow}ishaPrayerTime\t${noColor}$ishaPrayerTime');
    //   // print('${yellow}ishaJamaahTime\t${noColor}$ishaJamaahTime');
    //   // print('${yellow}timestamp\t${noColor}$timestamp');
    //   // print(
    //   //     '${yellow}id${noColor} ${prayerId} ${yellow}isNext${noColor} ${prayer.isNext} ${yellow}jamaah${noColor} ${prayer.jamaahTime} ${yellow}isha jamaah${noColor} ${ishaJamaahTime} ${yellow}time${noColor} ${timestamp}');
    // } else {
    //   prayer.isNext = prayer.isJamaahPending ||
    //       (prayer.jamaahTime.isAfter(timestamp) &&
    //           prayers[previousId].jamaahTime.isBefore(timestamp));
    // }

    /// isCurrent
    if (prayerId == 5 &&
        timestamp.isAfter(dayBegin) &&
        (timestamp.isBefore(prayers[0].prayerTime) ||
            timestamp.isAtSameMomentAs(prayers[0].prayerTime))) {
      prayer.isCurrent = true;
    }
    if ((timestamp.isAfter(prayerTime) && timestamp.isBefore(prayerEndTime)) ||
        prayer.isJamaahPending ||
        timestamp.isAtSameMomentAs(prayerEndTime)) {
      prayer.isCurrent = true;
    }

    /// isNext
    // if (prayerId == 0 && timestamp.isAfter(dayBegin) && timestamp.isBefore(prayer.prayerTime)) {
    //   prayer.isNext = true;
    // }
    // if (prayerId == 5) prayers[0].isNext = timestamp.isAfter(prayerTime) && !prayer.isJamaahPending;
    // if (prayerId != 0)
    //   prayer.isNext =
    //       timestamp.isBefore(prayerTime) && timestamp.isAfter(prayers[prayerId - 1].jamaahTime);

    //  else if (prayerId == 5) prayers[5].isCurrent = true;

    // prayer.isNext = timestamp.isAfter(prayerTime) && timestamp.isBefore(prayerEndTime);

    // prayerTimes = [...prayerTimes, prayerTime];
    prayers.insert(
      prayerId,
      prayer,
    );
  });

  /// isNext
  for (Prayer prayer in prayers) {
    int nextId = prayer.id != 5 ? prayer.id + 1 : 0;

    if ((prayer.isCurrent && !prayer.isJamaahPending) || prayers[nextId].isJamaahPending)
      prayers[nextId].isNext = true;
  }

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
