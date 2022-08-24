import 'package:prayer_timetable/src/classes/PrayerTimesCalc.dart';
import 'package:prayer_timetable/src/classes/DateUtils.dart';

class SunnahTimes {
  DateTime? midnight;
  DateTime? lastThird;

  SunnahTimes(PrayerTimesCalc? prayerTimes, {precision: true}) {
    DateTime? date = prayerTimes!.date;
    DateTime nextDay = dateByAddingDays(date, 1);
    PrayerTimesCalc nextDayPrayerTimesCalc = new PrayerTimesCalc(
        prayerTimes.coordinates, nextDay, prayerTimes.calculationParameters,
        precision: precision);

    Duration nightDuration =
        (nextDayPrayerTimesCalc.fajr!.difference(prayerTimes.maghrib!));

    this.midnight = roundedMinute(
        dateByAddingSeconds(
            prayerTimes.maghrib!, (nightDuration.inSeconds / 2).floor()),
        precision: precision);
    this.lastThird = roundedMinute(
        dateByAddingSeconds(
            prayerTimes.maghrib!, (nightDuration.inSeconds * (2 / 3)).floor()),
        precision: precision);
  }
}
