// library prayer_timetable;

import 'dart:core';

// import 'package:adhan_dart/adhan_dart.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/components/CalcPrayers.dart';
import 'package:prayer_timetable/src/func/jamaahTimes.dart';
import 'package:prayer_timetable/src/func/monthHijriGen.dart';
import 'package:prayer_timetable/src/func/monthGen.dart';
import 'package:prayer_timetable/src/func/prayerTimes.dart';
import 'package:prayer_timetable/src/func/tzTime.dart';

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

const List<bool> defaultJamaahPerPrayerOff = const [false, false, false, false, false, false];
const List<bool> defaultJamaahPerPrayerOn = const [true, true, true, true, true, true];

class PrayerTimetable<T> {
  Map? timetableMap;
  List? timetableList;
  CalcPrayers? calcPrayers;

  ///current prayer times
  PrayerTimes currentPrayerTimes = PrayerTimes.times;

  ///previous prayer times
  PrayerTimes previousPrayerTimes = PrayerTimes.times;

  ///next prayer times
  PrayerTimes nextPrayerTimes = PrayerTimes.times;

  ///current jamaah times
  JamaahTimes currentJamaahTimes = JamaahTimes.times;

  ///previous jamaah times
  JamaahTimes previousJamaahTimes = JamaahTimes.times;

  ///next jamaah times
  JamaahTimes nextJamaahTimes = JamaahTimes.times;

  ///sunnah times - midnight and last third
  Sunnah sunnah;

  ///calculations based on set DateTime
  Calc calc;

  /// Prayer times for the current month
  List<PrayerTimes>? monthPrayerTimes;

  /// Prayer times for the current hijri month
  List<PrayerTimes>? monthHijriPrayerTimes;

// PrayerTimetableMap map;

/***************************************************** */

  final int? year;
  final int? month;
  final int? day;
  final int? hijriOffset;
  // bool summerTimeCalc = true,
  final String timezone;

  /// Enables jamaah times globaly.
  bool jamaahOn = false;

  /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
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

  double? lat;
  double? lng;

/***************************************************** */

/***************************************************** */

/***************************************************** */
  // factory PrayerTimetable(String name) {
  //   return PrayerTimetable.base();
  // }

  // static final PrayerTimetable base2 = PrayerTimetable.base();

