import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/PrayerTimes.dart';
import 'package:prayer_timetable/src/components/Calc.dart';
import 'package:prayer_timetable/src/func/prayerTimetableList.dart';
import 'package:prayer_timetable/src/components/JamaahTimes.dart';

class PrayerTimetableList {
  /// Prayer Times
  PrayerTimes currentPrayerTimes = PrayerTimes.now;
  PrayerTimes previousPrayerTimes = PrayerTimes.now;
  PrayerTimes nextPrayerTimes = PrayerTimes.now;

  /// Jamaah Times
  PrayerTimes currentJamaahTimes = PrayerTimes.now;
  PrayerTimes previousJamaahTimes = PrayerTimes.now;
  PrayerTimes nextJamaahTimes = PrayerTimes.now;

  /// Sunnah times - midnight and last third
  late Sunnah sunnah;

  /// Calculations based on set DateTime
  late Calc calc;

  /// Calculations with forced now for DateTime
  Calc? calcToday;

  PrayerTimetableList(
    List timetable, {
    String timezone = 'Europe/Dublin',
    List<int> difference = const [0, 0, 0, 0, 0, 0],
    int? year,
    int? month,
    int? day,
    int hijriOffset = 0,
    bool summerTimeCalc = true,

    /// Enables jamaah times globaly.
    bool jamaahOn = false,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    List<bool>? jamaahPerPrayer,
    //  = const [
    //   false,
    //   false,
    //   false,
    //   false,
    //   false,
    //   false
    // ],
    List<String> jamaahMethods = const [
      'afterthis',
      '',
      'afterthis',
      'afterthis',
      'afterthis',
      'afterthis'
    ],
    List<List<dynamic>> jamaahOffsets = const [
      [0, 0],
      [],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0]
    ],
    double lat = 0,
    double lng = 0,
  }) {
    DateTime now = DateTime.now();
    // DateTime beginingOfYear = DateTime(timestamp.year); // Jan 1, 0:00

    // Local date
    DateTime date =
        DateTime(year ?? now.year, month ?? now.month, day ?? now.day, 0, 0);

    // // Local dates needed for dst calc and local midnight past (0:00)
    // DateTime dateLocal = DateTime(
    //     year ?? timestamp.year,
    //     month ?? timestamp.month,
    //     day ?? timestamp.day,
    //     12,
    //     0); // using noon of local date to avoid +- 1 hour
    // define now (local)
    DateTime nowLocal = DateTime.now();

    // ***** current, next and previous
    DateTime current = date;
    DateTime next = date.add(Duration(days: 1));
    DateTime previous = date.subtract(Duration(days: 1));

    // ***** today, tomorrow and yesterday
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime yesterday = today.subtract(Duration(days: 1));

    // ***** PRAYERS CURRENT, NEXT, PREVIOUS
    PrayerTimes _currentPrayerTimes = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: current,
    );

    PrayerTimes _nextPrayerTimes = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: next,
    );

    PrayerTimes _previousPrayerTimes = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: previous,
    );

    // ***** PRAYERS TODAY, TOMORROW, YESTERDAY
    PrayerTimes prayersToday = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: today,
    );

    PrayerTimes prayersTomorrow = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: tomorrow,
    );

    PrayerTimes prayersYesterday = prayerTimetable(timetable,
        difference: difference,
        hijriOffset: hijriOffset,
        date: yesterday,
        timezone: timezone);

    // JAMAAH
    JamaahTimes _currentJamaahTimes =
        JamaahTimes(_currentPrayerTimes, jamaahMethods, jamaahOffsets);

    JamaahTimes _nextJamaahTimes =
        JamaahTimes(_nextPrayerTimes, jamaahMethods, jamaahOffsets);

    JamaahTimes _previousJamaahTimes =
        JamaahTimes(_previousPrayerTimes, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahToday =
        JamaahTimes(prayersToday, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahTomorrow =
        JamaahTimes(prayersTomorrow, jamaahMethods, jamaahOffsets);

    JamaahTimes jamaahYesterday =
        JamaahTimes(prayersYesterday, jamaahMethods, jamaahOffsets);

    /// Define prayer times
    this.currentPrayerTimes = _currentPrayerTimes;
    this.nextPrayerTimes = _nextPrayerTimes;
    this.previousPrayerTimes = _previousPrayerTimes;

    /// Define jamaah times
    this.currentJamaahTimes =
        JamaahTimes(_currentPrayerTimes, jamaahMethods, jamaahOffsets);
    this.nextJamaahTimes =
        JamaahTimes(_nextPrayerTimes, jamaahMethods, jamaahOffsets);
    this.previousJamaahTimes =
        JamaahTimes(_previousPrayerTimes, jamaahMethods, jamaahOffsets);

    /// Define sunnah
    this.sunnah = Sunnah(
        now, _currentPrayerTimes, _nextPrayerTimes, _previousPrayerTimes);

    this.calcToday = Calc(
      nowLocal,
      prayersToday,
      prayersTomorrow,
      prayersYesterday,
      jamaahOn,
      jamaahToday,
      jamaahTomorrow,
      jamaahYesterday,
      lat,
      lng,
      jamaahPerPrayer,
    );

    this.calc = Calc(
      date,
      _currentPrayerTimes,
      _nextPrayerTimes,
      _previousPrayerTimes,
      jamaahOn,
      _currentJamaahTimes,
      _nextJamaahTimes,
      _previousJamaahTimes,
      lat,
      lng,
      jamaahPerPrayer,
    );
    //end
  }
}
