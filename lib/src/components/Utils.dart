import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:hijri/hijri_calendar.dart';
import 'package:prayer_timetable/src/components/Prayer.dart';
import 'package:prayer_timetable/src/func/helpers.dart';
// ignore: unused_import
import 'package:timezone/timezone.dart' as tz;

// import 'package:adhan_dart/adhan_dart.dart';

/// Utility class providing prayer time analysis and additional Islamic calculations.
///
/// This class analyzes the current time in relation to prayer times and provides
/// useful information such as:
/// - Which prayer is currently active
/// - Which prayer is next
/// - Countdown to next prayer
/// - Prayer completion percentage
/// - Qibla direction
/// - Hijri date information
/// - Sunnah times (midnight, last third of night)
///
/// The class handles both regular prayer times and jamaah (congregation) times,
/// providing accurate status information for mosque applications.
///
/// Example usage:
/// ```dart
/// final utils = Utils(
///   DateTime.now(),
///   prayersCurrent: currentPrayers,
///   prayersNext: nextPrayers,
///   prayersPrevious: previousPrayers,
///   jamaahOn: true,
///   lat: 40.7128,
///   lng: -74.0060,
/// );
///
/// print('Current prayer: ${utils.currentId}');
/// print('Time until next prayer: ${utils.countDown}');
/// print('Qibla direction: ${utils.qibla}°');
/// ```
class Utils {
  /// The current time being analyzed
  DateTime time = DateTime.now();

  /// Prayer times relative to the current time
  /// The currently active prayer time
  DateTime current = DateTime.now();

  /// The next upcoming prayer time
  DateTime next = DateTime.now();

  /// The most recent past prayer time
  DateTime previous = DateTime.now();

  /// Prayer identification and status
  /// ID of the currently active prayer (0-5)
  int currentId = 1;

  /// ID of the previous prayer (0-5)
  int previousId = 0;

  /// ID of the next prayer (0-5)
  int nextId = 2;

  /// Whether jamaah time is pending for current prayer
  bool isJamaahPending = false;

  /// Whether current time is after Isha prayer (affects next day calculations)
  bool isAfterIsha = false;

  /// Sunnah (recommended) prayer times
  /// Islamic midnight (halfway between sunset and dawn)
  DateTime midnight = DateTime.now();

  /// Last third of the night (recommended time for Tahajjud prayer)
  DateTime lastThird = DateTime.now();

  /// Time calculations
  /// Duration until the next prayer
  Duration countDown = Duration.zero;

  /// Duration since the current prayer started
  Duration countUp = Duration(seconds: 10);

  /// Percentage of current prayer period completed (0-100)
  double percentage = 0.1;

  /// Qibla direction in degrees from North (0-360)
  double qibla = 0;

  /// Calendar information
  /// Hijri date as [year, month, day]
  List<int> hijri = [];

  /// Whether the current Gregorian year is a leap year
  bool isLeap = false;

  /// UTC offset in hours for the current timezone
  int? utcOffsetHours;

  /// Creates a Utils instance with comprehensive prayer time analysis.
  ///
  /// [_date] - The current date/time to analyze
  /// [prayersCurrent] - List of 6 prayers for the current day
  /// [prayersNext] - List of 6 prayers for the next day
  /// [prayersPrevious] - List of 6 prayers for the previous day
  /// [jamaahOn] - Whether jamaah times are enabled
  /// [lat] - Latitude for Qibla calculation
  /// [lng] - Longitude for Qibla calculation
  /// [jamaahPerPrayer] - Which prayers have jamaah enabled (6 booleans)
  /// [utcOffsetHours] - UTC offset in hours for timezone
  Utils(
    DateTime _date, {
    required List<Prayer> prayersCurrent,
    required List<Prayer> prayersNext,
    required List<Prayer> prayersPrevious,
    bool? jamaahOn,
    double lat = 0.0,
    double lng = 0.0,
    List<bool>? jamaahPerPrayer,
    int? utcOffsetHours,
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
    if (jamaahOn != null && !jamaahOn) {
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

    if (jamaahOn != null && jamaahOn) {
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

/// Default Utils instance used as a fallback when no specific utils are provided.
///
/// This instance uses current time with empty prayer lists and disabled jamaah.
/// It's primarily used for initialization purposes.
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
