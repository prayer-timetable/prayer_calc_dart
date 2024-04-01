/* *********************** */
/* MAIN FUNCTION           */
/* *********************** */
import 'package:prayer_timetable/prayer_timetable.dart';

JamaahTimes jamaahTimes({
  required PrayerTimes prayers,
  required List<String> jamaahMethods,
  required List<List<int>> jamaahOffsets,
  required List<bool> jamaahPerPrayer,
}) {
  List<DateTime> jamaahTimes = [];

  List<DateTime> prayerList = [
    prayers.dawn,
    prayers.sunrise,
    prayers.midday,
    prayers.afternoon,
    prayers.sunset,
    prayers.dusk
  ];

  for (final (index, DateTime item) in prayerList.indexed) {
    int offset = 0;
    DateTime jamaahTime = item;

    if (jamaahOffsets[index].isNotEmpty) {
      offset = jamaahOffsets[index][0] * 60 + jamaahOffsets[index][1];
    }

    if (!jamaahPerPrayer[index])
      jamaahTime = prayerList[index];
    else if (jamaahMethods[index] == 'afterthis') {
      // print('it is');
      jamaahTime = prayerList[index].add(Duration(minutes: offset));
    } else if (jamaahMethods[index] == 'fixed') {
      jamaahTime = DateTime(prayerList[index].year, prayerList[index].month, prayerList[index].day,
          jamaahOffsets[index][0], jamaahOffsets[index][1]);
      // .add(Duration(minutes: offset));
      //
    } else {
      jamaahTime = prayerList[index];
    }

    jamaahTimes = [...jamaahTimes, jamaahTime];
  }

  JamaahTimes jamaahs = new JamaahTimes();
  jamaahs.dawn = jamaahTimes[0];
  jamaahs.sunrise = jamaahTimes[1];
  jamaahs.midday = jamaahTimes[2];
  jamaahs.afternoon = jamaahTimes[3];
  jamaahs.sunset = jamaahTimes[4];
  jamaahs.dusk = jamaahTimes[5];

  return jamaahs;
}
