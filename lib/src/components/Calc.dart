import 'package:hijri/hijri_calendar.dart';
import 'package:prayer_timetable/src/components/PrayerTimes.dart' as prayertimes;
import 'package:prayer_timetable/src/components/JamaahTimes.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

import 'package:adhan_dart/adhan_dart.dart';

/// time DateTime
/// current DateTime
/// next = DateTime
/// previous = DateTime
/// isAfterIsha = bool
/// currentId = int
/// nextId = int
/// previousId = int
/// countDown = Duration
/// countUp = Duration
/// percentage = double
/// jamaahPending = bool
/// qibla = Qibla.qibla(new Coordinates(double lat, double lng))
class Calc {
  DateTime time = DateTime.now();
  DateTime current = DateTime.now();
  DateTime next = DateTime.now().add(Duration(days: 1));
  DateTime previous = DateTime.now().subtract(Duration(days: 1));
  bool isAfterIsha = false;

  int currentId = 1;
  int previousId = 0;
  int nextId = 2;

  Duration countDown = Duration.zero;
  Duration countUp = Duration(seconds: 10);
  double percentage = 0.1;
  bool jamaahPending = false;
  double qibla = 0;
  List<int> hijri = [];
  // check if leap year
  bool isLeap = false;

  Calc(
    DateTime _date, {
    prayertimes.PrayerTimes? prayersCurrent,
    prayertimes.PrayerTimes? prayersNext,
    prayertimes.PrayerTimes? prayersPrevious,
    bool? jamaahOn,
    JamaahTimes? jamaahCurrent,
    // JamaahTimes _jamaahNext,
    JamaahTimes? jamaahPrevious,
    double? lat,
    double? lng,
    List<bool>? jamaahPerPrayer,
  }) {
    DateTime _current = this.current;
    DateTime _next = this.next;
    DateTime _previous = this.previous;
    int _currentId = this.currentId;
    int _previousId = this.previousId;
    int _nextId = this.nextId;
    bool _isAfterIsha = false;

    // time is local for PrayerTimetable and PrayerTimetableAlt
    // utc for PrayerTimetable
    /* *********************** */
    /* _current, _previous, _next */
    /* *********************** */
    // from midnight to fajr
    if (jamaahOn != null &&
        prayersCurrent != null &&
        prayersNext != null &&
        prayersPrevious != null &&
        !jamaahOn) {
      if (_date.isBefore(prayersCurrent.dawn)) {
        _current = prayersPrevious.dusk;
        _next = prayersCurrent.dawn;
        _previous = prayersPrevious.sunset;
        _currentId = 5;
      } else if (_date.isBefore(prayersCurrent.sunrise)) {
        _current = prayersCurrent.dawn;
        _next = prayersCurrent.sunrise;
        _previous = prayersPrevious.dusk;
        _currentId = 0;
      } else if (_date.isBefore(prayersCurrent.midday)) {
        _current = prayersCurrent.sunrise;
        _next = prayersCurrent.midday;
        _previous = prayersCurrent.dawn;
        _currentId = 1;
      } else if (_date.isBefore(prayersCurrent.afternoon)) {
        _current = prayersCurrent.midday;
        _next = prayersCurrent.afternoon;
        _previous = prayersCurrent.sunrise;
        _currentId = 2;
      } else if (_date.isBefore(prayersCurrent.sunset)) {
        _current = prayersCurrent.afternoon;
        _next = prayersCurrent.sunset;
        _previous = prayersCurrent.midday;
        _currentId = 3;
      } else if (_date.isBefore(prayersCurrent.dusk)) {
        _current = prayersCurrent.sunset;
        _next = prayersCurrent.dusk;
        _previous = prayersCurrent.afternoon;
        _currentId = 4;
      } else {
        // dusk till midnight
        _current = prayersCurrent.dusk;
        _next = prayersNext.dawn;
        _previous = prayersCurrent.sunset;
        _currentId = 5;
        _isAfterIsha = true;
      }
    }

    // JAMAAH
    bool _jamaahPending = false;

    if (jamaahOn != null &&
        prayersCurrent != null &&
        prayersNext != null &&
        prayersPrevious != null &&
        jamaahCurrent != null &&
        jamaahPrevious != null &&
        jamaahOn) {
      if (jamaahPerPrayer == null) {
        jamaahPerPrayer = const [true, true, true, true, true, true];
      }

      // midnight - dawn
      if (_date.isBefore(prayersCurrent.dawn)) {
        _current = jamaahPerPrayer[5] ? jamaahPrevious.dusk : prayersPrevious.dusk;
        _next = prayersCurrent.dawn;
        _previous = prayersPrevious.sunset;
        _currentId = 5;
      }
      // dawn - fajr jamaah
      else if (_date.isBefore(jamaahCurrent.dawn)) {
        _current = prayersCurrent.dawn;
        _next = jamaahPerPrayer[0] ? jamaahCurrent.dawn : prayersCurrent.sunrise;
        _previous = prayersCurrent.dawn;
        _currentId = 0;
        _jamaahPending = jamaahPerPrayer[0];
      }
      // fajr jammah - sunrise
      else if (_date.isBefore(prayersCurrent.sunrise)) {
        _current = jamaahPerPrayer[0] ? jamaahCurrent.dawn : prayersCurrent.dawn;
        _next = prayersCurrent.sunrise;
        _previous = prayersPrevious.dusk;
        _currentId = 0;
      }
      // sunrise - midday
      else if (_date.isBefore(prayersCurrent.midday)) {
        _current = prayersCurrent.sunrise;
        _next = prayersCurrent.midday;
        _previous = prayersCurrent.dawn;
        _currentId = 1;
      }
      // midday - dhuhr jamaah
      else if (_date.isBefore(jamaahCurrent.midday)) {
        _current = prayersCurrent.midday;
        _next = jamaahPerPrayer[2] ? jamaahCurrent.midday : prayersCurrent.afternoon;
        _previous = prayersCurrent.sunrise;
        _currentId = 2;
        _jamaahPending = jamaahPerPrayer[2];
      }
      // dhuhr jamaah - afternoon
      else if (_date.isBefore(prayersCurrent.afternoon)) {
        _current = jamaahPerPrayer[2] ? jamaahCurrent.midday : prayersCurrent.midday;
        _next = prayersCurrent.afternoon;
        _previous = prayersCurrent.sunrise;
        _currentId = 2;
      }
      // afternoon - asr jamaah
      else if (_date.isBefore(jamaahCurrent.afternoon)) {
        _current = prayersCurrent.afternoon;
        _next = jamaahPerPrayer[3] ? jamaahCurrent.afternoon : prayersCurrent.sunset;
        _previous = prayersCurrent.midday;
        _currentId = 3;
        _jamaahPending = jamaahPerPrayer[3];
      }
      // asr jamaah - sunset
      else if (_date.isBefore(prayersCurrent.sunset)) {
        _current = jamaahPerPrayer[3] ? jamaahCurrent.afternoon : prayersCurrent.afternoon;
        _next = prayersCurrent.sunset;
        _previous = prayersCurrent.midday;
        _currentId = 3;
      }
      // sunset - maghrib jamaah
      else if (_date.isBefore(jamaahCurrent.sunset)) {
        _current = prayersCurrent.sunset;
        _next = jamaahPerPrayer[4] ? jamaahCurrent.sunset : prayersCurrent.dusk;
        _previous = prayersCurrent.afternoon;
        _currentId = 4;
        _jamaahPending = jamaahPerPrayer[4];
      }
      // maghrib jamaah - dusk
      else if (_date.isBefore(prayersCurrent.dusk)) {
        _current = jamaahPerPrayer[4] ? jamaahCurrent.sunset : prayersCurrent.sunset;
        _next = prayersCurrent.dusk;
        _previous = prayersCurrent.afternoon;
        _currentId = 4;
      }
      // dusk - isha jamaah
      else if (_date.isBefore(jamaahCurrent.dusk)) {
        _current = prayersCurrent.dusk;
        _next = jamaahPerPrayer[5] ? jamaahCurrent.dusk : prayersNext.dawn;
        _previous = prayersCurrent.sunset;
        _currentId = 5;
        _jamaahPending = jamaahPerPrayer[5];
      }
      // isha jamaah - midnight
      else {
        _current = jamaahPerPrayer[5] ? jamaahCurrent.dusk : prayersCurrent.dusk;
        _next = prayersNext.dawn;
        _previous = prayersCurrent.sunset;
        _currentId = 5;
        _isAfterIsha = true;
      }
    }

    _nextId = _currentId == 5 ? 0 : _currentId + 1;
    _previousId = _currentId == 0 ? 5 : _currentId - 1;

    // components
    this.time = _date;
    this.current = _current;
    this.next = _next;
    this.previous = _previous;
    this.isAfterIsha = _isAfterIsha;
    this.currentId = _currentId;
    this.nextId = _nextId;
    this.previousId = _previousId;
    this.countDown = _next.difference(_date);
    this.countUp = _date.difference(_current);
    this.isLeap = _date.year % 4 == 0;

    percentage =
        round2Decimals(100 * (this.countUp.inSeconds / (this.countDown + this.countUp).inSeconds));

    this.percentage = percentage.isNaN ? 0 : percentage;
    this.jamaahPending = _jamaahPending;
    print(lat);
    this.qibla = Qibla.qibla(new Coordinates(lat, lng));

    var hTime = HijriCalendar.fromDate(_date);
    this.hijri = [hTime.hYear, hTime.hMonth, hTime.hDay];

    //end
  }
}

Calc defaultCalc = Calc(
  DateTime.now(),
  prayersCurrent: prayertimes.PrayerTimes.times,
  prayersNext: prayertimes.PrayerTimes.times,
  prayersPrevious: prayertimes.PrayerTimes.times,
  jamaahOn: false,
  jamaahCurrent: JamaahTimes(),
  jamaahPrevious: JamaahTimes(),
  lat: 0,
  lng: 0,
  jamaahPerPrayer: [false, false, false, false, false, false],
);
