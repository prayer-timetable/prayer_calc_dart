import 'package:prayer_timetable/src/components/Prayers.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

import 'package:adhan_dart/adhan_dart.dart';

class Calc {
  DateTime time = DateTime.now();
  DateTime current = DateTime.now();
  DateTime next = DateTime.now().add(Duration(days: 1));
  DateTime previous = DateTime.now().subtract(Duration(days: 1));
  bool isAfterIsha = false;
  int currentId = 0;
  Duration countDown = Duration.zero;
  Duration countUp = Duration(seconds: 10);
  double percentage = 0.1;
  bool jamaahPending = false;
  double qibla = 0;

  Calc(
    DateTime _time,
    Prayers prayersToday,
    Prayers prayersTomorrow,
    Prayers prayersYesterday, {
    bool jamaahOn = false,
    Prayers? jamaahToday,
    Prayers? jamaahTomorrow,
    Prayers? jamaahYesterday,
    double lat = 0,
    double lng = 0,
  }) {
    DateTime current = this.current;
    DateTime next = this.next;
    DateTime previous = this.previous;
    int currentId = this.currentId;
    bool isAfterIsha = false;

    // time is local for PrayerTimetable and PrayerTimetableAlt
    // utc for PrayerTimetable
    /* *********************** */
    /* CURRENT, PREVIOUS, NEXT */
    /* *********************** */
    // from midnight to fajr
    if (!jamaahOn) {
      if (_time.isBefore(prayersToday.dawn)) {
        current = prayersYesterday.dusk;
        next = prayersToday.dawn;
        previous = prayersYesterday.sunset;
        currentId = 5;
      } else if (_time.isBefore(prayersToday.sunrise)) {
        current = prayersToday.dawn;
        next = prayersToday.sunrise;
        previous = prayersYesterday.dusk;
        currentId = 0;
      } else if (_time.isBefore(prayersToday.midday)) {
        current = prayersToday.sunrise;
        next = prayersToday.midday;
        previous = prayersToday.dawn;
        currentId = 1;
      } else if (_time.isBefore(prayersToday.afternoon)) {
        current = prayersToday.midday;
        next = prayersToday.afternoon;
        previous = prayersToday.sunrise;
        currentId = 2;
      } else if (_time.isBefore(prayersToday.sunset)) {
        current = prayersToday.afternoon;
        next = prayersToday.sunset;
        previous = prayersToday.midday;
        currentId = 3;
      } else if (_time.isBefore(prayersToday.dusk)) {
        current = prayersToday.sunset;
        next = prayersToday.dusk;
        previous = prayersToday.afternoon;
        currentId = 4;
      } else {
        // dusk till midnight
        current = prayersToday.dusk;
        next = prayersTomorrow.dawn;
        previous = prayersToday.sunset;
        currentId = 5;
        isAfterIsha = true;
      }
    }

    // JAMAAH
    bool jamaahPending = false;
    if (jamaahOn) {
      // midnight - dawn
      if (_time.isBefore(prayersToday.dawn)) {
        current = prayersYesterday.dusk;
        next = prayersToday.dawn;
        previous = prayersYesterday.sunset;
        currentId = 5;
      }
      // dawn - fajr jamaah
      else if (_time.isBefore(jamaahToday!.dawn)) {
        current = prayersToday.dawn;
        next = jamaahToday.dawn;
        previous = prayersToday.dawn;
        currentId = 0;
        jamaahPending = true;
      }
      // fajr jammah - sunrise
      else if (_time.isBefore(prayersToday.sunrise)) {
        current = prayersToday.dawn;
        next = prayersToday.sunrise;
        previous = prayersYesterday.dusk;
        currentId = 0;
      }
      // sunrise - midday
      else if (_time.isBefore(prayersToday.midday)) {
        current = prayersToday.sunrise;
        next = prayersToday.midday;
        previous = prayersToday.dawn;
        currentId = 1;
      }
      // midday - dhuhr jamaah
      else if (_time.isBefore(jamaahToday.midday)) {
        current = prayersToday.midday;
        next = jamaahToday.midday;
        previous = prayersToday.sunrise;
        currentId = 2;
        jamaahPending = true;
      }
      // dhuhr jamaah - afternoon
      else if (_time.isBefore(prayersToday.afternoon)) {
        current = jamaahToday.midday;
        next = prayersToday.afternoon;
        previous = prayersToday.sunrise;
        currentId = 2;
      }
      // afternoon - asr jamaah
      else if (_time.isBefore(jamaahToday.afternoon)) {
        current = prayersToday.afternoon;
        next = jamaahToday.afternoon;
        previous = prayersToday.midday;
        currentId = 3;
        jamaahPending = true;
      }
      // asr jamaah - sunset
      else if (_time.isBefore(prayersToday.sunset)) {
        current = prayersToday.afternoon;
        next = prayersToday.sunset;
        previous = prayersToday.midday;
        currentId = 3;
      }
      // sunset - maghrib jamaah
      else if (_time.isBefore(jamaahToday.sunset)) {
        current = prayersToday.sunset;
        next = jamaahToday.sunset;
        previous = prayersToday.afternoon;
        currentId = 4;
        jamaahPending = true;
      }
      // maghrib jamaah - dusk
      else if (_time.isBefore(prayersToday.dusk)) {
        current = prayersToday.sunset;
        next = prayersToday.dusk;
        previous = prayersToday.afternoon;
        currentId = 4;
      }
      // dusk - isha jamaah
      else if (_time.isBefore(jamaahToday.dusk)) {
        current = prayersToday.dusk;
        next = jamaahToday.dusk;
        previous = prayersToday.sunset;
        currentId = 5;
        jamaahPending = true;
      }
      // isha jamaah - midnight
      else {
        current = prayersToday.dusk;
        next = prayersTomorrow.dawn;
        previous = prayersToday.sunset;
        currentId = 5;
        isAfterIsha = true;
      }
    }

    // components
    this.time = _time;
    this.current = current;
    this.next = next;
    this.previous = previous;
    this.isAfterIsha = isAfterIsha;
    this.currentId = currentId;
    this.countDown = next.difference(_time);
    this.countUp = _time.difference(current);
    this.percentage = round2Decimals(100 *
        (this.countUp.inSeconds /
            (this.countDown.inSeconds + this.countUp.inSeconds)));
    this.jamaahPending = jamaahPending;
    this.qibla = Qibla.qibla(new Coordinates(lat, lng));

    //end
  }
}
