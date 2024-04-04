import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/timezone.dart' as tz;

class CalcPrayers {
  String? timezone;
  tz.Location? timezoneLoc; // = tz.getLocation('xx/xx');
  Coordinates? coordinates; // = new Coordinates(43.8563, 18.4131);
  CalculationParameters params = CalculationMethod.MuslimWorldLeague();
  PrayerTimes? prayerTimes; // = PrayerTimes(
  // Coordinates(43.8563, 18.4131), DateTime.now(), CalculationMethod.MuslimWorldLeague());
  // double angle = CalculationMethod.MuslimWorldLeague().fajrAngle;

  CalcPrayers(
    DateTime date, {
    required String timezone,
    required double lat,
    required double long,
    double? angle = 14.6,
    bool precision = false,
    String? madhab,
  }) {
    this.timezone = timezone;
    this.coordinates = Coordinates(lat, long);
    this.params;
    this.params.madhab = madhab ?? Madhab.Shafi;
    this.params.fajrAngle = angle ?? CalculationMethod.MuslimWorldLeague().fajrAngle;
    this.params.ishaAngle = angle ?? CalculationMethod.MuslimWorldLeague().fajrAngle;

    this.prayerTimes = PrayerTimes(Coordinates(lat, long), date, this.params, precision: precision);
  }
}


// const lat = 43.8563;
// const lng = 18.4131;
// const alt = 518;
// const angleF = 14.6; //iz =19
// const angleI = 14.6; // iz = 17
// const timezone = 1;
// const height = 1.8;