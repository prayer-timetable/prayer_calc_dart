import 'package:prayer_calc/src/components/Prayers.dart';
import 'package:prayer_calc/src/func/helpers.dart';

class Durations {
  DateTime now;
  DateTime current;
  DateTime next;
  DateTime previous;
  bool isAfterIsha;
  int currentId;
  Duration countDown;
  Duration countUp;
  double percentage;
  bool jamaahPending;

  Durations(DateTime _now, Prayers prayersToday, Prayers prayersTomorrow,
      Prayers prayersYesterday,
      {bool jamaahOn = false,
      Prayers jamaahToday,
      Prayers jamaahTomorrow,
      Prayers jamaahYesterday}) {
    DateTime current;
    DateTime next;
    DateTime previous;
    int currentId;
    bool isAfterIsha = false;

    // now is local for PrayerTimetable and PrayerCalcAlt
    // utc for PrayerCalc
    /* *********************** */
    /* CURRENT, PREVIOUS, NEXT */
    /* *********************** */
    // from midnight to fajr
    if (!jamaahOn) {
      if (_now.isBefore(prayersToday.dawn)) {
        current = prayersYesterday.dusk;
        next = prayersToday.dawn;
        previous = prayersYesterday.sunset;
        currentId = 5;
      } else if (_now.isBefore(prayersToday.sunrise)) {
        current = prayersToday.dawn;
        next = prayersToday.sunrise;
        previous = prayersYesterday.dusk;
        currentId = 0;
      } else if (_now.isBefore(prayersToday.midday)) {
        current = prayersToday.sunrise;
        next = prayersToday.midday;
        previous = prayersToday.dawn;
        currentId = 1;
      } else if (_now.isBefore(prayersToday.afternoon)) {
        current = prayersToday.midday;
        next = prayersToday.afternoon;
        previous = prayersToday.sunrise;
        currentId = 2;
      } else if (_now.isBefore(prayersToday.sunset)) {
        current = prayersToday.afternoon;
        next = prayersToday.sunset;
        previous = prayersToday.midday;
        currentId = 3;
      } else if (_now.isBefore(prayersToday.dusk)) {
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
      if (_now.isBefore(prayersToday.dawn)) {
        current = prayersYesterday.dusk;
        next = prayersToday.dawn;
        previous = prayersYesterday.sunset;
        currentId = 5;
      }
      // dawn - fajr jamaah
      else if (_now.isBefore(jamaahToday.dawn)) {
        current = prayersToday.dawn;
        next = jamaahToday.dawn;
        previous = prayersToday.dawn;
        currentId = 0;
        jamaahPending = true;
      }
      // fajr jammah - sunrise
      else if (_now.isBefore(prayersToday.sunrise)) {
        current = prayersToday.dawn;
        next = prayersToday.sunrise;
        previous = prayersYesterday.dusk;
        currentId = 0;
      }
      // sunrise - midday
      else if (_now.isBefore(prayersToday.midday)) {
        current = prayersToday.sunrise;
        next = prayersToday.midday;
        previous = prayersToday.dawn;
        currentId = 1;
      }
      // midday - dhuhr jamaah
      else if (_now.isBefore(jamaahToday.midday)) {
        current = prayersToday.midday;
        next = jamaahToday.midday;
        previous = prayersToday.sunrise;
        currentId = 2;
        jamaahPending = true;
      }
      // dhuhr jamaah - afternoon
      else if (_now.isBefore(prayersToday.afternoon)) {
        current = jamaahToday.midday;
        next = prayersToday.afternoon;
        previous = prayersToday.sunrise;
        currentId = 2;
      }
      // afternoon - asr jamaah
      else if (_now.isBefore(jamaahToday.afternoon)) {
        current = prayersToday.afternoon;
        next = jamaahToday.afternoon;
        previous = prayersToday.midday;
        currentId = 3;
        jamaahPending = true;
      }
      // asr jamaah - sunset
      else if (_now.isBefore(prayersToday.sunset)) {
        current = prayersToday.afternoon;
        next = prayersToday.sunset;
        previous = prayersToday.midday;
        currentId = 3;
      }
      // sunset - maghrib jamaah
      else if (_now.isBefore(jamaahToday.sunset)) {
        current = prayersToday.sunset;
        next = jamaahToday.sunset;
        previous = prayersToday.afternoon;
        currentId = 4;
        jamaahPending = true;
      }
      // maghrib jamaah - dusk
      else if (_now.isBefore(prayersToday.dusk)) {
        current = prayersToday.sunset;
        next = prayersToday.dusk;
        previous = prayersToday.afternoon;
        currentId = 4;
      }
      // dusk - isha jamaah
      else if (_now.isBefore(jamaahToday.dusk)) {
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
    this.now = _now;
    this.current = current;
    this.next = next;
    this.previous = previous;
    this.isAfterIsha = isAfterIsha;
    this.currentId = currentId;
    this.countDown = next.difference(_now);
    this.countUp = _now.difference(current);
    this.percentage = round2Decimals(100 *
        (this.countUp.inSeconds /
            (this.countDown.inSeconds + this.countUp.inSeconds)));
    this.jamaahPending = jamaahPending;
    //end
  }
}
