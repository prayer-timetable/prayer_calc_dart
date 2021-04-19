import 'package:prayer_timetable/src/classes/Madhab.dart';
import 'package:prayer_timetable/src/classes/HighLatitudeRule.dart';

class CalculationParameters {
  String method = "Other";
  double fajrAngle = 0;
  double ishaAngle = 0;
  double ishaInterval = 0;
  double maghribAngle = 0;
  String madhab = Madhab.Shafi;
  String highLatitudeRule = HighLatitudeRule.MiddleOfTheNight;
  Map adjustments = {
    'fajr': 0,
    'sunrise': 0,
    'dhuhr': 0,
    'asr': 0,
    'maghrib': 0,
    'isha': 0
  };
  Map methodAdjustments = {
    'fajr': 0,
    'sunrise': 0,
    'dhuhr': 0,
    'asr': 0,
    'maghrib': 0,
    'isha': 0
  };

  CalculationParameters(String methodName, double fajrAngle, double ishaAngle,
      {double ishaInterval = 0, double maghribAngle = 0}) {
    this.method = methodName;
    this.fajrAngle = fajrAngle;
    this.ishaAngle = ishaAngle;
    this.ishaAngle = ishaInterval;
    this.maghribAngle = maghribAngle;
    this.madhab = Madhab.Shafi;
    this.highLatitudeRule = HighLatitudeRule.MiddleOfTheNight;
    this.adjustments = {
      'fajr': 0,
      'sunrise': 0,
      'dhuhr': 0,
      'asr': 0,
      'maghrib': 0,
      'isha': 0
    };
    this.methodAdjustments = {
      'fajr': 0,
      'sunrise': 0,
      'dhuhr': 0,
      'asr': 0,
      'maghrib': 0,
      'isha': 0
    };
  }

  nightPortions() {
    switch (this.highLatitudeRule) {
      case HighLatitudeRule.MiddleOfTheNight:
        return {'fajr': 1 / 2, 'isha': 1 / 2};
      case HighLatitudeRule.SeventhOfTheNight:
        return {'fajr': 1 / 7, 'isha': 1 / 7};
      case HighLatitudeRule.TwilightAngle:
        return {'fajr': this.fajrAngle / 60, 'isha': this.ishaAngle / 60};
      default:
        throw ('Invalid high latitude rule found when attempting to compute night portions: ${this.highLatitudeRule}');
    }
  }
}
