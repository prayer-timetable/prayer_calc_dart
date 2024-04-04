import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:prayer_timetable/src/PrayerTimetable.dart';
import 'package:prayer_timetable/src/func/helpers.dart';
import 'package:timezone/timezone.dart' as tz;

String yellow = '\u001b[93m';
String noColor = '\u001b[0m';
String green = '\u001b[32m';
// String red = '\u001b[31m';
String gray = '\u001b[90m';

// ICCI
double latI = 53.3046593;
double longI = -6.2344076;
double altitudeI = 85;
double angleI = 14.6; //18
double iangleI = 14.6; //16
String timezoneI = 'Europe/Dublin';

// Sarajevo
double latS = 43.8563;
double longS = 18.4131;
double altitudeS = 518;
double angleS = 14.6; //iz =19
double iangleS = 14.6; // iz = 17
String timezoneS = 'Europe/Sarajevo';

infoTest(time) {
  print('${green}***************** Info *****************${noColor}');
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
  print('${yellow}*************** Current ****************${noColor}');
  print('dawn:\t\t${location.currentPrayerTimes.dawn}');
  print('sunrise:\t${location.currentPrayerTimes.sunrise}');
  print('midday:\t\t${location.currentPrayerTimes.midday}');
  print('afternoon:\t${location.currentPrayerTimes.afternoon}');
  print('sunset:\t\t${location.currentPrayerTimes.sunset}');
  print('dusk:\t\t${location.currentPrayerTimes.dusk}');
  print('${yellow}**************** Next ******************${noColor}');
  print('dawn:\t\t${location.nextPrayerTimes.dawn}');
  print('sunrise:\t${location.nextPrayerTimes.sunrise}');
  print('midday:\t\t${location.nextPrayerTimes.midday}');
  print('afternoon:\t${location.nextPrayerTimes.afternoon}');
  print('sunset:\t\t${location.nextPrayerTimes.sunset}');
  print('dusk:\t\t${location.nextPrayerTimes.dusk}');
  print('${yellow}************** Previous ****************${noColor}');
  print('dawn:\t\t${location.previousPrayerTimes.dawn}');
  print('sunrise:\t${location.previousPrayerTimes.sunrise}');
  print('midday:\t\t${location.previousPrayerTimes.midday}');
  print('afternoon:\t${location.previousPrayerTimes.afternoon}');
  print('sunset:\t\t${location.previousPrayerTimes.sunset}');
  print('dusk:\t\t${location.previousPrayerTimes.dusk}');
  print('${yellow}*************** Sunnah ******************${noColor}');
  print('midnight:\t${location.sunnah.midnight}');
  print('lastThird\t${location.sunnah.lastThird}');
  print('${yellow}************** Calc ****************${noColor}');
  print('time:\t${location.calc.time}');
  print('current:\t${location.calc.current}');
  print('next:\t\t${location.calc.next}');
  print('previous:\t${location.calc.previous}');
  print('isAfterIsha:\t${location.calc.isAfterIsha}');
  print('currentId:\t${location.calc.currentId}');
  print('countDown:\t${location.calc.countDown}');
  print('countUp:\t${location.calc.countUp}');
  print('Qibla:\t${location.calc.qibla}');
  print('percentage:\t${location.calc.percentage}');
}

