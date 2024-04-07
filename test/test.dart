import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

String yellow = '\u001b[93m';
String noColor = '\u001b[0m';
String green = '\u001b[32m';
// String red = '\u001b[31m';
String gray = '\u001b[90m';

// ICCI
double latI = 53.3046593;
double lngI = -6.2344076;
double altitudeI = 85;
double angleI = 14.6; //18
double iangleI = 14.6; //16
String timezoneI = 'Europe/Dublin';

// Sarajevo
double latS = 43.8563;
double lngS = 18.4131;
double altitudeS = 518;
double angleS = 14.6; //iz =19
double iangleS = 14.6; // iz = 17
String timezoneS = 'Europe/Sarajevo';

infoTest(time) {
  print('${green}******************* Info *******************${noColor}');
  print('time:\t${time.toIso8601String()}');
  print('timeZoneOffset:\t${time.timeZoneOffset}');
  print('isDst:\t\t${time.timeZone.isDst}');
  print('location:\t${time.location}');
  print('timeZone:\t${time.timeZone}');
  print('timeZone abr:\t${time.timeZone.abbreviation}');
  print('offset (ms):\t${time.timeZone.offset}');
  print('isDSTCalc:\t${isDSTCalc(time)}');

// timeZone: ${lastMidnight.timeZone} or lastMidnight.location.name
// time: ${lastMidnight.toIso8601String()}
// lastMidnight.timeZone.offset in miliseconds
}

timetableTest(PrayerTimetable location) {
  print('${yellow}***************** Current ******************${noColor}');
  print('fajr:\t\t${location.current[0].prayerTime}');
  print('sunrise:\t${location.current[1].prayerTime}');
  print('dhuhr:\t\t${location.current[2].prayerTime}');
  print('asr:\t${location.current[3].prayerTime}');
  print('maghrib:\t\t${location.current[4].prayerTime}');
  print('isha:\t\t${location.current[5].prayerTime}');
  print('${yellow}****************** Next ********************${noColor}');
  print('fajr:\t\t${location.next[0].prayerTime}');
  print('sunrise:\t${location.next[1].prayerTime}');
  print('dhuhr:\t\t${location.next[2].prayerTime}');
  print('asr:\t${location.next[3].prayerTime}');
  print('maghrib:\t\t${location.next[4].prayerTime}');
  print('isha:\t\t${location.next[5].prayerTime}');
  print('${yellow}************** Previous ******************${noColor}');
  print('fajr:\t\t${location.previous[0].prayerTime}');
  print('sunrise:\t${location.previous[1].prayerTime}');
  print('dhuhr:\t\t${location.previous[2].prayerTime}');
  print('asr:\t${location.previous[3].prayerTime}');
  print('maghrib:\t\t${location.previous[4].prayerTime}');
  print('isha:\t\t${location.previous[5].prayerTime}');
  print('${yellow}************** Calc ******************${noColor}');
  print('time:\t${location.utils.time}');
  print('current:\t${location.utils.current}');
  print('next:\t\t${location.utils.next}');
  print('previous:\t${location.utils.previous}');
  print('isAfterIsha:\t${location.utils.isAfterIsha}');
  print('currentId:\t${location.utils.currentId}');
  print('countDown:\t${location.utils.countDown}');
  print('countUp:\t${location.utils.countUp}');
  print('Qibla:\t${location.utils.qibla}');
  print('percentage:\t${location.utils.percentage}');
  print('midnight:\t${location.utils.midnight}');
  print('lastThird\t${location.utils.lastThird}');
}

