import 'package:prayer_timetable/src/components/PrayerTimes.dart';
import 'package:prayer_timetable/src/func/tzTime.dart';

class Sunnah {
  DateTime midnight = DateTime.now();
  DateTime lastThird = DateTime.now();

  Sunnah(
    DateTime date, {
    required PrayerTimes prayersCurrent,
    required PrayerTimes prayersNext,
    required PrayerTimes prayersPrevious,
  }) {
    DateTime dawnTomorrow = prayersNext.dawn;
    DateTime dawnToday = prayersCurrent.dawn;
    DateTime sunsetToday = prayersCurrent.sunset;
    DateTime sunsetYesterday = prayersPrevious.sunset;

    // print(now.isBefore(dawnToday));
    // midnight
    this.midnight = date.isBefore(dawnToday)
        ? sunsetYesterday
            .add(Duration(minutes: (dawnToday.difference(sunsetYesterday).inMinutes / 2).floor()))
        : sunsetToday
            .add(Duration(minutes: (dawnTomorrow.difference(sunsetToday).inMinutes / 2).floor()));

    this.lastThird = date.isBefore(dawnToday)
        ? sunsetYesterday.add(
            Duration(minutes: (2 * dawnToday.difference(sunsetYesterday).inMinutes / 3).floor()))
        : sunsetToday.add(
            Duration(minutes: (2 * dawnTomorrow.difference(sunsetToday).inMinutes / 3).floor()));
  }
}

Sunnah defaultSunnah = Sunnah(DateTime.now(),
    prayersCurrent: PrayerTimes(), prayersNext: PrayerTimes(), prayersPrevious: PrayerTimes());
