class PrayerTimes {
  DateTime dawn = DateTime.now();
  DateTime sunrise = DateTime.now();
  DateTime midday = DateTime.now();
  DateTime afternoon = DateTime.now();
  DateTime sunset = DateTime.now();
  DateTime dusk = DateTime.now();

  DateTime fajr = DateTime.now();
  DateTime shurooq = DateTime.now();
  DateTime dhuhr = DateTime.now();
  DateTime asr = DateTime.now();
  DateTime maghrib = DateTime.now();
  DateTime isha = DateTime.now();

  PrayerTimes() {
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
  }

  static PrayerTimes times = new PrayerTimes();
}
