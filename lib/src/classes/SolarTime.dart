import 'dart:math';

import 'package:prayer_timetable/src/classes/Astronomical.dart';
import 'package:prayer_timetable/src/classes/MathUtils.dart';
import 'package:prayer_timetable/src/classes/SolarCoordinates.dart';
import 'package:prayer_timetable/src/classes/Coordinates.dart';

class SolarTime {
  Coordinates observer = Coordinates(0, 0);
  SolarCoordinates solar = SolarCoordinates(0);
  SolarCoordinates prevSolar = SolarCoordinates(0);
  SolarCoordinates nextSolar = SolarCoordinates(0);

  double approxTransit = 0;
  double transit = 0;
  double sunrise = 0;
  double sunset = 0;

  SolarTime(date, coordinates) {
    double julianDay =
        Astronomical.julianDay(date.year, date.month, date.day, 0);

    this.observer = coordinates;
    this.solar = new SolarCoordinates(julianDay);

    this.prevSolar = new SolarCoordinates(julianDay - 1);
    this.nextSolar = new SolarCoordinates(julianDay + 1);

    double m0 = Astronomical.approximateTransit(coordinates.longitude,
        this.solar.apparentSiderealTime, this.solar.rightAscension);
    const solarAltitude = -50.0 / 60.0;

    this.approxTransit = m0;

    this.transit = Astronomical.correctedTransit(
        m0,
        coordinates.longitude,
        this.solar.apparentSiderealTime,
        this.solar.rightAscension,
        this.prevSolar.rightAscension,
        this.nextSolar.rightAscension);

    this.sunrise = Astronomical.correctedHourAngle(
        m0,
        solarAltitude,
        coordinates,
        false,
        this.solar.apparentSiderealTime,
        this.solar.rightAscension,
        this.prevSolar.rightAscension,
        this.nextSolar.rightAscension,
        this.solar.declination,
        this.prevSolar.declination,
        this.nextSolar.declination);

    this.sunset = Astronomical.correctedHourAngle(
        m0,
        solarAltitude,
        coordinates,
        true,
        this.solar.apparentSiderealTime,
        this.solar.rightAscension,
        this.prevSolar.rightAscension,
        this.nextSolar.rightAscension,
        this.solar.declination,
        this.prevSolar.declination,
        this.nextSolar.declination);
  }

  double hourAngle(angle, afterTransit) {
    return Astronomical.correctedHourAngle(
        this.approxTransit,
        angle,
        this.observer,
        afterTransit,
        this.solar.apparentSiderealTime,
        this.solar.rightAscension,
        this.prevSolar.rightAscension,
        this.nextSolar.rightAscension,
        this.solar.declination,
        this.prevSolar.declination,
        this.nextSolar.declination);
  }

  double afternoon(shadowLength) {
    // TODO source shadow angle calculation
    double tangent = (this.observer.latitude - this.solar.declination).abs();
    double inverse = shadowLength + tan(degreesToRadians(tangent));
    double angle = radiansToDegrees(atan(1.0 / inverse));
    return this.hourAngle(angle, true);
  }
}
