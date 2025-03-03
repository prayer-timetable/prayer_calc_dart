// library prayer_timetable;

import 'dart:core';

// import 'package:adhan_dart/adhan_dart.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/func/monthGen.dart';
import 'package:prayer_timetable/src/func/monthHijriGen.dart';
import 'package:prayer_timetable/src/func/prayers.dart';
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
  ///method
  Map? timetableMap;
  List? timetableList;
  List? differences;
  TimetableCalc? timetableCalc;

  ///current prayers
  List<Prayer> current = List<Prayer>.filled(6, Prayer(), growable: false);

  ///next prayers
  List<Prayer> next = List<Prayer>.filled(6, Prayer(), growable: false);

  ///previous prayers
  List<Prayer> previous = List<Prayer>.filled(6, Prayer(), growable: false);

  ///prayers in focus
  List<Prayer> focus = List<Prayer>.filled(6, Prayer(), growable: false);

  ///calculations based on set DateTime
  Utils utils;

  /// Prayer times for the current month
  // List<List<Prayer>>? monthPrayerTimes;

  /// Prayer times for the current hijri month
  // List<List<Prayer>>? monthHijriPrayerTimes;

// PrayerTimetableMap map;

/***************************************************** */

  int? year;
  int? month;
  int? day;
  final int? hijriOffset;
  // bool summerTimeCalc = true,
  final String timezone;
  // true means we're using tz time
  bool? useTz;

  /// Enables jamaah times globaly.
  bool jamaahOn = false;

  /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
  List<bool>? jamaahPerPrayer;

  List<String>? jamaahMethods;
  List<List<int>>? jamaahOffsets;
  // for testing:
  bool? testing;
  int? hour;
  int? minute;
  int? second;
  bool? joinMaghrib;
  bool? joinDhuhr;

  int? prayerLength;

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
    this.differences,
    this.timetableCalc,
    this.year,
    this.month,
    this.day,
    this.hijriOffset,
    // this.summerTimeCalc = true,

    /// Enables jamaah times globaly.
    required this.jamaahOn,
    this.joinMaghrib = false,
    this.joinDhuhr = false,
    this.prayerLength = 10,
    required this.timezone,
    this.useTz = true,

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
        assert(timetableCalc != null ||
            (lat != null && lng != null) ||
            timetableList != null ||
            timetableMap != null), //  && jamaahPerPrayer != null
        this.testing = false,
        this.utils = defaultUtils {
    /// ********************************************
    /// Define time
    /// ********************************************
    DateTime date = nowTZ(timezone,
        year: year, month: month, day: day, hour: hour, minute: minute, second: second);

    // print('${this.year}, ${this.month}, ${this.day}');
    // print(DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) + 1,
    //     this.hour ?? 3, this.minute ?? 0, this.second ?? 0));
    bool _jamaahOn = this.jamaahOn;
    List<bool> _jamaahPerPrayer =
        !_jamaahOn ? defaultJamaahPerPrayerOff : this.jamaahPerPrayer ?? defaultJamaahPerPrayerOn;

    /// ********************************************
    /// Define prayer times
    /// ********************************************
    this.current = prayersGen(
      DateTime(this.year ?? date.year, this.month ?? date.month, this.day ?? date.day,
          this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
      timetableMap: timetableMap,
      timetableList: timetableList,
      differences: differences,
      timetableCalc: timetableCalc != null
          ? timetableCalc!.copyWith(
              date: DateTime(this.year ?? date.year, this.month ?? date.month,
                  (this.day ?? date.day), this.hour ?? 3, this.minute ?? 0, this.second ?? 0))
          : null,
      timezone: this.timezone,
      // useTz: this.useTz,
      hijriOffset: this.hijriOffset ?? 0,
      joinMaghrib: this.joinMaghrib ?? false,
      joinDhuhr: this.joinDhuhr ?? false,
      jamaahOn: this.jamaahOn,
      jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
      jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
      jamaahPerPrayer: _jamaahPerPrayer,
      prayerLength: this.prayerLength,
    );

    this.next = prayersGen(
      DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) + 1,
          this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
      timetableMap: timetableMap,
      timetableList: timetableList,
      differences: differences,
      timetableCalc: timetableCalc != null
          ? timetableCalc!.copyWith(
              date: DateTime(this.year ?? date.year, this.month ?? date.month,
                  (this.day ?? date.day) + 1, this.hour ?? 3, this.minute ?? 0, this.second ?? 0))
          : null,
      timezone: this.timezone,
      // useTz: this.useTz,
      hijriOffset: this.hijriOffset ?? 0,
      joinMaghrib: this.joinMaghrib ?? false,
      joinDhuhr: this.joinDhuhr ?? false,
      jamaahOn: this.jamaahOn,
      jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
      jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
      jamaahPerPrayer: _jamaahPerPrayer,
      prayerLength: this.prayerLength,
    );
    this.previous = prayersGen(
      DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) - 1,
          this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
      timetableMap: timetableMap,
      timetableList: timetableList,
      differences: differences,
      timetableCalc: timetableCalc != null
          ? timetableCalc!.copyWith(
              date: DateTime(this.year ?? date.year, this.month ?? date.month,
                  (this.day ?? date.day) - 1, this.hour ?? 3, this.minute ?? 0, this.second ?? 0))
          : null,
      timezone: this.timezone,
      // useTz: this.useTz,
      hijriOffset: this.hijriOffset ?? 0,
      joinMaghrib: this.joinMaghrib ?? false,
      joinDhuhr: this.joinDhuhr ?? false,
      jamaahOn: this.jamaahOn,
      jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
      jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
      jamaahPerPrayer: _jamaahPerPrayer,
      prayerLength: this.prayerLength,
    );

    /// ********************************************
    /// Utils
    /// ********************************************
    this.utils = Utils(
      date,
      prayersCurrent: this.current,
      prayersNext: this.next,
      prayersPrevious: this.previous,
      jamaahOn: this.jamaahOn,
      lat: this.lat ?? lat ?? 0,
      lng: this.lng ?? lng ?? 0,
      jamaahPerPrayer: this.jamaahPerPrayer,
    );

    this.utils.utcOffsetHours = offsetHr(date, timezone);

    /// ********************************************
    /// Prayers in focus
    /// ********************************************
    this.focus = this.utils.isAfterIsha ? this.next : this.current;
    // to avoid next day isha adding few minutes and becoming next again
    if (this.utils.isAfterIsha) {
      this.focus.last.isNext = false;
      this.focus.first.isNext = true;
    }

    // else {
    //   for (Prayer prayer in this.focus) {
    //     prayer.isNext = this.utils.nextId == prayer.id && !prayer.isJamaahPending;
    //     prayer.isCurrent = this.utils.currentId == prayer.id;
    //   }
    // }

    // this.next.first.is

    /// ********************************************
    /// Month calendars
    /// ********************************************
    // this.monthPrayerTimes = monthGen(date, hijriOffset: hijriOffset ?? 0, timezone: this.timezone);
    // this.monthHijriPrayerTimes =
    //     monthHijriGen(date, hijriOffset: hijriOffset ?? 0, timezone: this.timezone);

    /// end
  }

  /// end PrayerTimetable base
