import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:hijri/hijri_calendar.dart';
import 'package:prayer_timetable/src/components/Prayer.dart';
import 'package:prayer_timetable/src/func/helpers.dart';

// import 'package:adhan_dart/adhan_dart.dart';

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
class Utils {
  DateTime time = DateTime.now();

  /// Prayer times
  DateTime current = DateTime.now();
  DateTime next = DateTime.now();
  DateTime previous = DateTime.now();

  /// Prayer details
  int currentId = 1;
  int previousId = 0;
  int nextId = 2;
  bool isJamaahPending = false;
  bool isAfterIsha = false;

  /// Sunnah
  DateTime midnight = DateTime.now();
  DateTime lastThird = DateTime.now();

  /// Countdown
  Duration countDown = Duration.zero;
  Duration countUp = Duration(seconds: 10);
  double percentage = 0.1;

  /// Qibla direction
  double qibla = 0;

  /// Years
  List<int> hijri = [];
  bool isLeap = false;

  Utils(
    DateTime _date, {
    required List<Prayer> prayersCurrent,
    required List<Prayer> prayersNext,
    required List<Prayer> prayersPrevious,
    bool? jamaahOn,
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

    /// NO JAMAAH
    if (jamaahOn != null &&
        prayersCurrent != null &&
        prayersNext != null &&
        prayersPrevious != null &&
        !jamaahOn) {
      // midnight - fajr
      if (_date.isBefore(prayersCurrent[0].prayerTime)) {
        _previous = prayersPrevious[4].prayerTime;
        _current = prayersPrevious[5].prayerTime;
        _next = prayersCurrent[0].prayerTime;
        _currentId = 5;
      }
      // fajr - sunrise
      else if (_date.isBefore(prayersCurrent[1].prayerTime)) {
        _previous = prayersPrevious[5].prayerTime;
        _current = prayersCurrent[0].prayerTime;
        _next = prayersCurrent[1].prayerTime;
        _currentId = 0;
      }
      // sunrise - dhuhr
      else if (_date.isBefore(prayersCurrent[2].prayerTime)) {
        _previous = prayersCurrent[0].prayerTime;
        _current = prayersCurrent[1].prayerTime;
        _next = prayersCurrent[2].prayerTime;
        _currentId = 1;
      }
      // dhuhr - asr
      else if (_date.isBefore(prayersCurrent[3].prayerTime)) {
        _previous = prayersCurrent[1].prayerTime;
        _current = prayersCurrent[2].prayerTime;
        _next = prayersCurrent[3].prayerTime;
        _currentId = 2;
      }
      // asr - maghrib
      else if (_date.isBefore(prayersCurrent[4].prayerTime)) {
        _previous = prayersCurrent[2].prayerTime;
        _current = prayersCurrent[3].prayerTime;
        _next = prayersCurrent[4].prayerTime;
        _currentId = 3;
      }
      // maghrib - isha
      else if (_date.isBefore(prayersCurrent[5].prayerTime)) {
        _previous = prayersCurrent[3].prayerTime;
        _current = prayersCurrent[4].prayerTime;
        _next = prayersCurrent[5].prayerTime;
        _currentId = 4;
      } else {
        // isha till midnight
        _previous = prayersCurrent[4].prayerTime;
        _current = prayersCurrent[5].prayerTime;
        _next = prayersNext[0].prayerTime;
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
        jamaahOn) {
      if (jamaahPerPrayer == null) {
        jamaahPerPrayer = const [true, true, true, true, true, true];
      }

      // midnight - fajr
      if (_date.isBefore(prayersCurrent[0].prayerTime)) {
        _previous = prayersPrevious[4].prayerTime;
        _current =
            jamaahPerPrayer[5] ? prayersPrevious[5].jamaahTime : prayersPrevious[5].prayerTime;
        _next = prayersCurrent[0].prayerTime;
        _currentId = 5;
      }
      // fajr - fajr jamaah
      else if (_date.isBefore(prayersCurrent[0].jamaahTime)) {
        _previous = prayersPrevious[5].prayerTime;
        _current = prayersCurrent[0].prayerTime;
        _next = jamaahPerPrayer[0] ? prayersCurrent[0].jamaahTime : prayersCurrent[1].prayerTime;
        _currentId = 0;
        _jamaahPending = jamaahPerPrayer[0];
      }
      // fajr jammah - sunrise
      else if (_date.isBefore(prayersCurrent[1].prayerTime)) {
        _previous = prayersPrevious[5].prayerTime;
        _current = jamaahPerPrayer[0] ? prayersCurrent[0].jamaahTime : prayersCurrent[0].prayerTime;
        _next = prayersCurrent[1].prayerTime;
        _currentId = 0;
      }
      // sunrise - dhuhr
      else if (_date.isBefore(prayersCurrent[2].prayerTime)) {
        _previous = prayersCurrent[0].prayerTime;
        _current = prayersCurrent[1].prayerTime;
        _next = prayersCurrent[2].prayerTime;
        _currentId = 1;
      }
      // dhuhr - dhuhr jamaah
      else if (_date.isBefore(prayersCurrent[2].jamaahTime)) {
        _previous = prayersCurrent[1].prayerTime;
        _current = prayersCurrent[2].prayerTime;
        _next = jamaahPerPrayer[2] ? prayersCurrent[2].jamaahTime : prayersCurrent[3].prayerTime;
        _currentId = 2;
        _jamaahPending = jamaahPerPrayer[2];
      }
      // dhuhr jamaah - asr
      else if (_date.isBefore(prayersCurrent[3].prayerTime)) {
        _previous = prayersCurrent[1].prayerTime;
        _current = jamaahPerPrayer[2] ? prayersCurrent[2].jamaahTime : prayersCurrent[2].prayerTime;
        _next = prayersCurrent[3].prayerTime;
        _currentId = 2;
      }
      // asr - asr jamaah
      else if (_date.isBefore(prayersCurrent[3].jamaahTime)) {
        _previous = prayersCurrent[2].prayerTime;
        _current = prayersCurrent[3].prayerTime;
        _next = jamaahPerPrayer[3] ? prayersCurrent[3].jamaahTime : prayersCurrent[4].prayerTime;
        _currentId = 3;
        _jamaahPending = jamaahPerPrayer[3];
      }
      // asr jamaah - maghrib
      else if (_date.isBefore(prayersCurrent[4].prayerTime)) {
        _previous = prayersCurrent[2].prayerTime;
        _current = jamaahPerPrayer[3] ? prayersCurrent[3].jamaahTime : prayersCurrent[3].prayerTime;
        _next = prayersCurrent[4].prayerTime;
        _currentId = 3;
      }
      // maghrib - maghrib jamaah
      else if (_date.isBefore(prayersCurrent[4].jamaahTime)) {
        _previous = prayersCurrent[3].prayerTime;
        _current = prayersCurrent[4].prayerTime;
        _next = jamaahPerPrayer[4] ? prayersCurrent[4].jamaahTime : prayersCurrent[5].prayerTime;
        _currentId = 4;
        _jamaahPending = jamaahPerPrayer[4];
      }
      // maghrib jamaah - isha
      else if (_date.isBefore(prayersCurrent[5].prayerTime)) {
        _previous = prayersCurrent[3].prayerTime;
        _current = jamaahPerPrayer[4] ? prayersCurrent[4].jamaahTime : prayersCurrent[4].prayerTime;
        _next = prayersCurrent[5].prayerTime;
        _currentId = 4;
      }
      // isha - isha jamaah
      else if (_date.isBefore(prayersCurrent[5].jamaahTime)) {
        _previous = prayersCurrent[4].prayerTime;
        _current = prayersCurrent[5].prayerTime;
        _next = jamaahPerPrayer[5] ? prayersCurrent[5].jamaahTime : prayersNext[0].prayerTime;
        _currentId = 5;
        _jamaahPending = jamaahPerPrayer[5];
      }
      // isha jamaah - midnight
      else {
        _previous = prayersCurrent[4].prayerTime;
        _current = jamaahPerPrayer[5] ? prayersCurrent[5].prayerTime : prayersCurrent[5].prayerTime;
        _next = prayersNext[0].prayerTime;
        _currentId = 5;
        _isAfterIsha = true;
      }
    }

    _nextId = _currentId == 5 ? 0 : _currentId + 1;
    _previousId = _currentId == 0 ? 5 : _currentId - 1;

    /// Sunnah
    DateTime dawnTomorrow = prayersNext[0].prayerTime;
    DateTime dawnToday = prayersCurrent[0].prayerTime;
    DateTime sunsetToday = prayersCurrent[4].prayerTime;
    DateTime sunsetYesterday = prayersPrevious[4].prayerTime;
    this.midnight = time.isBefore(dawnToday)
        ? sunsetYesterday
            .add(Duration(minutes: (dawnToday.difference(sunsetYesterday).inMinutes / 2).floor()))
        : sunsetToday
            .add(Duration(minutes: (dawnTomorrow.difference(sunsetToday).inMinutes / 2).floor()));

    this.lastThird = time.isBefore(dawnToday)
        ? sunsetYesterday.add(
            Duration(minutes: (2 * dawnToday.difference(sunsetYesterday).inMinutes / 3).floor()))
        : sunsetToday.add(
            Duration(minutes: (2 * dawnTomorrow.difference(sunsetToday).inMinutes / 3).floor()));

    // components
    this.time = _date;
    this.current = _current;
    this.next = _next;
    this.previous = _previous;

    this.currentId = _currentId;
    this.nextId = _nextId;
    this.previousId = _previousId;
    this.isAfterIsha = _isAfterIsha;
    this.isJamaahPending = _jamaahPending;

    this.countDown = _next.difference(_date);
    this.countUp = _date.difference(_current);

    percentage =
        round2Decimals(100 * (this.countUp.inSeconds / (this.countDown + this.countUp).inSeconds));

    this.percentage = percentage.isNaN ? 0 : percentage;

    // print(lat);
    this.qibla = adhan.Qibla.qibla(new adhan.Coordinates(lat, lng));

    var hTime = HijriCalendar.fromDate(_date);
    this.hijri = [hTime.hYear, hTime.hMonth, hTime.hDay];
    this.isLeap = _date.year % 4 == 0;

    //end
  }
}

Utils defaultUtils = Utils(
  DateTime.now(),
  prayersCurrent: List<Prayer>.filled(6, Prayer(), growable: false),
  prayersNext: List<Prayer>.filled(6, Prayer(), growable: false),
  prayersPrevious: List<Prayer>.filled(6, Prayer(), growable: false),
  jamaahOn: false,
  lat: 0,
  lng: 0,
  jamaahPerPrayer: [false, false, false, false, false, false],
);
