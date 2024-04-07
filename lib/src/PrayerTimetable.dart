// library prayer_timetable;

import 'dart:core';

// import 'package:adhan_dart/adhan_dart.dart';
import 'package:prayer_timetable/prayer_timetable.dart';
import 'package:prayer_timetable/src/components/TimetableCalc.dart';
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
  List<List<Prayer>>? monthPrayerTimes;

  /// Prayer times for the current hijri month
  List<List<Prayer>>? monthHijriPrayerTimes;

// PrayerTimetableMap map;

/***************************************************** */

  int? year;
  int? month;
  int? day;
  final int? hijriOffset;
  // bool summerTimeCalc = true,
  final String timezone;

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
    this.timetableCalc,
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

    /// ********************************************
    /// Define prayer times
    /// ********************************************
    // print('${this.year}, ${this.month}, ${this.day}');
    // print(DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) + 1,
    //     this.hour ?? 3, this.minute ?? 0, this.second ?? 0));
    bool _jamaahOn = this.jamaahOn;
    List<bool> _jamaahPerPrayer =
        !_jamaahOn ? defaultJamaahPerPrayerOff : this.jamaahPerPrayer ?? defaultJamaahPerPrayerOn;

    this.current = prayersGen(
      DateTime(this.year ?? date.year, this.month ?? date.month, this.day ?? date.day,
          this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
      timetableMap: timetableMap,
      timetableList: timetableList,
      timetableCalc: timetableCalc,
      timezone: this.timezone,
      hijriOffset: this.hijriOffset ?? 0,
      joinMaghrib: this.joinMaghrib ?? false,
      joinDhuhr: this.joinDhuhr ?? false,
      jamaahOn: this.jamaahOn,
      jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
      jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
      jamaahPerPrayer: _jamaahPerPrayer,
    );
    this.next = prayersGen(
      DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) + 1,
          this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
      timetableMap: timetableMap,
      timetableList: timetableList,
      timetableCalc: timetableCalc,
      timezone: this.timezone,
      hijriOffset: this.hijriOffset ?? 0,
      joinMaghrib: this.joinMaghrib ?? false,
      joinDhuhr: this.joinDhuhr ?? false,
      jamaahOn: this.jamaahOn,
      jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
      jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
      jamaahPerPrayer: _jamaahPerPrayer,
    );
    this.previous = prayersGen(
      DateTime(this.year ?? date.year, this.month ?? date.month, (this.day ?? date.day) - 1,
          this.hour ?? 3, this.minute ?? 0, this.second ?? 0),
      timetableMap: timetableMap,
      timetableList: timetableList,
      timetableCalc: timetableCalc,
      timezone: this.timezone,
      hijriOffset: this.hijriOffset ?? 0,
      joinMaghrib: this.joinMaghrib ?? false,
      joinDhuhr: this.joinDhuhr ?? false,
      jamaahOn: this.jamaahOn,
      jamaahMethods: this.jamaahMethods ?? defaultJamaahMethods,
      jamaahOffsets: this.jamaahOffsets ?? defaultJamaahOffsets,
      jamaahPerPrayer: _jamaahPerPrayer,
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
      lat: this.lat != null
          ? lat
          : timetableCalc != null
              ? timetableCalc!.coordinates!.latitude
              : 0,
      lng: this.lng != null
          ? lng
          : timetableCalc != null
              ? timetableCalc!.coordinates!.longitude
              : 0,
      jamaahPerPrayer: this.jamaahPerPrayer,
    );

    /// ********************************************
    /// Prayers in focus
    /// ********************************************
    this.focus = this.utils.isAfterIsha ? this.next : this.current;

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

  PrayerTimetable.month({
    this.year,
    this.month,
    this.day,
    this.hijriOffset,
    required this.timezone,
  })  : //  && jamaahPerPrayer != null
        this.testing = false,
        utils = defaultUtils {
    /// ********************************************
    /// Define time
    /// ********************************************
    DateTime date = nowTZ(timezone,
        year: year, month: month, day: day, hour: hour, minute: minute, second: second);

    /// ********************************************
    /// Month calendars
    /// ********************************************
    // this.monthPrayerTimes = monthGen(date, hijriOffset: hijriOffset ?? 0, timezone: this.timezone);
    // this.monthHijriPrayerTimes =
    //     monthHijriGen(date, hijriOffset: hijriOffset ?? 0, timezone: this.timezone);

    /// end
  }

  /// end PrayerTimetable month
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
    required TimetableCalc timetableCalc,
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
