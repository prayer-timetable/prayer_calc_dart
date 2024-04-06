import 'package:prayer_timetable/src/components/Prayer.dart';

class Sunnah {
  DateTime midnight = DateTime.now();
  DateTime lastThird = DateTime.now();

  Sunnah(
    DateTime date, {
    required List<Prayer> prayersCurrent,
    required List<Prayer> prayersNext,
    required List<Prayer> prayersPrevious,
  }) {
    DateTime dawnTomorrow = prayersNext[0].prayerTime;
    DateTime dawnToday = prayersCurrent[0].prayerTime;
    DateTime sunsetToday = prayersCurrent[4].prayerTime;
    DateTime sunsetYesterday = prayersPrevious[4].prayerTime;

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

Sunnah defaultSunnah = Sunnah(
  DateTime.now(),
  prayersCurrent: List<Prayer>.filled(6, Prayer(), growable: false),
  prayersNext: List<Prayer>.filled(6, Prayer(), growable: false),
  prayersPrevious: List<Prayer>.filled(6, Prayer(), growable: false),
);
