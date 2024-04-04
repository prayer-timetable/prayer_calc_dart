import 'package:prayer_timetable/src/components/PrayerTimes.dart';

class JamaahTimes extends PrayerTimes {
  @override
  DateTime dawn = DateTime.now();
  @override
  DateTime sunrise = DateTime.now();
  @override
  DateTime midday = DateTime.now();
  @override
  DateTime afternoon = DateTime.now();
  @override
  DateTime sunset = DateTime.now();
  @override
  DateTime dusk = DateTime.now();

  @override
  DateTime fajr = DateTime.now();
  @override
  DateTime shurooq = DateTime.now();
  @override
  DateTime dhuhr = DateTime.now();
  @override
  DateTime asr = DateTime.now();
  @override
  DateTime maghrib = DateTime.now();
  @override
  DateTime isha = DateTime.now();

  JamaahTimes() {
    /* *********************** */
    /* PRAYER LISTS            */
    /* *********************** */
    this.dawn;
    this.sunrise;
    this.midday;
    this.afternoon;
    this.sunset;
    this.dusk;

    this.fajr = this.dawn;
    this.shurooq = this.sunrise;
    this.dhuhr = this.midday;
    this.asr = this.afternoon;
    this.maghrib = this.sunset;
    this.isha = this.dusk;
    //end
  }

  static JamaahTimes times = new JamaahTimes();
}
