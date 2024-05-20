import 'package:adhan_dart/adhan_dart.dart' as adhan;

class TimetableCalc {
  TimetableCalc({
    required this.date,
    required this.timezone,
    required this.lat,
    required this.lng,
    required this.precision,
    required this.fajrAngle,
    this.ishaAngle,
    this.highLatitudeRule,
    this.madhab,
    this.adjustments,
    this.methodAdjustments,
  }) : this.prayerTimes = adhan.PrayerTimes(
          coordinates: adhan.Coordinates(lat, lng),
          date: date,
          calculationParameters: adhan.CalculationParameters(
            method: 'MuslimWorldLeague',
            fajrAngle: fajrAngle,
            ishaAngle: ishaAngle ?? fajrAngle,
            highLatitudeRule: highLatitudeRule ?? adhan.HighLatitudeRule.middleOfTheNight,
            madhab: madhab ?? adhan.Madhab.shafi,
            adjustments: adjustments ??
                {'fajr': 0, 'sunrise': 0, 'dhuhr': 0, 'asr': 0, 'maghrib': 0, 'isha': 0},
            methodAdjustments: methodAdjustments ??
                {'fajr': 0, 'sunrise': 0, 'dhuhr': 0, 'asr': 0, 'maghrib': 0, 'isha': 0},
          ),
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

  String? highLatitudeRule;
  String? madhab;
  Map<dynamic, dynamic>? adjustments;
  Map<dynamic, dynamic>? methodAdjustments;

  TimetableCalc copyWith({
    DateTime? date,
    String? timezone,
    double? lat,
    double? lng,
    bool? precision,
    double? fajrAngle,
    double? ishaAngle,
    String? highLatitudeRule,
    String? madhab,
    Map<dynamic, dynamic>? adjustments,
    Map<dynamic, dynamic>? methodAdjustments,
  }) =>
      TimetableCalc(
        date: date ?? this.date,
        timezone: timezone ?? this.timezone,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        precision: precision ?? this.precision,
        fajrAngle: fajrAngle ?? this.fajrAngle,
        ishaAngle: ishaAngle ?? this.ishaAngle ?? this.fajrAngle,
        highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule ?? this.highLatitudeRule,
        madhab: madhab ?? this.madhab ?? this.madhab,
        adjustments: adjustments ?? this.adjustments ?? this.adjustments,
        methodAdjustments: methodAdjustments ?? this.methodAdjustments ?? this.methodAdjustments,
      );
}