jamaahTest(PrayerTimetable location) {
  print('${yellow}**************** Today *****************${noColor}');
  print('dawn:\t\t${location.currentPrayerTimes.dawn}');
  print('sunrise:\t${location.currentPrayerTimes.sunrise}');
  print('midday:\t\t${location.currentPrayerTimes.midday}');
  print('afternoon:\t${location.currentPrayerTimes.afternoon}');
  print('sunset:\t\t${location.currentPrayerTimes.sunset}');
  print('dusk:\t\t${location.currentPrayerTimes.dusk}');

  print('${gray}************ Today Jamaah **************${noColor}');
  print('dawn:\t\t${location.currentJamaahTimes.dawn}');
  print('sunrise:\t${location.currentJamaahTimes.sunrise}');
  print('midday:\t\t${location.currentJamaahTimes.midday}');
  print('afternoon:\t${location.currentJamaahTimes.afternoon}');
  print('sunset:\t\t${location.currentJamaahTimes.sunset}');
  print('dusk:\t\t${location.currentJamaahTimes.dusk}');

  print('${yellow}*************** Tomorrow ***************${noColor}');
  print('dawn:\t\t${location.nextPrayerTimes.dawn}');
  print('sunrise:\t${location.nextPrayerTimes.sunrise}');
  print('midday:\t\t${location.nextPrayerTimes.midday}');
  print('afternoon:\t${location.nextPrayerTimes.afternoon}');
  print('sunset:\t\t${location.nextPrayerTimes.sunset}');
  print('dusk:\t\t${location.nextPrayerTimes.dusk}');

  print('${gray}*********** Tomorrow Jamaah ************${noColor}');
  print('dawn:\t\t${location.nextJamaahTimes.dawn}');
  print('sunrise:\t${location.nextJamaahTimes.sunrise}');
  print('midday:\t\t${location.nextJamaahTimes.midday}');
  print('afternoon:\t${location.nextJamaahTimes.afternoon}');
  print('sunset:\t\t${location.nextJamaahTimes.sunset}');
  print('dusk:\t\t${location.nextJamaahTimes.dusk}');

  print('${yellow}************* Yesterday ****************${noColor}');
  print('dawn:\t\t${location.previousPrayerTimes.dawn}');
  print('sunrise:\t${location.previousPrayerTimes.sunrise}');
  print('midday:\t\t${location.previousPrayerTimes.midday}');
  print('afternoon:\t${location.previousPrayerTimes.afternoon}');
  print('sunset:\t\t${location.previousPrayerTimes.sunset}');
  print('dusk:\t\t${location.previousPrayerTimes.dusk}');

  print('${gray}********** Yesterday Jamaah ************${noColor}');
  print('dawn:\t\t${location.previousJamaahTimes.dawn}');
  print('sunrise:\t${location.previousJamaahTimes.sunrise}');
  print('midday:\t\t${location.previousJamaahTimes.midday}');
  print('afternoon:\t${location.previousJamaahTimes.afternoon}');
  print('sunset:\t\t${location.previousJamaahTimes.sunset}');
  print('dusk:\t\t${location.previousJamaahTimes.dusk}');

  print('${yellow}*************** Sunnah *****************${noColor}');
  print('midnight:\t${location.sunnah.midnight}');
  print('lastThird\t${location.sunnah.lastThird}');
  print('${yellow}**************** Calc ******************${noColor}');
  print('time:\t\t${location.calc.time}');
  print('current:\t${location.calc.current}');
  print('next:\t\t${location.calc.next}');
  print('previous:\t${location.calc.previous}');
  print('isAfterIsha:\t${location.calc.isAfterIsha}');
  print('jamaahPending:\t${location.calc.jamaahPending}');
  print('currentId:\t${location.calc.currentId}');
  print('countDown:\t${location.calc.countDown}');
  print('countUp:\t${location.calc.countUp}');
  print('percentage:\t${location.calc.percentage}');
  print('qibla:\t\t${location.calc.qibla}');
  print('hijri:\t\t${location.calc.hijri}');
  // print(location.current);
}

liveTest(PrayerTimetable location, DateTime testTime) {
  Timer.periodic(Duration(seconds: 1), (Timer t) {
    testTime = testTime.add(Duration(seconds: 1));
    PrayerTimetable loc = location;

    print('\x1B[2J\x1B[0;0H'); // clear entire screen, move cursor to 0;0
    print('date:\t\t${formatDate(testTime, [yyyy, '-', mm, '-', dd])}');
    print('time:\t\t${formatDate(testTime, [HH, ':', nn, ':', ss])}');
    print('${gray}------------------------------------${noColor}');
    print(
        '${loc.calc.currentId == 0 ? green : ''}fajr:\t\t${formatDate(loc.currentPrayerTimes.dawn, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}${noColor}');
    print(
        '${loc.calc.currentId == 1 ? green : ''}sunrise:\t${formatDate(loc.currentPrayerTimes.sunrise, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}${noColor}');
    print(
        '${loc.calc.currentId == 2 ? green : ''}dhuhr:\t\t${formatDate(loc.currentPrayerTimes.midday, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}$noColor');
    print(
        '${loc.calc.currentId == 3 ? green : ''}asr:\t\t${formatDate(loc.currentPrayerTimes.afternoon, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}${noColor}');
    print(
        '${loc.calc.currentId == 4 ? green : ''}maghrib:\t${formatDate(loc.currentPrayerTimes.sunset, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}${noColor}');
    print(
        '${loc.calc.currentId == 5 ? green : ''}isha:\t\t${formatDate(loc.currentPrayerTimes.dusk, [
          HH,
          ':',
          nn,
          ':',
          ss
        ])}${noColor}');
    print('${gray}------------------------------------${noColor}');
    print('${yellow}countDown:\t${loc.calc.countDown}${noColor}');
    print('${yellow}countUp:\t${loc.calc.countUp}${noColor}');
    print('${yellow}percentage:\t${loc.calc.percentage}${noColor}');
    print('${yellow}currentId:\t${loc.calc.currentId}${noColor}');
    print('${yellow}nextId:\t\t${loc.calc.nextId}${noColor}');
    print('${yellow}previousId:\t${loc.calc.previousId}${noColor}');
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