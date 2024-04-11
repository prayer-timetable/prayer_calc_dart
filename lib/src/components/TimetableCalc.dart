import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:timezone/timezone.dart' as tz;

class TimetableCalc {
  TimetableCalc({
    required this.date,
    required this.timezone,
    required this.lat,
    required this.lng,
    required this.precision,
    required this.fajrAngle,
    this.ishaAngle,
  }) : this.prayerTimes = adhan.PrayerTimes(
          adhan.Coordinates(lat, lng),
          date,
          adhan.CalculationParameters(
              adhan.CalculationMethod.MuslimWorldLeague(), fajrAngle, ishaAngle ?? fajrAngle),
          precision: precision,
        );

  DateTime date;
  String timezone;
  double lat;
  double lng;
  bool precision;
  adhan.PrayerTimes prayerTimes;
  double fajrAngle;
  double? ishaAngle;

  TimetableCalc copyWith({
    DateTime? date,
    String? timezone,
    double? lat,
    double? lng,
    bool? precision,
    double? fajrAngle,
    double? ishaAngle,
  }) =>
      TimetableCalc(
        date: date ?? this.date,
        timezone: timezone ?? this.timezone,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        precision: precision ?? this.precision,
        fajrAngle: fajrAngle ?? this.fajrAngle,
        ishaAngle: ishaAngle ?? this.ishaAngle ?? this.fajrAngle,
      );
}