  PrayerTimetable.base({
    this.timetableMap,
    this.timetableList,
    this.calcPrayers,
    this.year,
    this.month,
    this.day,
    this.hijriOffset,
    // this.summerTimeCalc = true,

    /// Enables jamaah times globaly.
    this.jamaahOn = false,
    this.joinMaghrib = false,
    this.joinDhuhr = false,
    required this.timezone,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    this.jamaahPerPrayer,
    this.jamaahMethods = defaultJamaahMethods,
    this.jamaahOffsets = defaultJamaahOffsets,
    this.hour,
    this.minute,
    this.second,
    this.lat,
    this.lng,
  })  : assert((jamaahOn) && (jamaahMethods != null && jamaahOffsets != null) ||
            (jamaahOn && jamaahPerPrayer != null) ||
            jamaahOn == false),
        assert(calcPrayers != null ||
            (lat != null && lng != null) ||
            timetableList != null ||
            timetableMap != null), //  && jamaahPerPrayer != null
        this.testing = false,
        this.calc = defaultCalc,
        this.sunnah = defaultSunnah {
    /// ********************************************
    /// Define time
    /// ********************************************
    DateTime date = nowTZ(timezone,
        year: year, month: month, day: day, hour: hour, minute: minute, second: second);

    /// ********************************************
    /// Define prayer times
    /// ********************************************
    print('${this.year}, ${this.month}, ${this.day}');
    print(DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) + 1,
        this.hour ?? 3, this.minute ?? 0, this.second ?? 0));
    this.currentPrayerTimes = prayerTimesGen(
        DateTime(this.year ?? date.year, this.month ?? date.month, this.day ?? date.day,
            this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
        timetableMap: timetableMap,
        timetableList: timetableList,
        calcPrayers: calcPrayers,
        timezone: this.timezone);
    this.nextPrayerTimes = prayerTimesGen(
        DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) + 1,
            this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
        timetableMap: timetableMap,
        timetableList: timetableList,
        calcPrayers: calcPrayers,
        timezone: this.timezone);
    this.previousPrayerTimes = prayerTimesGen(
        DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) - 1,
            this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
        timetableMap: timetableMap,
        timetableList: timetableList,
        calcPrayers: calcPrayers,
        timezone: this.timezone);

    /// ********************************************
    /// Define jamaah times
    /// ********************************************
    bool _jamaahOn = this.jamaahOn;
    List<bool> _jamaahPerPrayer =
        _jamaahOn ? this.jamaahPerPrayer ?? defaultJamaahPerPrayerOn : defaultJamaahPerPrayerOff;

    this.currentJamaahTimes = jamaahTimes(
        prayers: currentPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
        jamaahPerPrayer: _jamaahPerPrayer);
    this.nextJamaahTimes = jamaahTimes(
        prayers: nextPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
        jamaahPerPrayer: _jamaahPerPrayer);
    this.previousJamaahTimes = jamaahTimes(
        prayers: previousPrayerTimes,
        jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
        jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
        jamaahPerPrayer: _jamaahPerPrayer);

    /// ********************************************
    /// Check if jammah is before the prayer
    /// ********************************************
    this.currentPrayerTimes = prayerTimesValidate(
        prayerTimes: this.currentPrayerTimes, jamaahTimes: this.currentJamaahTimes);
    this.nextPrayerTimes =
        prayerTimesValidate(prayerTimes: this.nextPrayerTimes, jamaahTimes: this.nextJamaahTimes);
    this.previousPrayerTimes = prayerTimesValidate(
        prayerTimes: this.previousPrayerTimes, jamaahTimes: this.previousJamaahTimes);

    /// ********************************************
    /// Joining prayers
    /// ********************************************
    List joinedTimesCurrent = prayerJoining(
      joinDhuhr: this.joinDhuhr,
      joinMaghrib: this.joinMaghrib,
      prayerTimes: this.currentPrayerTimes,
      jamaahTimes: this.currentJamaahTimes,
    );
    List joinedTimesNext = prayerJoining(
      joinDhuhr: this.joinDhuhr,
      joinMaghrib: this.joinMaghrib,
      prayerTimes: this.nextPrayerTimes,
      jamaahTimes: this.nextJamaahTimes,
    );
    List joinedTimesPrevious = prayerJoining(
      joinDhuhr: this.joinDhuhr,
      joinMaghrib: this.joinMaghrib,
      prayerTimes: this.previousPrayerTimes,
      jamaahTimes: this.previousJamaahTimes,
    );
    this.currentPrayerTimes = joinedTimesCurrent[0];
    this.nextPrayerTimes = joinedTimesNext[0];
    this.previousPrayerTimes = joinedTimesPrevious[0];
    this.currentJamaahTimes = joinedTimesCurrent[1];
    this.nextJamaahTimes = joinedTimesNext[1];
    this.previousJamaahTimes = joinedTimesPrevious[1];

    /// ********************************************
    /// Sunnah prayers
    /// ********************************************
    this.sunnah = Sunnah(date,
        prayersCurrent: this.currentPrayerTimes,
        prayersNext: this.nextPrayerTimes,
        prayersPrevious: this.previousPrayerTimes);

    /// ********************************************
    /// Calc
    /// ********************************************
    this.calc = Calc(
      date,
      prayersCurrent: this.currentPrayerTimes,
      prayersNext: this.nextPrayerTimes,
      prayersPrevious: this.previousPrayerTimes,
      jamaahOn: this.jamaahOn,
      jamaahCurrent: this.currentJamaahTimes,
      jamaahPrevious: this.previousJamaahTimes,
      lat: this.lat != null
          ? lat
          : calcPrayers != null
              ? calcPrayers!.coordinates!.latitude
              : 0,
      lng: this.lng != null
          ? lng
          : calcPrayers != null
              ? calcPrayers!.coordinates!.longitude
              : 0,
      jamaahPerPrayer: this.jamaahPerPrayer,
    );

    /// ********************************************
    /// Month calendars
    /// ********************************************
    this.monthPrayerTimes = monthGen(date, hijriOffset: hijriOffset ?? 0, timezone: this.timezone);
    this.monthHijriPrayerTimes =
        monthHijriGen(date, hijriOffset: hijriOffset ?? 0, timezone: this.timezone);

    /// end
  }

  /// end PrayerTimetable
