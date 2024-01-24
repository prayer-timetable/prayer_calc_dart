import 'package:prayer_timetable/src/classes/SolarTime.dart';
import 'package:prayer_timetable/src/classes/TimeComponents.dart';
import 'package:prayer_timetable/src/classes/Prayer.dart';
import 'package:prayer_timetable/src/classes/Astronomical.dart';
import 'package:prayer_timetable/src/classes/DateUtils.dart';
import 'package:prayer_timetable/src/classes/Madhab.dart';

import 'package:prayer_timetable/src/classes/Coordinates.dart';
import 'package:prayer_timetable/src/classes/CalculationParameters.dart';

class PrayerTimesCalc {
  Coordinates coordinates = Coordinates(0.0, 0.0);
  DateTime date = DateTime.now();
  CalculationParameters calculationParameters =
      CalculationParameters("Other", 0, 0);

  DateTime? fajr;
  DateTime? sunrise;
  DateTime? dhuhr;
  DateTime? asr;
  DateTime? maghrib;
  DateTime? isha;

  PrayerTimesCalc(Coordinates coordinates, DateTime date,
      CalculationParameters calculationParameters,
      {precision: true}) {
    this.coordinates = coordinates;
    this.date = date;
    this.calculationParameters = calculationParameters;

    var solarTime = new SolarTime(date, coordinates);

    DateTime fajrTime;
    DateTime asrTime;
    DateTime maghribTime;
    DateTime ishaTime;

    var nightFraction;

    DateTime dhuhrTime = new TimeComponents(solarTime.transit)
        .utcDate(date.year, date.month, date.day);
    DateTime sunriseTime = new TimeComponents(solarTime.sunrise)
        .utcDate(date.year, date.month, date.day);
    DateTime sunsetTime = new TimeComponents(solarTime.sunset)
        .utcDate(date.year, date.month, date.day);

    asrTime = new TimeComponents(
            solarTime.afternoon(shadowLength(calculationParameters.madhab)))
        .utcDate(date.year, date.month, date.day);

    DateTime tomorrow = dateByAddingDays(date, 1);
    var tomorrowSolarTime = new SolarTime(tomorrow, coordinates);
    DateTime tomorrowSunrise = new TimeComponents(tomorrowSolarTime.sunrise)
        .utcDate(tomorrow.year, tomorrow.month, tomorrow.day);
    // var night = (tomorrowSunrise - sunsetTime) / 1000;
    int night = (tomorrowSunrise.difference(sunsetTime)).inSeconds;

    fajrTime = new TimeComponents(
            solarTime.hourAngle(-1 * calculationParameters.fajrAngle, false))
        .utcDate(date.year, date.month, date.day);

    // special case for moonsighting committee above latitude 55
    if (calculationParameters.method == "MoonsightingCommittee" &&
        coordinates.latitude >= 55) {
      nightFraction = night / 7;
      fajrTime = dateByAddingSeconds(sunriseTime, -nightFraction);
    }

    DateTime safeFajr() {
      if (calculationParameters.method == "MoonsightingCommittee") {
        return Astronomical.seasonAdjustedMorningTwilight(
            coordinates.latitude, dayOfYear(date), date.year, sunriseTime);
      } else {
        var portion = calculationParameters.nightPortions()["fajr"];
        nightFraction = portion * night;
        return dateByAddingSeconds(sunriseTime, -nightFraction.round());
      }
    }

    if (fajrTime == null ||
        fajrTime.millisecondsSinceEpoch == double.nan ||
        safeFajr().isAfter(fajrTime)) {
      fajrTime = safeFajr();
    }

    if (calculationParameters.ishaInterval != null &&
        calculationParameters.ishaInterval > 0) {
      ishaTime =
          dateByAddingMinutes(sunsetTime, calculationParameters.ishaInterval);
    } else {
      ishaTime = new TimeComponents(
              solarTime.hourAngle(-1 * calculationParameters.ishaAngle, true))
          .utcDate(date.year, date.month, date.day);

      // special case for moonsighting committee above latitude 55
      if (calculationParameters.method == "MoonsightingCommittee" &&
          coordinates.latitude >= 55) {
        nightFraction = night / 7;
        ishaTime = dateByAddingSeconds(sunsetTime, nightFraction);
      }

      DateTime safeIsha() {
        if (calculationParameters.method == "MoonsightingCommittee") {
          return Astronomical.seasonAdjustedEveningTwilight(
              coordinates.latitude, dayOfYear(date), date.year, sunsetTime);
        } else {
          var portion = calculationParameters.nightPortions()["isha"];
          nightFraction = portion * night;
          return dateByAddingSeconds(sunsetTime, nightFraction.round());
        }
      }

      if (ishaTime == null ||
          ishaTime.millisecondsSinceEpoch == double.nan ||
          safeIsha().isBefore(ishaTime)) {
        ishaTime = safeIsha();
      }
    }

    maghribTime = sunsetTime;
    if (calculationParameters.maghribAngle != null) {
      DateTime angleBasedMaghrib = new TimeComponents(solarTime.hourAngle(
              -1 * calculationParameters.maghribAngle, true))
          .utcDate(date.year, date.month, date.day);
      if (sunsetTime.isBefore(angleBasedMaghrib) &&
          ishaTime.isAfter(angleBasedMaghrib)) {
        maghribTime = angleBasedMaghrib;
      }
    }

    // double fajrAdjustment = (calculationParameters.adjustments["fajr"] && 0) + (calculationParameters.methodAdjustments["fajr"] && 0);
    int fajrAdjustment = (calculationParameters.adjustments["fajr"] ?? 0) +
        (calculationParameters.methodAdjustments["fajr"] ?? 0);
    int sunriseAdjustment =
        (calculationParameters.adjustments["sunrise"] ?? 0) +
            (calculationParameters.methodAdjustments["sunrise"] ?? 0);
    int dhuhrAdjustment = (calculationParameters.adjustments["dhuhr"] ?? 0) +
        (calculationParameters.methodAdjustments["dhuhr"] ?? 0);
    int asrAdjustment = (calculationParameters.adjustments["asr"] ?? 0) +
        (calculationParameters.methodAdjustments["asr"] ?? 0);
    int maghribAdjustment =
        (calculationParameters.adjustments["maghrib"] ?? 0) +
            (calculationParameters.methodAdjustments["maghrib"] ?? 0);
    int ishaAdjustment = (calculationParameters.adjustments["isha"] ?? 0) +
        (calculationParameters.methodAdjustments["isha"] ?? 0);

    this.fajr = roundedMinute(dateByAddingMinutes(fajrTime, fajrAdjustment),
        precision: precision);
    this.sunrise = roundedMinute(
        dateByAddingMinutes(sunriseTime, sunriseAdjustment),
        precision: precision);
    this.dhuhr = roundedMinute(dateByAddingMinutes(dhuhrTime, dhuhrAdjustment),
        precision: precision);
    this.asr = roundedMinute(dateByAddingMinutes(asrTime, asrAdjustment),
        precision: precision);
    this.maghrib = roundedMinute(
        dateByAddingMinutes(maghribTime, maghribAdjustment),
        precision: precision);
    this.isha = roundedMinute(dateByAddingMinutes(ishaTime, ishaAdjustment),
        precision: precision);
  }

