// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:prayer_timetable/src/components/Sunnah.dart';
import 'package:prayer_timetable/src/components/Prayers.dart';
import 'package:prayer_timetable/src/components/Calc.dart';
import 'package:prayer_timetable/src/components/Jamaah.dart';

import 'package:prayer_timetable/src/func/prayerTimetableMap.dart';

/// Uses predefined map for prayers
class PrayerTimetableMap {
  // PrayersStructure prayers;
  Prayers? current;
  Prayers? previous;
  Prayers? next;
  PrayerTimetableMap? prayers;
  PrayerTimetableMap? jamaah;

  /// Sunnah
  Sunnah? sunnah;

  /// Calculates based on set DateTime
  Calc? calc;

  /// Forces using now for DateTime
  Calc? calcToday;
  // Jamaah jamaahPrayer;

  PrayerTimetableMap(
    Map timetable, {
    String timezone = 'Europe/Dublin',
    int? year,
    int? month,
    int? day,
    int? hijriOffset,
    bool summerTimeCalc = true,
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
    // for testing:
    bool testing = false,
    int? hour,
    int? minute,
    int? second,
    double lat = 0,
    double lng = 0,
    bool joinMaghrib = false,
    bool joinDhuhr = false,
  }) {
    tz.setLocalLocation(tz.getLocation(timezone));

    DateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
    // DateTime now = tz.TZDateTime.from(DateTime.now(), tz.getLocation(timezone));

    DateTime date = tz.TZDateTime.from(
        DateTime(
          year ?? now.year,
          month ?? now.month,
          day ?? now.day,
          hour ?? now.hour,
          minute ?? now.minute,
          second ?? now.second,
        ),
        tz.getLocation(timezone));

    // ***** current, next and previous day
    DateTime current = date;
    DateTime next = current.add(Duration(days: 1));
    DateTime previous = current.subtract(Duration(days: 1));

    // ***** today, tomorrow and yesterday
    DateTime today = now;
    DateTime tomorrow = now.add(Duration(days: 1));
    DateTime yesterday = now.subtract(Duration(days: 1));

    // ***** PRAYERS CURRENT, NEXT, PREVIOUS
    Prayers prayersCurrent = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: current,
      timezone: timezone,
    );

    Prayers prayersNext = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: next,
      timezone: timezone,
    );

    Prayers prayersPrevious = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: previous,
      timezone: timezone,
    );

    // ***** PRAYERS TODAY, TOMORROW, YESTERDAY
    Prayers prayersToday = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: today,
      timezone: timezone,
    );

    Prayers prayersTomorrow = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: tomorrow,
      timezone: timezone,
    );

    Prayers prayersYesterday = prayerTimetable(
      timetable,
      hijriOffset: hijriOffset ?? 0,
      date: yesterday,
      timezone: timezone,
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

    print(joinDhuhr);
    print(joinMaghrib);
    // JOINING
    if (joinMaghrib) {
      prayersToday.dusk = prayersToday.sunset;
      prayersYesterday.dusk = prayersYesterday.sunset;
      prayersTomorrow.dusk = prayersTomorrow.sunset;
      prayersCurrent.dusk = prayersCurrent.sunset;
      prayersPrevious.dusk = prayersPrevious.sunset;
      prayersNext.dusk = prayersNext.sunset;

      jamaahToday.dusk = jamaahToday.sunset;
      jamaahYesterday.dusk = jamaahYesterday.sunset;
      jamaahTomorrow.dusk = jamaahTomorrow.sunset;
      jamaahCurrent.dusk = jamaahCurrent.sunset;
      jamaahPrevious.dusk = jamaahPrevious.sunset;
      jamaahNext.dusk = jamaahNext.sunset;
    }
    if (joinDhuhr) {
      prayersToday.afternoon = prayersToday.midday;
      prayersYesterday.afternoon = prayersYesterday.midday;
      prayersTomorrow.afternoon = prayersTomorrow.midday;
      prayersCurrent.afternoon = prayersCurrent.midday;
      prayersPrevious.afternoon = prayersPrevious.midday;
      prayersNext.afternoon = prayersNext.midday;

      jamaahToday.afternoon = jamaahToday.midday;
      jamaahYesterday.afternoon = jamaahYesterday.midday;
      jamaahTomorrow.afternoon = jamaahTomorrow.midday;
      jamaahCurrent.afternoon = jamaahCurrent.midday;
      jamaahPrevious.afternoon = jamaahPrevious.midday;
      jamaahNext.afternoon = jamaahNext.midday;
    }

    // define components
    this.prayers = PrayerTimetableMap.prayers(
        prayersCurrent, prayersNext, prayersPrevious);

    this.jamaah =
        PrayerTimetableMap.jamaah(jamaahCurrent, jamaahNext, jamaahPrevious);

    this.sunnah = Sunnah(now, prayersCurrent, prayersNext, prayersPrevious);

    /// Today only.
    this.calcToday = Calc(
      /// TNow
      now,
      prayersToday,
      prayersTomorrow,
      prayersYesterday,
      jamaahOn,
      jamaahToday,
      jamaahTomorrow,
      jamaahYesterday,
      lat,
      lng,
    );

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
    //
  }

  PrayerTimetableMap.prayers(
      Prayers prayersCurrent, Prayers prayersNext, Prayers prayersPrevious) {
    current = prayersCurrent;
    next = prayersNext;
    previous = prayersPrevious;
  }
  PrayerTimetableMap.jamaah(
      Jamaah jamaahCurrent, Jamaah jamaahNext, Jamaah jamaahPrevious) {
    current = jamaahCurrent;
    next = jamaahNext;
    previous = jamaahPrevious;
  }
}
