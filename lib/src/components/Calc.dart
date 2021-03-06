import 'package:prayer_timetable/src/components/Prayers.dart';
import 'package:prayer_timetable/src/components/Jamaah.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

import 'package:adhan_dart/adhan_dart.dart';

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

  Calc(
    DateTime _time,
    Prayers _prayersToday,
    Prayers _prayersTomorrow,
    Prayers _prayersYesterday,
    bool _jamaahOn,
    Jamaah _jamaahToday,
    Jamaah _jamaahTomorrow,
    Jamaah _jamaahYesterday,
    double _lat,
    double _lng,
  ) {
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
    if (!_jamaahOn) {
      if (_time.isBefore(_prayersToday.dawn)) {
        _current = _prayersYesterday.dusk;
        _next = _prayersToday.dawn;
        _previous = _prayersYesterday.sunset;
        _currentId = 5;
      } else if (_time.isBefore(_prayersToday.sunrise)) {
        _current = _prayersToday.dawn;
        _next = _prayersToday.sunrise;
        _previous = _prayersYesterday.dusk;
        _currentId = 0;
      } else if (_time.isBefore(_prayersToday.midday)) {
        _current = _prayersToday.sunrise;
        _next = _prayersToday.midday;
        _previous = _prayersToday.dawn;
        _currentId = 1;
      } else if (_time.isBefore(_prayersToday.afternoon)) {
        _current = _prayersToday.midday;
        _next = _prayersToday.afternoon;
        _previous = _prayersToday.sunrise;
        _currentId = 2;
      } else if (_time.isBefore(_prayersToday.sunset)) {
        _current = _prayersToday.afternoon;
        _next = _prayersToday.sunset;
        _previous = _prayersToday.midday;
        _currentId = 3;
      } else if (_time.isBefore(_prayersToday.dusk)) {
        _current = _prayersToday.sunset;
        _next = _prayersToday.dusk;
        _previous = _prayersToday.afternoon;
        _currentId = 4;
      } else {
        // dusk till midnight
        _current = _prayersToday.dusk;
        _next = _prayersTomorrow.dawn;
        _previous = _prayersToday.sunset;
        _currentId = 5;
        _isAfterIsha = true;
      }
    }

    // JAMAAH
    bool _jamaahPending = false;
    if (_jamaahOn) {
      // midnight - dawn
      if (_time.isBefore(_prayersToday.dawn)) {
        _current = _prayersYesterday.dusk;
        _next = _prayersToday.dawn;
        _previous = _prayersYesterday.sunset;
        _currentId = 5;
      }
      // dawn - fajr jamaah
      else if (_time.isBefore(_jamaahToday.dawn)) {
        _current = _prayersToday.dawn;
        _next = _jamaahToday.dawn;
        _previous = _prayersToday.dawn;
        _currentId = 0;
        _jamaahPending = true;
      }
      // fajr jammah - sunrise
      else if (_time.isBefore(_prayersToday.sunrise)) {
        _current = _prayersToday.dawn;
        _next = _prayersToday.sunrise;
        _previous = _prayersYesterday.dusk;
        _currentId = 0;
      }
      // sunrise - midday
      else if (_time.isBefore(_prayersToday.midday)) {
        _current = _prayersToday.sunrise;
        _next = _prayersToday.midday;
        _previous = _prayersToday.dawn;
        _currentId = 1;
      }
      // midday - dhuhr jamaah
      else if (_time.isBefore(_jamaahToday.midday)) {
        _current = _prayersToday.midday;
        _next = _jamaahToday.midday;
        _previous = _prayersToday.sunrise;
        _currentId = 2;
        _jamaahPending = true;
      }
      // dhuhr jamaah - afternoon
      else if (_time.isBefore(_prayersToday.afternoon)) {
        _current = _jamaahToday.midday;
        _next = _prayersToday.afternoon;
        _previous = _prayersToday.sunrise;
        _currentId = 2;
      }
      // afternoon - asr jamaah
      else if (_time.isBefore(_jamaahToday.afternoon)) {
        _current = _prayersToday.afternoon;
        _next = _jamaahToday.afternoon;
        _previous = _prayersToday.midday;
        _currentId = 3;
        _jamaahPending = true;
      }
      // asr jamaah - sunset
      else if (_time.isBefore(_prayersToday.sunset)) {
        _current = _prayersToday.afternoon;
        _next = _prayersToday.sunset;
        _previous = _prayersToday.midday;
        _currentId = 3;
      }
      // sunset - maghrib jamaah
      else if (_time.isBefore(_jamaahToday.sunset)) {
        _current = _prayersToday.sunset;
        _next = _jamaahToday.sunset;
        _previous = _prayersToday.afternoon;
        _currentId = 4;
        _jamaahPending = true;
      }
      // maghrib jamaah - dusk
      else if (_time.isBefore(_prayersToday.dusk)) {
        _current = _prayersToday.sunset;
        _next = _prayersToday.dusk;
        _previous = _prayersToday.afternoon;
        _currentId = 4;
      }
      // dusk - isha jamaah
      else if (_time.isBefore(_jamaahToday.dusk)) {
        _current = _prayersToday.dusk;
        _next = _jamaahToday.dusk;
        _previous = _prayersToday.sunset;
        _currentId = 5;
        _jamaahPending = true;
      }
      // isha jamaah - midnight
      else {
        _current = _prayersToday.dusk;
        _next = _prayersTomorrow.dawn;
        _previous = _prayersToday.sunset;
        _currentId = 5;
        _isAfterIsha = true;
      }
    }

    _nextId = _currentId == 5 ? 0 : _currentId + 1;
    _previousId = _currentId == 0 ? 5 : _currentId - 1;

    // components
    this.time = _time;
    this.current = _current;
    this.next = _next;
    this.previous = _previous;
    this.isAfterIsha = _isAfterIsha;
    this.currentId = _currentId;
    this.nextId = _nextId;
    this.previousId = _previousId;
    this.countDown = _next.difference(_time);
    this.countUp = _time.difference(_current);

    percentage = round2Decimals(100 *
        (this.countUp.inSeconds / (this.countDown + this.countUp).inSeconds));

    this.percentage = percentage.isNaN ? 0 : percentage;
    this.jamaahPending = _jamaahPending;
    this.qibla = Qibla.qibla(new Coordinates(_lat, _lng));

    //end
  }
}
