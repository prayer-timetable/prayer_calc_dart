import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/Prayers.dart';
import 'package:prayer_timetable/src/components/Calc.dart';
import 'package:prayer_timetable/src/func/prayerTimetableList.dart';
import 'package:prayer_timetable/src/components/Jamaah.dart';

class PrayerTimetableList {
  // PrayersStructure prayers;
  Prayers? current;
  Prayers? previous;
  Prayers? next;
  PrayerTimetableList? prayers;
  PrayerTimetableList? jamaah;
  Sunnah? sunnah;
  Calc? calc;
  Calc? calcToday;

  PrayerTimetableList(
    List timetable, {
    List<int> difference = const [0, 0, 0, 0, 0, 0],
    int? year,
    int? month,
    int? day,
    int hijriOffset = 0,
    bool summerTimeCalc: true,
    bool jamaahOn = false,
    List<String> jamaahMethods = const [
      'afterthis',
      '',
      'afterthis',
      'afterthis',
      'afterthis',
      'afterthis'
    ],
    List<List<int>> jamaahOffsets = const [
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
    DateTime timestamp = DateTime.now();
    // DateTime beginingOfYear = DateTime(timestamp.year); // Jan 1, 0:00

    // Local date
    DateTime date = DateTime(year ?? timestamp.year, month ?? timestamp.month,
        day ?? timestamp.day, 0, 0);

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
    Prayers prayersCurrent = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: current,
    );

    Prayers prayersNext = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: next,
    );

    Prayers prayersPrevious = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: previous,
    );

    // ***** PRAYERS TODAY, TOMORROW, YESTERDAY
    Prayers prayersToday = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: today,
    );

    Prayers prayersTomorrow = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: tomorrow,
    );

    Prayers prayersYesterday = prayerTimetable(
      timetable,
      difference: difference,
      hijriOffset: hijriOffset,
      date: yesterday,
    );

    // JAMAAH
    Jamaah jamaahCurrent = Jamaah(prayersCurrent, jamaahMethods, jamaahOffsets);

    Jamaah jamaahNext = Jamaah(prayersNext, jamaahMethods, jamaahOffsets);

    Jamaah jamaahPrevious =
        Jamaah(prayersPrevious, jamaahMethods, jamaahOffsets);

    Jamaah jamaahToday = Jamaah(prayersToday, jamaahMethods, jamaahOffsets);

    Jamaah jamaahTomorrow =
        Jamaah(prayersTomorrow, jamaahMethods, jamaahOffsets);

    Jamaah jamaahYesterday =
        Jamaah(prayersYesterday, jamaahMethods, jamaahOffsets);

    // define components
    this.prayers = PrayerTimetableList.prayers(
        prayersCurrent, prayersNext, prayersPrevious);

    this.jamaah =
        PrayerTimetableList.jamaah(jamaahCurrent, jamaahNext, jamaahPrevious);

    this.sunnah =
        Sunnah(nowLocal, prayersCurrent, prayersNext, prayersPrevious);

    // this.calcToday = Calc(
    //   nowLocal,
    //   prayersToday,
    //   prayersTomorrow,
    //   prayersYesterday,
    //   jamaahOn,
    //   jamaahToday,
    //   jamaahTomorrow,
    //   jamaahYesterday,
    //   lat,
    //   lng,
    // );

    // this.calc = Calc(
    //   date,
    //   prayersCurrent,
    //   prayersNext,
    //   prayersPrevious,
    //   jamaahOn,
    //   jamaahCurrent,
    //   jamaahNext,
    //   jamaahPrevious,
    //   lat,
    //   lng,
    // );
    //end
  }

  PrayerTimetableList.prayers(
      Prayers prayersCurrent, Prayers prayersNext, Prayers prayersPrevious) {
    current = prayersCurrent;
    next = prayersNext;
    previous = prayersPrevious;
  }
  PrayerTimetableList.jamaah(
      Jamaah jamaahCurrent, Jamaah jamaahNext, Jamaah jamaahPrevious) {
    current = jamaahCurrent;
    next = jamaahNext;
    previous = jamaahPrevious;
  }
}
