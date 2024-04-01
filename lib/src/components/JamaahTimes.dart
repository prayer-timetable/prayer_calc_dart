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

  JamaahTimes() {
    /* *********************** */
    /* PRAYER LISTS            */
    /* *********************** */

    //end
  }

  static JamaahTimes times = new JamaahTimes();
}