/***************************************************** */

  // static monthTable({
  //   required String timezone,
  //   required int year,
  //   required int month,
  //   int hijriOffset = 0,
  //   Map? timetableMap,
  //   List? timetableList,
  //   List? differences,
  //   TimetableCalc? timetableCalc,
  //   List<String> jamaahMethods,
  //   List<List<int>> jamaahOffsets,
  //   bool jamaahOn = false,
  //   List<bool> jamaahPerPrayer,
  //   bool joinDhuhr = false,
  //   bool joinMaghrib = false,
  // }) =>
  //     monthGen(
  //       nowTZ(timezone, year: year, month: month, day: 15),
  //       hijriOffset: hijriOffset,
  //       timezone: timezone,
  //       timetable: timetableMap,
  //       list: timetableList,
  //       differences: differences,
  //       calc: timetableCalc,
  //       jamaahMethods: jamaahMethods ?? defaultJamaahMethods,
  //       jamaahOffsets: jamaahOffsets ?? defaultJamaahOffsets,
  //       jamaahOn: jamaahOn,
  //       jamaahPerPrayer: jamaahPerPrayer ?? defaultJamaahPerPrayerOff,
  //       joinDhuhr: joinDhuhr ?? false,
  //       joinMaghrib: joinMaghrib ?? false,
  //     );

  // PrayerTimetable.month({
  //   this.year,
  //   this.month,
  //   this.hijriOffset,
  //   required this.timezone,
  //   this.useTz = true,
  // })  : //  && jamaahPerPrayer != null
  //       this.testing = false,
  //       utils = defaultUtils {
  //   /// ********************************************
  //   /// Define time
  //   /// ********************************************
  //   DateTime date = nowTZ(timezone, year: year, month: month, day: 15);

  //   /// ********************************************
  //   /// Month calendars
  //   /// ********************************************

  //   // this.monthPrayerTimes = monthGen(
  //   //   date,
  //   //   hijriOffset: hijriOffset ?? 0,
  //   //   timezone: this.timezone,
  //   //   timetable: timetableMap,
  //   //   list: timetableList,
  //   //   differences: differences,
  //   //   calc: timetableCalc,
  //   //   jamaahMethods: jamaahMethods ?? defaultJamaahMethods,
  //   //   jamaahOffsets: jamaahOffsets ?? defaultJamaahOffsets,
  //   //   jamaahOn: jamaahOn,
  //   //   jamaahPerPrayer: jamaahPerPrayer ?? defaultJamaahPerPrayerOff,
  //   //   joinDhuhr: joinDhuhr ?? false,
  //   //   joinMaghrib: joinMaghrib ?? false,
  //   // );
  //   // this.monthHijriPrayerTimes = monthHijriGen(
  //   //   date,
  //   //   hijriOffset: hijriOffset ?? 0,
  //   //   timezone: this.timezone,
  //   //   timetable: timetableMap,
  //   //   list: timetableList,
  //   //   differences: differences,
  //   //   calc: timetableCalc,
  //   //   jamaahMethods: jamaahMethods ?? defaultJamaahMethods,
  //   //   jamaahOffsets: jamaahOffsets ?? defaultJamaahOffsets,
  //   //   jamaahOn: jamaahOn,
  //   //   jamaahPerPrayer: jamaahPerPrayer ?? defaultJamaahPerPrayerOff,
  //   //   joinDhuhr: joinDhuhr ?? false,
  //   //   joinMaghrib: joinMaghrib ?? false,
  //   // );

  //   /// end
  // }

  /// ********************************************
  /// Month calendars
  /// ********************************************
  static const monthTable = monthGen;
  static const monthHijriTable = monthHijriGen;

  /// end PrayerTimetable month
