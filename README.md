# Prayer Timetable Dart

[![pub package](https://img.shields.io/pub/v/prayer_timetable.svg)](https://pub.dev/packages/prayer_timetable)
[![GitHub](https://img.shields.io/github/license/prayer-timetable/prayer_timetable_dart)](https://github.com/prayer-timetable/prayer_timetable_dart)

A comprehensive Dart library for Islamic prayer time calculations and management, providing accurate prayer times using multiple calculation methods with full timezone support and jamaah (congregation) time management.

**📦 [View on pub.dev](https://pub.dev/packages/prayer_timetable) | 🔗 [GitHub Repository](https://github.com/prayer-timetable/prayer_timetable_dart)**

## Features

-   **Multiple Calculation Methods**:
    -   Astronomical calculations using the [adhan_dart](https://pub.dev/packages/adhan_dart) library
    -   Pre-calculated map-based timetables
    -   List-based timetables with monthly differences
-   **Comprehensive Prayer Management**: All five daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha) plus Sunrise
-   **Jamaah Time Support**: Customizable congregation times with various calculation methods
-   **Timezone Handling**: Full timezone support with automatic DST adjustments
-   **Prayer Analysis**: Current prayer detection, countdown timers, and completion percentages
-   **Islamic Calendar**: Hijri date integration and calendar utilities
-   **Qibla Direction**: Accurate Qibla bearing calculations
-   **Monthly Generation**: Complete monthly prayer timetables for both Gregorian and Hijri calendars
-   **Sunnah Times**: Islamic midnight and last third of night calculations

> All astronomical calculations are high precision equations directly from the book [“Astronomical Algorithms”](http://www.willbell.com/math/mc1.htm) by Jean Meeus. This book is recommended by the Astronomical Applications Department of the U.S. Naval Observatory and the Earth System Research Laboratory of the National Oceanic and Atmospheric Administration.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
    prayer_timetable: ^2.2.0
```

Or install it from the command line:

```bash
dart pub add prayer_timetable
```

**📦 [View on pub.dev](https://pub.dev/packages/prayer_timetable)** for the latest version and detailed package information.

## Quick Start

```dart
import 'package:prayer_timetable/prayer_timetable.dart';

// Using astronomical calculations
final timetable = PrayerTimetable.calc(
  timetableCalc: TimetableCalc(
    date: DateTime.now(),
    timezone: 'America/New_York',
    lat: 40.7128,
    lng: -74.0060,
    precision: true,
    fajrAngle: 15.0,
  ),
  jamaahOn: true,
  timezone: 'America/New_York',
);

// Access prayer times
print('Fajr: ${timetable.current[0].prayerTime}');
print('Dhuhr: ${timetable.current[2].prayerTime}');
print('Next prayer in: ${timetable.utils.countDown}');
print('Qibla direction: ${timetable.utils.qibla}°');
```

## Core Classes

### PrayerTimetable

The main class providing comprehensive prayer time management with multiple constructors for different calculation methods:

#### PrayerTimetable.calc()

Uses astronomical calculations via the adhan_dart library:

```dart
final timetable = PrayerTimetable.calc(
  timetableCalc: TimetableCalc(
    date: DateTime.now(),
    timezone: 'America/New_York',
    lat: 40.7128,
    lng: -74.0060,
    precision: true,
    fajrAngle: 15.0,
    highLatitudeRule: 'twilightAngle',
    madhab: 'shafi',
  ),
  jamaahOn: true,
  timezone: 'America/New_York',
);
```

#### PrayerTimetable.map()

Uses pre-calculated prayer times from a map structure:

```dart
final timetable = PrayerTimetable.map(
  timetableMap: yourPrayerTimeMap,
  jamaahOn: true,
  timezone: 'America/New_York',
);
```

#### PrayerTimetable.list()

Uses list-based prayer times with monthly differences:

```dart
final timetable = PrayerTimetable.list(
  timetableList: yourPrayerTimeList,
  differences: monthlyDifferences,
  jamaahOn: true,
  timezone: 'America/New_York',
);
```

### Key Properties

-   **`current`**: List of 6 Prayer objects for the current day
-   **`next`**: List of 6 Prayer objects for the next day
-   **`previous`**: List of 6 Prayer objects for the previous day
-   **`focus`**: The prayers currently in focus (current or next day if after Isha)
-   **`utils`**: Utils object with prayer analysis and additional calculations

### Prayer

Represents a single Islamic prayer with timing information and status:

```dart
Prayer fajr = timetable.current[0];
print('Prayer: ${fajr.name}');
print('Time: ${fajr.prayerTime}');
print('Jamaah: ${fajr.jamaahTime}');
print('Is Current: ${fajr.isCurrent}');
print('Is Next: ${fajr.isNext}');
```

**Prayer IDs:**

-   0: Fajr (Dawn prayer)
-   1: Sunrise (Shurooq - end of Fajr time)
-   2: Dhuhr (Noon prayer)
-   3: Asr (Afternoon prayer)
-   4: Maghrib (Sunset prayer)
-   5: Isha (Night prayer)

**Key Properties:**

-   **`prayerTime`**: The actual prayer start time
-   **`jamaahTime`**: Congregation prayer time
-   **`endTime`**: When the prayer period ends
-   **`isCurrent`**: Whether this prayer is currently active
-   **`isNext`**: Whether this is the next upcoming prayer
-   **`isJamaahPending`**: Whether jamaah time is pending

### Utils

Provides prayer time analysis and additional Islamic calculations:

```dart
Utils utils = timetable.utils;
print('Current prayer ID: ${utils.currentId}');
print('Next prayer ID: ${utils.nextId}');
print('Time until next prayer: ${utils.countDown}');
print('Prayer completion: ${utils.percentage}%');
print('Qibla direction: ${utils.qibla}°');
print('Hijri date: ${utils.hijri}'); // [year, month, day]
```

**Key Properties:**

-   **`countDown`**: Duration until the next prayer
-   **`countUp`**: Duration since the current prayer began
-   **`percentage`**: Percentage of current prayer period completed (0-100)
-   **`currentId`**: ID of the currently active prayer (0-5)
-   **`nextId`**: ID of the next prayer (0-5)
-   **`isAfterIsha`**: Whether current time is after Isha prayer
-   **`qibla`**: Qibla direction in degrees from North
-   **`hijri`**: Hijri date as [year, month, day]
-   **`midnight`**: Islamic midnight (halfway between sunset and dawn)
-   **`lastThird`**: Last third of night (recommended for Tahajjud prayer)

**Hijri Calendar Conversion Methods:**

The Utils class provides comprehensive static methods for Hijri calendar conversions:

```dart
// Convert specific Hijri date to Gregorian
DateTime gregorianDate = Utils.hijriToGregorian(1446, 9, 26);
print(gregorianDate); // 2025-03-26

// Convert Gregorian date to Hijri
var hijriDate = Utils.gregorianToHijri(DateTime(2025, 3, 26));
print('${hijriDate.hYear}-${hijriDate.hMonth}-${hijriDate.hDay}'); // 1446-9-26

// Month-level functions
DateTime monthStart = Utils.getHijriMonthStart(1446, 9); // First day of Ramadan 1446
DateTime monthEnd = Utils.getHijriMonthEnd(1446, 9);     // Last day of Ramadan 1446
int monthLength = Utils.getHijriMonthLength(1446, 9);    // Number of days in Ramadan

// Year-level functions
DateTime yearStart = Utils.getHijriYearStart(1446);      // 1st Muharram 1446
DateTime yearEnd = Utils.getHijriYearEnd(1446);          // Last day of Dhul Hijjah 1446

// Formatting and names
String formatted = Utils.formatHijriDate(1446, 9, 26);   // "1446-09-26"
String monthName = Utils.getHijriMonthNameEnglish(9);    // "Ramadan"
String arabicName = Utils.getHijriMonthNameArabic(9);    // "رمضان"
```

**Available Hijri Conversion Methods:**

-   **`hijriToGregorian(year, month, day)`**: Convert Hijri date to Gregorian
-   **`gregorianToHijri(DateTime)`**: Convert Gregorian date to Hijri
-   **`getHijriMonthStart(year, month)`**: Get first day of Hijri month
-   **`getHijriMonthEnd(year, month)`**: Get last day of Hijri month
-   **`getHijriMonthLength(year, month)`**: Get number of days in Hijri month
-   **`getHijriYearStart(year)`**: Get first day of Hijri year (1st Muharram)
-   **`getHijriYearEnd(year)`**: Get last day of Hijri year (last day of Dhul Hijjah)
-   **`formatHijriDate(year, month, day)`**: Format Hijri date as "YYYY-MM-DD"
-   **`getHijriMonthNameEnglish(month)`**: Get English month name
-   **`getHijriMonthNameArabic(month)`**: Get Arabic month name

### TimetableCalc

Calculator for astronomical prayer time calculations:

```dart
final calc = TimetableCalc(
  date: DateTime.now(),
  timezone: 'America/New_York',
  lat: 40.7128,
  lng: -74.0060,
  precision: true,
  fajrAngle: 15.0,
  ishaAngle: 15.0,
  highLatitudeRule: 'twilightAngle', // 'middleOfTheNight', 'seventhOfTheNight'
  madhab: 'shafi', // 'hanafi'
);
```

## Advanced Features

### Jamaah (Congregation) Times

Configure jamaah times with various methods:

```dart
final timetable = PrayerTimetable.calc(
  timetableCalc: calc,
  jamaahOn: true,
  jamaahMethods: ['fixed', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
  jamaahOffsets: [
    [6, 0],    // Fajr at 6:00 AM fixed time
    [0, 0],    // Sunrise (no jamaah)
    [0, 15],   // Dhuhr + 15 minutes
    [0, 15],   // Asr + 15 minutes
    [0, 5],    // Maghrib + 5 minutes
    [0, 20]    // Isha + 20 minutes
  ],
  jamaahPerPrayer: [true, false, true, true, true, true],
  timezone: 'America/New_York',
);
```

### Monthly Prayer Timetables

Generate complete monthly timetables:

```dart
// Gregorian month
List<List<Prayer>> monthlyPrayers = PrayerTimetable.monthTable(
  2024, 3, // March 2024
  calc: timetableCalc,
  timezone: 'America/New_York',
  jamaahOn: true,
);

// Hijri month
List<List<Prayer>> hijriMonthlyPrayers = PrayerTimetable.monthHijriTable(
  2024, 3,
  calc: timetableCalc,
  timezone: 'America/New_York',
  jamaahOn: true,
);
```

### High Latitude Rules

For locations with extreme latitudes:

-   **`twilightAngle`**: Use twilight angle throughout the year
-   **`middleOfTheNight`**: Middle of the night method
-   **`seventhOfTheNight`**: Seventh of the night method

## Alternative Installation

### From pub.dev (Recommended)

```yaml
dependencies:
    prayer_timetable: ^2.2.0
```

### From GitHub (Development Version)

```yaml
dependencies:
    prayer_timetable:
        git:
            url: https://github.com/prayer-timetable/prayer_timetable_dart.git
```

Then run:

```bash
dart pub get
```

## Complete Example

```dart
import 'package:prayer_timetable/prayer_timetable.dart';

void main() {
  // Initialize timezone data
  tz.initializeTimeZones();

  // Create timetable with astronomical calculations
  final timetable = PrayerTimetable.calc(
    timetableCalc: TimetableCalc(
      date: DateTime.now(),
      timezone: 'America/New_York',
      lat: 40.7128,
      lng: -74.0060,
      precision: true,
      fajrAngle: 15.0,
      highLatitudeRule: 'twilightAngle',
      madhab: 'shafi',
    ),
    jamaahOn: true,
    jamaahMethods: ['afterthis', '', 'afterthis', 'afterthis', 'afterthis', 'afterthis'],
    jamaahOffsets: [[0, 15], [0, 0], [0, 10], [0, 10], [0, 5], [0, 15]],
    timezone: 'America/New_York',
  );

  // Access prayer times
  print('=== Today\'s Prayer Times ===');
  for (int i = 0; i < 6; i++) {
    Prayer prayer = timetable.current[i];
    print('${prayer.name}: ${prayer.prayerTime}');
    if (prayer.jamaahTime != prayer.prayerTime) {
      print('  Jamaah: ${prayer.jamaahTime}');
    }
  }

  // Prayer analysis
  print('\n=== Prayer Analysis ===');
  print('Current prayer: ${timetable.utils.currentId}');
  print('Next prayer: ${timetable.utils.nextId}');
  print('Time until next prayer: ${timetable.utils.countDown}');
  print('Prayer completion: ${timetable.utils.percentage.toStringAsFixed(1)}%');

  // Islamic information
  print('\n=== Islamic Information ===');
  print('Qibla direction: ${timetable.utils.qibla.toStringAsFixed(1)}°');
  print('Hijri date: ${timetable.utils.hijri[2]}/${timetable.utils.hijri[1]}/${timetable.utils.hijri[0]}');
  print('Islamic midnight: ${timetable.utils.midnight}');
  print('Last third of night: ${timetable.utils.lastThird}');
}
```

## Documentation

The library is fully documented with comprehensive inline documentation. All classes, methods, and properties include detailed descriptions, parameter explanations, and usage examples. Use your IDE's documentation features or generate documentation with:

```bash
dart doc
```

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

_May Allah accept our efforts in facilitating the observance of Islamic prayers. Ameen._