jamaahTest(PrayerTimetable location,
    {bool prayer = true, bool jamaah = false, bool utils = false}) {
  if (prayer) {
    print('${yellow}****************** Today *******************${noColor}');
    print('fajr:\t\t${location.current[0].prayerTime}');
    print('sunrise:\t${location.current[1].prayerTime}');
    print('dhuhr:\t\t${location.current[2].prayerTime}');
    print('asr:\t\t${location.current[3].prayerTime}');
    print('maghrib:\t${location.current[4].prayerTime}');
    print('isha:\t\t${location.current[5].prayerTime}');
  }

  if (jamaah) {
    print('${gray}************** Today Jamaah ****************${noColor}');
    print('fajr:\t\t${location.current[0].jamaahTime}');
    print('sunrise:\t${location.current[1].jamaahTime}');
    print('dhuhr:\t\t${location.current[2].jamaahTime}');
    print('asr:\t\t${location.current[3].jamaahTime}');
    print('maghrib:\t${location.current[4].jamaahTime}');
    print('isha:\t\t${location.current[5].jamaahTime}');
  }

  if (prayer) {
    print('${yellow}***************** Tomorrow *****************${noColor}');
    print('fajr:\t\t${location.next[0].prayerTime}');
    print('sunrise:\t${location.next[1].prayerTime}');
    print('dhuhr:\t\t${location.next[2].prayerTime}');
    print('asr:\t\t${location.next[3].prayerTime}');
    print('maghrib:\t${location.next[4].prayerTime}');
    print('isha:\t\t${location.next[5].prayerTime}');
  }

  if (jamaah) {
    print('${gray}************* Tomorrow Jamaah **************${noColor}');
    print('fajr:\t\t${location.next[0].jamaahTime}');
    print('sunrise:\t${location.next[1].jamaahTime}');
    print('dhuhr:\t\t${location.next[2].jamaahTime}');
    print('asr:\t\t${location.next[3].jamaahTime}');
    print('maghrib:\t${location.next[4].jamaahTime}');
    print('isha:\t\t${location.next[5].jamaahTime}');
  }

  if (prayer) {
    print('${yellow}***************** Yesterday ****************${noColor}');
    print('fajr:\t\t${location.previous[0].prayerTime}');
    print('sunrise:\t${location.previous[1].prayerTime}');
    print('dhuhr:\t\t${location.previous[2].prayerTime}');
    print('asr:\t\t${location.previous[3].prayerTime}');
    print('maghrib:\t${location.previous[4].prayerTime}');
    print('isha:\t\t${location.previous[5].prayerTime}');
  }

  if (jamaah) {
    print('${gray}************* Yesterday Jamaah *************${noColor}');
    print('fajr:\t\t${location.previous[0].jamaahTime}');
    print('sunrise:\t${location.previous[1].jamaahTime}');
    print('dhuhr:\t\t${location.previous[2].jamaahTime}');
    print('asr:\t\t${location.previous[3].jamaahTime}');
    print('maghrib:\t${location.previous[4].jamaahTime}');
    print('isha:\t\t${location.previous[5].jamaahTime}');
  }

  if (utils) {
    print('${yellow}****************** Utils *******************${noColor}');
    print('time:\t\t${location.utils.time}');
    print('current:\t${location.utils.current}');
    print('next:\t\t${location.utils.next}');
    print('previous:\t${location.utils.previous}');
    print('isAfterIsha:\t${location.utils.isAfterIsha}');
    print('isJamaahPending:\t${location.utils.isJamaahPending}');
    print('currentId:\t${location.utils.currentId}');
    print('countDown:\t${location.utils.countDown}');
    print('countUp:\t${location.utils.countUp}');
    print('percentage:\t${location.utils.percentage}');
    print('qibla:\t\t${location.utils.qibla}');
    print('hijri:\t\t${location.utils.hijri}');
    print('midnight:\t${location.utils.midnight}');
    print('lastThird\t${location.utils.lastThird}');
    // print(location.current);
  }
}

