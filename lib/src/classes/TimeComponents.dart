// import 'dart:math';

class TimeComponents {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  TimeComponents(double number) {
    this.hours = (number).floor();
    this.minutes = ((number - this.hours) * 60).floor();
    this.seconds =
        ((number - (this.hours + this.minutes / 60)) * 60 * 60).floor();
    // print(seconds);
    // return this;
  }

  DateTime utcDate(year, month, date) {
    return new DateTime.utc(
        year, month, date, this.hours, this.minutes, this.seconds);
  }
}
