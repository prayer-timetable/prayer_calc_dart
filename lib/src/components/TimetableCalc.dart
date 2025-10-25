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
            method: adhan.CalculationMethod.muslimWorldLeague,
            fajrAngle: fajrAngle,
            ishaAngle: ishaAngle ?? fajrAngle,
            highLatitudeRule:
                _parseHighLatitudeRule(highLatitudeRule) ?? adhan.HighLatitudeRule.twilightAngle,
            madhab: _parseMadhab(madhab) ?? adhan.Madhab.shafi,
            adjustments: _parseAdjustments(adjustments) ??
                {
                  adhan.Prayer.fajr: 0,
                  adhan.Prayer.sunrise: 0,
                  adhan.Prayer.dhuhr: 0,
                  adhan.Prayer.asr: 0,
                  adhan.Prayer.maghrib: 0,
                  adhan.Prayer.isha: 0,
                },
            methodAdjustments: _parseAdjustments(methodAdjustments) ??
                {
                  adhan.Prayer.fajr: 0,
                  adhan.Prayer.sunrise: 0,
                  adhan.Prayer.dhuhr: 0,
                  adhan.Prayer.asr: 0,
                  adhan.Prayer.maghrib: 0,
                  adhan.Prayer.isha: 0,
                },
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

  static adhan.HighLatitudeRule? _parseHighLatitudeRule(String? rule) {
    if (rule == null) return null;
    switch (rule.toLowerCase()) {
      case 'middleofthenight':
        return adhan.HighLatitudeRule.middleOfTheNight;
      case 'seventhofthenight':
        return adhan.HighLatitudeRule.seventhOfTheNight;
      case 'twilightangle':
        return adhan.HighLatitudeRule.twilightAngle;
      default:
        return null;
    }
  }

  static adhan.Madhab? _parseMadhab(String? madhab) {
    if (madhab == null) return null;
    switch (madhab.toLowerCase()) {
      case 'shafi':
        return adhan.Madhab.shafi;
      case 'hanafi':
        return adhan.Madhab.hanafi;
      default:
        return null;
    }
  }

  static Map<adhan.Prayer, int>? _parseAdjustments(Map<dynamic, dynamic>? adjustments) {
    if (adjustments == null) return null;
    Map<adhan.Prayer, int> result = {};

    adjustments.forEach((key, value) {
      adhan.Prayer? prayer = _parsePrayer(key.toString());
      if (prayer != null && value is int) {
        result[prayer] = value;
      }
    });

    return result.isEmpty ? null : result;
  }

  static adhan.Prayer? _parsePrayer(String prayer) {
    switch (prayer.toLowerCase()) {
      case 'fajr':
        return adhan.Prayer.fajr;
      case 'sunrise':
        return adhan.Prayer.sunrise;
      case 'dhuhr':
        return adhan.Prayer.dhuhr;
      case 'asr':
        return adhan.Prayer.asr;
      case 'maghrib':
        return adhan.Prayer.maghrib;
      case 'isha':
        return adhan.Prayer.isha;
      default:
        return null;
    }
  }
}
