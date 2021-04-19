import 'package:prayer_timetable/src/PrayerTimetableList.dart';
import 'src/timetable_list.dart';
import 'test.dart';

// Sarajevo
double latS = 43.8563;
double longS = 18.4131;
double altitudeS = 518;
double angleS = 14.6;
int timezoneS = 1;

// Prayers sarajevo = new Prayers(latS, longS, altitudeS, angleS, timezoneS);
PrayerTimetableList sarajevo = new PrayerTimetableList(
  base,
  summerTimeCalc: false,
  year: 2020,
  month: 3,
  day: 28,
);
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
PrayerTimetableList test = new PrayerTimetableList(
  base,
  summerTimeCalc: false,
  year: 2020,
  month: 6,
  day: 1,
);

PrayerTimetableList location = sarajevo;

main() => timetableTest(location);
