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
  /// [inputDate] - The current date/time to analyze
  /// [prayersCurrent] - List of 6 prayers for the current day
  /// [prayersNext] - List of 6 prayers for the next day
  /// [prayersPrevious] - List of 6 prayers for the previous day
  /// [jamaahOn] - Whether jamaah times are enabled
  /// [lat] - Latitude for Qibla calculation
  /// [lng] - Longitude for Qibla calculation
  /// [jamaahPerPrayer] - Which prayers have jamaah enabled (6 booleans)
  /// [utcOffsetHours] - UTC offset in hours for timezone
  Utils(
    DateTime inputDate, {
    required List<Prayer> prayersCurrent,
    required List<Prayer> prayersNext,
    required List<Prayer> prayersPrevious,
    bool? jamaahOn,
    double lat = 0.0,
    double lng = 0.0,
    List<bool>? jamaahPerPrayer,
    int? utcOffsetHours,
  }) {
    DateTime tempCurrent = current;
    DateTime tempNext = next;
    DateTime tempPrevious = previous;
    int tempCurrentId = currentId;
    int tempPreviousId = previousId;
    int tempNextId = nextId;
    bool tempIsAfterIsha = false;

    // time is local for PrayerTimetable and PrayerTimetableAlt
    // utc for PrayerTimetable
    /* *********************** */
    /* _current, _previous, _next */
    /* *********************** */

    /// NO JAMAAH
    if (jamaahOn != null && !jamaahOn) {
      // midnight - fajr
      if (inputDate.isBefore(prayersCurrent[0].prayerTime)) {
        tempPrevious = prayersPrevious[4].prayerTime;
        tempCurrent = prayersPrevious[5].prayerTime;
        tempNext = prayersCurrent[0].prayerTime;
        tempCurrentId = 5;
      }
      // fajr - sunrise
      else if (inputDate.isBefore(prayersCurrent[1].prayerTime)) {
        tempPrevious = prayersPrevious[5].prayerTime;
        tempCurrent = prayersCurrent[0].prayerTime;
        tempNext = prayersCurrent[1].prayerTime;
        tempCurrentId = 0;
      }
      // sunrise - dhuhr
      else if (inputDate.isBefore(prayersCurrent[2].prayerTime)) {
        tempPrevious = prayersCurrent[0].prayerTime;
        tempCurrent = prayersCurrent[1].prayerTime;
        tempNext = prayersCurrent[2].prayerTime;
        tempCurrentId = 1;
      }
      // dhuhr - asr
      else if (inputDate.isBefore(prayersCurrent[3].prayerTime)) {
        tempPrevious = prayersCurrent[1].prayerTime;
        tempCurrent = prayersCurrent[2].prayerTime;
        tempNext = prayersCurrent[3].prayerTime;
        tempCurrentId = 2;
      }
      // asr - maghrib
      else if (inputDate.isBefore(prayersCurrent[4].prayerTime)) {
        tempPrevious = prayersCurrent[2].prayerTime;
        tempCurrent = prayersCurrent[3].prayerTime;
        tempNext = prayersCurrent[4].prayerTime;
        tempCurrentId = 3;
      }
      // maghrib - isha
      else if (inputDate.isBefore(prayersCurrent[5].prayerTime)) {
        tempPrevious = prayersCurrent[3].prayerTime;
        tempCurrent = prayersCurrent[4].prayerTime;
        tempNext = prayersCurrent[5].prayerTime;
        tempCurrentId = 4;
      } else {
        // isha till midnight
        tempPrevious = prayersCurrent[4].prayerTime;
        tempCurrent = prayersCurrent[5].prayerTime;
        tempNext = prayersNext[0].prayerTime;
        tempCurrentId = 5;
        tempIsAfterIsha = true;
      }
    }

    // JAMAAH
    bool tempJamaahPending = false;

    if (jamaahOn != null && jamaahOn) {
      jamaahPerPrayer ??= const [true, true, true, true, true, true];

      // midnight - fajr
      if (inputDate.isBefore(prayersCurrent[0].prayerTime)) {
        tempPrevious = prayersPrevious[4].prayerTime;
        tempCurrent =
            jamaahPerPrayer[5] ? prayersPrevious[5].jamaahTime : prayersPrevious[5].prayerTime;
        tempNext = prayersCurrent[0].prayerTime;
        tempCurrentId = 5;
      }
      // fajr - fajr jamaah
      else if (inputDate.isBefore(prayersCurrent[0].jamaahTime)) {
        tempPrevious = prayersPrevious[5].prayerTime;
        tempCurrent = prayersCurrent[0].prayerTime;
        tempNext = jamaahPerPrayer[0] ? prayersCurrent[0].jamaahTime : prayersCurrent[1].prayerTime;
        tempCurrentId = 0;
        tempJamaahPending = jamaahPerPrayer[0];
      }
      // fajr jammah - sunrise
      else if (inputDate.isBefore(prayersCurrent[1].prayerTime)) {
        tempPrevious = prayersPrevious[5].prayerTime;
        tempCurrent =
            jamaahPerPrayer[0] ? prayersCurrent[0].jamaahTime : prayersCurrent[0].prayerTime;
        tempNext = prayersCurrent[1].prayerTime;
        tempCurrentId = 0;
      }
      // sunrise - dhuhr
      else if (inputDate.isBefore(prayersCurrent[2].prayerTime)) {
        tempPrevious = prayersCurrent[0].prayerTime;
        tempCurrent = prayersCurrent[1].prayerTime;
        tempNext = prayersCurrent[2].prayerTime;
        tempCurrentId = 1;
      }
      // dhuhr - dhuhr jamaah
      else if (inputDate.isBefore(prayersCurrent[2].jamaahTime)) {
        tempPrevious = prayersCurrent[1].prayerTime;
        tempCurrent = prayersCurrent[2].prayerTime;
        tempNext = jamaahPerPrayer[2] ? prayersCurrent[2].jamaahTime : prayersCurrent[3].prayerTime;
        tempCurrentId = 2;
        tempJamaahPending = jamaahPerPrayer[2];
      }
      // dhuhr jamaah - asr
      else if (inputDate.isBefore(prayersCurrent[3].prayerTime)) {
        tempPrevious = prayersCurrent[1].prayerTime;
        tempCurrent =
            jamaahPerPrayer[2] ? prayersCurrent[2].jamaahTime : prayersCurrent[2].prayerTime;
        tempNext = prayersCurrent[3].prayerTime;
        tempCurrentId = 2;
      }
      // asr - asr jamaah
      else if (inputDate.isBefore(prayersCurrent[3].jamaahTime)) {
        tempPrevious = prayersCurrent[2].prayerTime;
        tempCurrent = prayersCurrent[3].prayerTime;
        tempNext = jamaahPerPrayer[3] ? prayersCurrent[3].jamaahTime : prayersCurrent[4].prayerTime;
        tempCurrentId = 3;
        tempJamaahPending = jamaahPerPrayer[3];
      }
      // asr jamaah - maghrib
      else if (inputDate.isBefore(prayersCurrent[4].prayerTime)) {
        tempPrevious = prayersCurrent[2].prayerTime;
        tempCurrent =
            jamaahPerPrayer[3] ? prayersCurrent[3].jamaahTime : prayersCurrent[3].prayerTime;
        tempNext = prayersCurrent[4].prayerTime;
        tempCurrentId = 3;
      }
      // maghrib - maghrib jamaah
      else if (inputDate.isBefore(prayersCurrent[4].jamaahTime)) {
        tempPrevious = prayersCurrent[3].prayerTime;
        tempCurrent = prayersCurrent[4].prayerTime;
        tempNext = jamaahPerPrayer[4] ? prayersCurrent[4].jamaahTime : prayersCurrent[5].prayerTime;
        tempCurrentId = 4;
        tempJamaahPending = jamaahPerPrayer[4];
      }
      // maghrib jamaah - isha
      else if (inputDate.isBefore(prayersCurrent[5].prayerTime)) {
        tempPrevious = prayersCurrent[3].prayerTime;
        tempCurrent =
            jamaahPerPrayer[4] ? prayersCurrent[4].jamaahTime : prayersCurrent[4].prayerTime;
        tempNext = prayersCurrent[5].prayerTime;
        tempCurrentId = 4;
      }
      // isha - isha jamaah
      else if (inputDate.isBefore(prayersCurrent[5].jamaahTime)) {
        tempPrevious = prayersCurrent[4].prayerTime;
        tempCurrent = prayersCurrent[5].prayerTime;
        tempNext = jamaahPerPrayer[5] ? prayersCurrent[5].jamaahTime : prayersNext[0].prayerTime;
        tempCurrentId = 5;
        tempJamaahPending = jamaahPerPrayer[5];
      }
      // isha jamaah - midnight
      else {
        tempPrevious = prayersCurrent[4].prayerTime;
        tempCurrent =
            jamaahPerPrayer[5] ? prayersCurrent[5].prayerTime : prayersCurrent[5].prayerTime;
        tempNext = prayersNext[0].prayerTime;
        tempCurrentId = 5;
        tempIsAfterIsha = true;
      }
    }

    tempNextId = tempCurrentId == 5 ? 0 : tempCurrentId + 1;
    tempPreviousId = tempCurrentId == 0 ? 5 : tempCurrentId - 1;

    /// Sunnah
    DateTime dawnTomorrow = prayersNext[0].prayerTime;
    DateTime dawnToday = prayersCurrent[0].prayerTime;
    DateTime sunsetToday = prayersCurrent[4].prayerTime;
    DateTime sunsetYesterday = prayersPrevious[4].prayerTime;
    midnight = time.isBefore(dawnToday)
        ? sunsetYesterday
            .add(Duration(minutes: (dawnToday.difference(sunsetYesterday).inMinutes / 2).floor()))
        : sunsetToday
            .add(Duration(minutes: (dawnTomorrow.difference(sunsetToday).inMinutes / 2).floor()));

    lastThird = time.isBefore(dawnToday)
        ? sunsetYesterday.add(
            Duration(minutes: (2 * dawnToday.difference(sunsetYesterday).inMinutes / 3).floor()))
        : sunsetToday.add(
            Duration(minutes: (2 * dawnTomorrow.difference(sunsetToday).inMinutes / 3).floor()));

    // components
    time = inputDate;
    current = tempCurrent;
    next = tempNext;
    previous = tempPrevious;

    currentId = tempCurrentId;
    nextId = tempNextId;
    previousId = tempPreviousId;
    isAfterIsha = tempIsAfterIsha;
    isJamaahPending = tempJamaahPending;

    countDown = tempNext.difference(inputDate);
    countUp = inputDate.difference(tempCurrent);

    percentage = round2Decimals(100 * (countUp.inSeconds / (countDown + countUp).inSeconds));

    percentage = percentage.isNaN ? 0 : percentage;

    // print(lat);
    qibla = adhan.Qibla.qibla(adhan.Coordinates(lat, lng));

    var hTime = HijriCalendar.fromDate(inputDate);
    hijri = [hTime.hYear, hTime.hMonth, hTime.hDay];
    isLeap = inputDate.year % 4 == 0;

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
