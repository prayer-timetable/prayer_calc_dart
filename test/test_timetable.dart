import 'package:prayer_calc/src/PrayerTimetable.dart';
import 'test.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// main() => calcTest();
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

// Prayers sarajevo = new Prayers(latS, longS, altitudeS, angleS, timezoneS);
PrayerTimetable sarajevo = new PrayerTimetable(
  timezoneS,
  latS,
  longS,
  angleS,
  // 19,
  // year: 2021,
  // month: 11,
  // day: 30,
  // ishaAngle: iangleS,
  // ishaAngle: 17,
  // precision: true,
);
PrayerTimetable icci = new PrayerTimetable(timezoneI, latI, longI, angleI,
    ishaAngle: iangleI, precision: true);

// optional parameters:
// int year, int month, int day, int asrMethod, double ishaAngle, bool summerTimeCalc
//
// year, month, day defaults to current time,
// asrMethod defaults to 1 (Shafii), alternative is 2 (Hanafi)
// angle value sets both dawn and night twilight angle,
// if you use ishaAngle, then angle value is used for dawn and ishaAngle for night
// summerTimeCalc is true by default, set to false if no daylight saving should happen
//
// example (icci location, Hanafi, 1st June 2020, different ishaAngle, no summer time):
PrayerTimetable test = new PrayerTimetable(
  timezoneI,
  latI,
  longI,
  angleI,
  altitude: altitudeI,
  ishaAngle: 15,
  asrMethod: 2,
  summerTimeCalc: false,
  year: 2020,
  month: 3,
  day: 28,
);

PrayerTimetable location = icci;
// PrayerTimetable location = sarajevo;
// PrayerTimetable location = test;

// calcTest() {
//   print('**************** current *****************');
//   print('dawn:\t\t${location.prayers.current.dawn}');
//   print('sunrise:\t${location.prayers.current.sunrise}');
//   print('midday:\t\t${location.prayers.current.midday}');
//   print('afternoon:\t${location.prayers.current.afternoon}');
//   print('sunset:\t\t${location.prayers.current.sunset}');
//   print('dusk:\t\t${location.prayers.current.dusk}');
//   print('*************** next **************');
//   print('dawn:\t\t${location.prayers.next.dawn}');
//   print('sunrise:\t${location.prayers.next.sunrise}');
//   print('midday:\t\t${location.prayers.next.midday}');
//   print('afternoon:\t${location.prayers.next.afternoon}');
//   print('sunset:\t\t${location.prayers.next.sunset}');
//   print('dusk:\t\t${location.prayers.next.dusk}');
//   print('************** previous ***************');
//   print('dawn:\t\t${location.prayers.previous.dawn}');
//   print('sunrise:\t${location.prayers.previous.sunrise}');
//   print('midday:\t\t${location.prayers.previous.midday}');
//   print('afternoon:\t${location.prayers.previous.afternoon}');
//   print('sunset:\t\t${location.prayers.previous.sunset}');
//   print('dusk:\t\t${location.prayers.previous.dusk}');
//   print('*************** Sunnah *****************');
//   print('midnight:\t${location.sunnah.midnight}');
//   print('lastThird\t${location.sunnah.lastThird}');
//   print('************** Calc ***************');
//   print('nowLocal:\t${location.calc.now}');
//   print('current:\t${location.calc.current}');
//   print('next:\t\t${location.calc.next}');
//   print('previous:\t${location.calc.previous}');
//   print('isAfterIsha:\t${location.calc.isAfterIsha}');
//   print('currentId:\t${location.calc.currentId}');
//   print('countDown:\t${location.calc.countDown}');
//   print('countUp:\t${location.calc.countUp}');
//   print('percentage:\t${location.calc.percentage}');
//   print('Qibla:\t\t${location.qibla}');
//   // print(location.current); // TODO

//   // print(location.dayOfYear);
// }
main() {
  tz.initializeTimeZones();
  timetableTest(location);
}
