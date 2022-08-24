import 'package:prayer_timetable/src/components/PrayerTimes.dart';

class Sunnah {
  DateTime midnight = DateTime.now();
  DateTime lastThird = DateTime.now();

  Sunnah(
    DateTime now,
    PrayerTimes prayersToday,
    PrayerTimes prayersTomorrow,
    PrayerTimes prayersYesterday,
  ) {
    DateTime dawnTomorrow = prayersTomorrow.dawn;
    DateTime dawnToday = prayersToday.dawn;
    DateTime sunsetToday = prayersToday.sunset;
    DateTime sunsetYesterday = prayersYesterday.sunset;

    // print(now.isBefore(dawnToday));
    // midnight
    this.midnight = now.isBefore(dawnToday)
        ? sunsetYesterday.add(Duration(
            minutes:
                (dawnToday.difference(sunsetYesterday).inMinutes / 2).floor()))
        : sunsetToday.add(Duration(
            minutes:
                (dawnTomorrow.difference(sunsetToday).inMinutes / 2).floor()));

    this.lastThird = now.isBefore(dawnToday)
        ? sunsetYesterday.add(Duration(
            minutes: (2 * dawnToday.difference(sunsetYesterday).inMinutes / 3)
                .floor()))
        : sunsetToday.add(Duration(
            minutes: (2 * dawnTomorrow.difference(sunsetToday).inMinutes / 3)
                .floor()));
  }
}