liveTest(PrayerTimetable location) {
  DateTime time = location.utils.time;
  PrayerTimetable loc = location;

  Timer.periodic(Duration(seconds: 1), (Timer t) {
    time = time.add(Duration(seconds: 1));
    loc = PrayerTimetable.base(
      timezone: loc.timezone,
      timetableMap: loc.timetableMap,
      timetableList: loc.timetableList,
      timetableCalc: loc.timetableCalc,
      year: time.year,
      month: time.month,
      day: time.day,
      hour: time.hour,
      minute: time.minute,
      second: time.second,
      hijriOffset: loc.hijriOffset,
      jamaahOn: loc.jamaahOn,
      joinMaghrib: loc.joinMaghrib,
      joinDhuhr: loc.joinDhuhr,
      jamaahPerPrayer: loc.jamaahPerPrayer,
      jamaahMethods: loc.jamaahMethods,
      jamaahOffsets: loc.jamaahOffsets,
      lat: loc.lat,
      lng: loc.lng,
    );

    List<Prayer> prayers = loc.utils.isAfterIsha ? loc.next : loc.current;

    print('\x1B[2J\x1B[0;0H'); // clear entire screen, move cursor to 0;0
    print('date:\t\t${formatDate(time, [yyyy, '-', mm, '-', dd])}');
    print('hijri:\t\t${loc.utils.hijri[0]}-${loc.utils.hijri[1]}-${loc.utils.hijri[2]}');
    print('time:\t\t${formatDate(time, [HH, ':', nn, ':', ss])}');
    print('${gray}------------------------------------${noColor}');
    print('${loc.utils.nextId == 0 ? green : ''}fajr:\t\t${formatDate(prayers[0].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}\t${formatDate(prayers[0].jamaahTime, [HH, ':', nn, ':', ss])}${noColor}');
    print('${loc.utils.nextId == 1 ? green : ''}sunrise:\t${formatDate(prayers[1].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}\t${formatDate(prayers[1].jamaahTime, [HH, ':', nn, ':', ss])}${noColor}');
    print('${loc.utils.nextId == 2 ? green : ''}dhuhr:\t\t${formatDate(prayers[2].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}\t${formatDate(prayers[2].jamaahTime, [HH, ':', nn, ':', ss])}$noColor');
    print('${loc.utils.nextId == 3 ? green : ''}asr:\t\t${formatDate(prayers[3].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}\t${formatDate(prayers[3].jamaahTime, [HH, ':', nn, ':', ss])}${noColor}');
    print('${loc.utils.nextId == 4 ? green : ''}maghrib:\t${formatDate(prayers[4].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}\t${formatDate(prayers[4].jamaahTime, [HH, ':', nn, ':', ss])}${noColor}');
    print('${loc.utils.nextId == 5 ? green : ''}isha:\t\t${formatDate(prayers[5].prayerTime, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}\t${formatDate(prayers[5].jamaahTime, [HH, ':', nn, ':', ss])}${noColor}');
    print('${gray}------------------------------------${noColor}');
    print('${yellow}countDown:\t${printDuration(loc.utils.countDown)}${noColor}');
    print('${yellow}countUp:\t${printDuration(loc.utils.countUp)}${noColor}');
    print('${yellow}percentage:\t${loc.utils.percentage}${noColor}');
    // print('${yellow}currentId:\t${loc.utils.currentId}${noColor}');
    // print('${yellow}nextId:\t\t${loc.utils.nextId}${noColor}');
    // print('${yellow}previousId:\t${loc.utils.previousId}${noColor}');
    print('${yellow}isJamaahPend:\t${loc.utils.isJamaahPending}${noColor}');
    print('${yellow}isAfterIsha:\t${loc.utils.isAfterIsha}${noColor}');

    String isNext = '${yellow}isNext:\t\t';
    for (var i = 0; i <= 5; i++) {
      isNext = isNext + (prayers[i].isNext ? '${green}' : '${yellow}');
      isNext = isNext + '${prayers[i].isNext}';
      isNext = i != 5 ? isNext + '\t' : isNext;
    }
    isNext = isNext + '${noColor}';
    print(isNext);
    // print(
    // '${yellow}isNext:\t${prayers[0].isNext}\t${prayers[1].isNext}\t${prayers[2].isNext}\t${prayers[3].isNext}\t${prayers[4].isNext}\t${prayers[5].isNext}${noColor}');
  });
}


// exports.colors = {
//   pass: 90,
//   fail: 31,
//   'bright pass': 92,
//   'bright fail': 91,
//   'bright yellow': 93,
//   pending: 36,
//   suite: 0,
//   'error title': 0,
//   'error message': 31,
//   'error stack': 90,
//   checkmark: 32,
//   fast: 90,
//   medium: 33,
//   slow: 31,
//   green: 32,
//   light: 90,
//   'diff gutter': 90,
//   'diff added': 32,
//   'diff removed': 31
// };