  timeForPrayer(prayer) {
    if (prayer == Prayer.Fajr) {
      return this.fajr;
    } else if (prayer == Prayer.Sunrise) {
      return this.sunrise;
    } else if (prayer == Prayer.Dhuhr) {
      return this.dhuhr;
    } else if (prayer == Prayer.Asr) {
      return this.asr;
    } else if (prayer == Prayer.Maghrib) {
      return this.maghrib;
    } else if (prayer == Prayer.Isha) {
      return this.isha;
    } else {
      return null;
    }
  }

  currentPrayer(date) {
    if (date == null) {
      date = DateTime.now();
    }
    if (date >= this.isha) {
      return Prayer.Isha;
    } else if (date >= this.maghrib) {
      return Prayer.Maghrib;
    } else if (date >= this.asr) {
      return Prayer.Asr;
    } else if (date >= this.dhuhr) {
      return Prayer.Dhuhr;
    } else if (date >= this.sunrise) {
      return Prayer.Sunrise;
    } else if (date >= this.fajr) {
      return Prayer.Fajr;
    } else {
      return Prayer.None;
    }
  }

  nextPrayer(date) {
    if (date == null) {
      date = DateTime.now();
    }
    if (date >= this.isha) {
      return Prayer.None;
    } else if (date >= this.maghrib) {
      return Prayer.Isha;
    } else if (date >= this.asr) {
      return Prayer.Maghrib;
    } else if (date >= this.dhuhr) {
      return Prayer.Asr;
    } else if (date >= this.sunrise) {
      return Prayer.Dhuhr;
    } else if (date >= this.fajr) {
      return Prayer.Sunrise;
    } else {
      return Prayer.Fajr;
    }
  }
}
