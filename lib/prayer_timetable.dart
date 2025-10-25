/// A comprehensive Dart library for Islamic prayer time calculations and management.
///
/// This library provides accurate prayer time calculations using multiple methods:
/// - Map-based timetables for pre-calculated prayer times
/// - List-based timetables with monthly differences
/// - Real-time calculations using astronomical algorithms via the adhan_dart package
///
/// Features:
/// - Support for all five daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha) plus Sunrise
/// - Jamaah (congregation) time management with customizable offsets
/// - Timezone support with automatic DST handling
/// - Hijri calendar integration
/// - Qibla direction calculation
/// - Prayer time utilities and countdown functionality
/// - Monthly prayer time generation for both Gregorian and Hijri calendars
///
/// Example usage:
/// ```dart
/// // Using astronomical calculations
/// final timetable = PrayerTimetable.calc(
///   timetableCalc: TimetableCalc(
///     date: DateTime.now(),
///     timezone: 'America/New_York',
///     lat: 40.7128,
///     lng: -74.0060,
///     precision: true,
///     fajrAngle: 15.0,
///   ),
///   jamaahOn: true,
///   timezone: 'America/New_York',
/// );
///
/// // Access prayer times
/// print('Fajr: ${timetable.current[0].prayerTime}');
/// print('Next prayer in: ${timetable.utils.countDown}');
/// ```
library prayer_timetable;

export 'src/PrayerTimetable.dart';
export 'src/components/Prayer.dart';
export 'src/components/Utils.dart';
export 'src/components/TimetableCalc.dart';