/***************************************************** */

  PrayerTimetable.map({
    required Map timetableMap,
    int? year,
    int? month,
    int? day,
    int? hijriOffset,

    /// Enables jamaah times globaly.
    required bool jamaahOn,
    bool joinMaghrib = false,
    bool joinDhuhr = false,
    int prayerLength = 10,
    required String timezone,
    bool useTz = true,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    List<bool>? jamaahPerPrayer,
    List<String>? jamaahMethods,
    List<List<int>>? jamaahOffsets,
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
          prayerLength: prayerLength,
          timezone: timezone,
          useTz: useTz,
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
    List differences = const [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0]
    ],
    int? year,
    int? month,
    int? day,
    int? hijriOffset,

    /// Enables jamaah times globaly.
    bool jamaahOn = false,
    bool joinMaghrib = false,
    bool joinDhuhr = false,
    int prayerLength = 10,
    required String timezone,
    bool useTz = true,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    List<bool>? jamaahPerPrayer,
    List<String>? jamaahMethods,
    List<List<int>>? jamaahOffsets,
    int? hour,
    int? minute,
    int? second,
    double? lat,
    double? lng,
  }) : this.base(
          timetableList: timetableList,
          differences: differences,
          year: year,
          month: month,
          day: day,
          hijriOffset: hijriOffset,
          jamaahOn: jamaahOn,
          joinMaghrib: joinMaghrib,
          joinDhuhr: joinDhuhr,
          prayerLength: prayerLength,
          timezone: timezone,
          useTz: useTz,
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

  ///
  PrayerTimetable.calc({
    required TimetableCalc timetableCalc,
    int? year,
    int? month,
    int? day,
    int? hijriOffset,

    /// Enables jamaah times globaly.
    bool jamaahOn = false,
    bool joinMaghrib = false,
    bool joinDhuhr = false,
    int prayerLength = 10,
    required String timezone,
    bool useTz = true,

    /// Jammah times per individual prayers. Ignored if global jamaahOn is false.
    List<bool>? jamaahPerPrayer,
    List<String>? jamaahMethods,
    List<List<int>>? jamaahOffsets,
    int? hour,
    int? minute,
    int? second,
  }) : this.base(
          timetableCalc: timetableCalc,
          year: year,
          month: month,
          day: day,
          hijriOffset: hijriOffset,
          jamaahOn: jamaahOn,
          joinMaghrib: joinMaghrib,
          joinDhuhr: joinDhuhr,
          prayerLength: prayerLength,
          timezone: timezone,
          useTz: useTz,
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