/***************************************************** */

  PrayerTimetable.map({
    required Map timetableMap,
    int? year,
    int? month,
    int? day,
    int? hijriOffset,

    /// Enables jamaah times globaly.
    bool jamaahOn = false,
    bool joinMaghrib = false,
    bool joinDhuhr = false,
    required String timezone,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    List<bool> jamaahPerPrayer = defaultJamaahPerPrayerOff,
    List<String> jamaahMethods = defaultJamaahMethods,
    List<List<int>> jamaahOffsets = defaultJamaahOffsets,
    int? hour,
    int? minute,
    int? second,
    double? lat,
    double? lng,
  }) : this.base(
          timetableMap: timetableMap,
          year: year,
          month: month,
          day: day,
          hijriOffset: hijriOffset,
          jamaahOn: jamaahOn,
          joinMaghrib: joinMaghrib,
          joinDhuhr: joinDhuhr,
          timezone: timezone,
          jamaahPerPrayer: jamaahPerPrayer,
          jamaahMethods: jamaahMethods,
          jamaahOffsets: jamaahOffsets,
          hour: hour,
          minute: minute,
          second: second,
          lat: lat,
          lng: lng,
        );

  /// end PrayerTimetable.map

  PrayerTimetable.list({
    required List timetableList,
    int? year,
    int? month,
    int? day,
    int? hijriOffset,

    /// Enables jamaah times globaly.
    bool jamaahOn = false,
    bool joinMaghrib = false,
    bool joinDhuhr = false,
    required String timezone,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    List<bool> jamaahPerPrayer = defaultJamaahPerPrayerOff,
    List<String> jamaahMethods = defaultJamaahMethods,
    List<List<int>> jamaahOffsets = defaultJamaahOffsets,
    int? hour,
    int? minute,
    int? second,
    double? lat,
    double? lng,
  }) : this.base(
          timetableList: timetableList,
          year: year,
          month: month,
          day: day,
          hijriOffset: hijriOffset,
          jamaahOn: jamaahOn,
          joinMaghrib: joinMaghrib,
          joinDhuhr: joinDhuhr,
          timezone: timezone,
          jamaahPerPrayer: jamaahPerPrayer,
          jamaahMethods: jamaahMethods,
          jamaahOffsets: jamaahOffsets,
          hour: hour,
          minute: minute,
          second: second,
          lat: lat,
          lng: lng,
        );

  /// end PrayerTimetable.list

  PrayerTimetable.calc({
    required CalcPrayers calcPrayers,
    int? year,
    int? month,
    int? day,
    int? hijriOffset,

    /// Enables jamaah times globaly.
    bool jamaahOn = false,
    bool joinMaghrib = false,
    bool joinDhuhr = false,
    required String timezone,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    List<bool> jamaahPerPrayer = defaultJamaahPerPrayerOff,
    List<String> jamaahMethods = defaultJamaahMethods,
    List<List<int>> jamaahOffsets = defaultJamaahOffsets,
    int? hour,
    int? minute,
    int? second,
  }) : this.base(
          calcPrayers: calcPrayers,
          year: year,
          month: month,
          day: day,
          hijriOffset: hijriOffset,
          jamaahOn: jamaahOn,
          joinMaghrib: joinMaghrib,
          joinDhuhr: joinDhuhr,
          timezone: timezone,
          jamaahPerPrayer: jamaahPerPrayer,
          jamaahMethods: jamaahMethods,
          jamaahOffsets: jamaahOffsets,
          hour: hour,
          minute: minute,
          second: second,
        );

  /// end PrayerTimetable.list
}

// PrayerTimetable.map(Map timetable);
// }
