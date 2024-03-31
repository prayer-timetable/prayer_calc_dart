// library prayer_timetable;

import 'dart:core';

// import 'package:adhan_dart/adhan_dart.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/jamaahTimes.dart';
import 'package:prayer_timetable/src/func/prayerTimes.dart';
import 'package:prayer_timetable/src/func/prayerTimesMap.dart';

// typedef Future<List<T>> PrayerTimetableOnFind<T>(String text);
// typedef String PrayerTimetableItemAsString<T>(T item);
// typedef bool PrayerTimetableFilterFn<T>(T item, String filter);
// typedef bool PrayerTimetableCompareFn<T>(T item1, T item2);

// typedef Future<bool?> BeforeChange<T>(T? prevItem, T? nextItem);
// typedef Future<bool?> BeforePopupOpening<T>(T? selectedItem);
// typedef Future<bool?> BeforePopupOpeningMultiSelection<T>(List<T> selItems);
// typedef Future<bool?> BeforeChangeMultiSelection<T>(
//   List<T> prevItems,
//   List<T> nextItems,
// );

// typedef void OnItemAdded<T>(List<T> selectedItems, T addedItem);
// typedef void OnItemRemoved<T>(List<T> selectedItems, T removedItem);

// ///[items] are the original item from [items] or/and [asyncItems]
// typedef List<T> FavoriteItems<T>(List<T> items);

// enum Mode { DIALOG, MODAL_BOTTOM_SHEET, MENU, BOTTOM_SHEET }
const List<List<int>> defaultJamaahOffsets = const [
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0]
];
const List<String> defaultJamaahMethods = const [
  'afterthis',
  '',
  'afterthis',
  'afterthis',
  'afterthis',
  'afterthis'
];

const List<bool> defaultJamaahPerPrayer = const [false, false, false, false, false, false];

class PrayerTimetable<T> {
  ///current prayer times
  PrayerTimes currentPrayerTimes = PrayerTimes.times;

  ///previous prayer times
  PrayerTimes previousPrayerTimes = PrayerTimes.times;

  ///next prayer times
  PrayerTimes nextPrayerTimes = PrayerTimes.times;

  ///current jamaah times
  PrayerTimes currentJamaahTimes = PrayerTimes.times;

  ///previous jamaah times
  PrayerTimes previousJamaahTimes = PrayerTimes.times;

  ///next jamaah times
  PrayerTimes nextJamaahTimes = PrayerTimes.times;

  ///sunnah times - midnight and last third
  // final Sunnah sunnah;

  ///calculations based on set DateTime
  // final Calc calc;

  /// Prayer times for the current month
  // final List<PrayerTimes> monthPrayerTimes;

  /// Prayer times for the current hijri month
  // final List<PrayerTimes> monthHijriPrayerTimes;

// PrayerTimetableMap map;

/***************************************************** */

  final int? year;
  final int? month;
  final int? day;
  final int? hijriOffset;
  // bool summerTimeCalc = true,

  // /// Enables jamaah times globaly.
  final bool? jamaahOn;

  // /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
  final List<bool>? jamaahPerPrayer;

  final List<String>? jamaahMethods;
  final List<List<int>>? jamaahOffsets;
  // for testing:
  bool? testing;
  final int? hour;
  final int? minute;
  final int? second;
  final bool? joinMaghrib;
  final bool? joinDhuhr;

  /***************************************************** */

  PrayerTimetable({
    this.year,
    this.month,
    this.day,
    this.hijriOffset,
    // this.summerTimeCalc = true,

    /// Enables jamaah times globaly.
    this.jamaahOn = false,
    this.joinMaghrib = false,
    this.joinDhuhr = false,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    this.jamaahPerPrayer = defaultJamaahPerPrayer,
    this.jamaahMethods = defaultJamaahMethods,
    this.jamaahOffsets = defaultJamaahOffsets,
    this.hour,
    this.minute,
    this.second,
  })  : assert(
          (jamaahOn != null && !jamaahOn) ||
              (jamaahMethods != null && jamaahPerPrayer != null && jamaahOffsets != null),
        ),
        this.testing = false {
    DateTime now = DateTime.now();

    /// Define prayer times
    this.currentPrayerTimes = prayerTimes(
        date: DateTime(this.year ?? now.year, this.month ?? now.month, this.day ?? now.day,
            this.hour ?? 3, this.minute ?? 0, this.second ?? 0));
    this.nextPrayerTimes = prayerTimes(
      date: DateTime(this.year ?? now.year, this.month ?? now.month, (this.day ?? now.day) + 1,
          this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
    );
    this.previousPrayerTimes = prayerTimes(
        date: DateTime(this.year ?? now.year, this.month ?? now.month, (this.day ?? now.day) - 1,
            this.hour ?? 3, this.minute ?? 0, this.second ?? 0));

    /// Define jamaah times
    this.currentJamaahTimes = jamaahTimes(
        prayers: currentPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets);
    this.nextJamaahTimes = jamaahTimes(
        prayers: nextPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets);
    this.previousJamaahTimes = jamaahTimes(
        prayers: previousPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets);
  }

  // this.calc = Calc(
  //   DateTime(year ?? DateTime.now().year, month ?? DateTime.now().month,
  //       day ?? DateTime.now().day, hour ?? 3),
  //   PrayerTimes.times,
  //   PrayerTimes.times,
  //   PrayerTimes.times,
  //   jamaahOn,
  //   PrayerTimes.times,
  //   PrayerTimes.times,
  //   PrayerTimes.times,
  //   [0, 0],
  //   jamaahPerPrayer,
  // );

/***************************************************** */

/***************************************************** */

/***************************************************** */

/***************************************************** */

  PrayerTimetable.map(
    Map timetable, {
    this.year,
    this.month,
    this.day,
    this.hijriOffset,
    // this.summerTimeCalc = true,

    /// Enables jamaah times globaly.
    this.jamaahOn = false,
    this.joinMaghrib = false,
    this.joinDhuhr = false,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    this.jamaahPerPrayer = const [false, false, false, false, false, false],
    this.jamaahMethods = defaultJamaahMethods,
    this.jamaahOffsets = defaultJamaahOffsets,
    this.hour,
    this.minute,
    this.second,
  })  : assert((jamaahOn != null && jamaahOn) &&
            (jamaahMethods != null && jamaahOffsets != null)), //  && jamaahPerPrayer != null
        this.testing = false {
    DateTime now = DateTime.now();

    /// Define prayer times
    this.currentPrayerTimes = prayerTimesMap(timetable,
        date: DateTime(this.year ?? now.year, this.month ?? now.month, this.day ?? now.day,
            this.hour ?? 3, this.minute ?? 0, this.second ?? 0));
    this.nextPrayerTimes = prayerTimesMap(
      timetable,
      date: DateTime(this.year ?? now.year, this.month ?? now.month, (this.day ?? now.day) + 1,
          this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
    );
    this.previousPrayerTimes = prayerTimesMap(timetable,
        date: DateTime(this.year ?? now.year, this.month ?? now.month, (this.day ?? now.day) - 1,
            this.hour ?? 3, this.minute ?? 0, this.second ?? 0));

    /// Define jamaah times
    this.currentJamaahTimes = jamaahTimes(
        prayers: currentPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets);
    this.nextJamaahTimes = jamaahTimes(
        prayers: nextPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets);
    this.previousJamaahTimes = jamaahTimes(
        prayers: previousPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets);
  }
}

  // PrayerTimetable.map(Map timetable);
// }
