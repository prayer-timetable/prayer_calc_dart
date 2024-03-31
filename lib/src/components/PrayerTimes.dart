class PrayerTimes {
  DateTime dawn = DateTime.now();
  DateTime sunrise = DateTime.now();
  DateTime midday = DateTime.now();
  DateTime afternoon = DateTime.now();
  DateTime sunset = DateTime.now();
  DateTime dusk = DateTime.now();

  PrayerTimes() {
    this.dawn;
    this.sunrise;
    this.midday;
    this.afternoon;
    this.sunset;
    this.dusk;
  }

  static PrayerTimes times = new PrayerTimes();
}
