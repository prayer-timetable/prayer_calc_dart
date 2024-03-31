/* *********************** */
/* MAIN FUNCTION           */
/* *********************** */
import 'package:prayer_timetable/prayer_timetable.dart';

JamaahTimes jamaahTimes({
  required PrayerTimes prayers,
  required List<String> jamaahMethods,
  required List<List<int>> jamaahOffsets,
}) {
  List<DateTime> jamaahTimes = [];

  List prayerCount = Iterable<int>.generate(6).toList();
  List<DateTime> prayerList = [
    prayers.dawn,
    prayers.sunrise,
    prayers.midday,
    prayers.afternoon,
    prayers.sunset,
    prayers.dusk
  ];

  prayerCount.forEach((prayerId) {
    // print(prayers);
    // DateTime jamaahTime = DateTime(;
    int offset;
    DateTime jamaahTime;

    if (jamaahOffsets[prayerId].isNotEmpty) {
      offset = jamaahOffsets[prayerId][0] * 60 + jamaahOffsets[prayerId][1];
    } else
      offset = -1;

    // String? method =
    //     jamaahMethods[prayerId].isNotEmpty ? jamaahMethods[prayerId] : null;
    // print('method: $method offset: $offset');

    if (jamaahMethods[prayerId] == 'afterthis') {
      // print('it is');
      jamaahTime = prayerList[prayerId].add(Duration(minutes: offset));
    } else if (jamaahMethods[prayerId] == 'fixed') {
      jamaahTime = DateTime(prayerList[prayerId].year, prayerList[prayerId].month,
          prayerList[prayerId].day, jamaahOffsets[prayerId][0], jamaahOffsets[prayerId][1]);
      // .add(Duration(minutes: offset));
      //
    } else {
      jamaahTime = prayerList[prayerId];
    }

    jamaahTimes.insert(
      prayerId,
      jamaahTime,
    );
  });

  JamaahTimes jamaahs = new JamaahTimes();
  jamaahs.dawn = jamaahTimes[0];
  jamaahs.sunrise = jamaahTimes[1];
  jamaahs.midday = jamaahTimes[2];
  jamaahs.afternoon = jamaahTimes[3];
  jamaahs.sunset = jamaahTimes[4];
  jamaahs.dusk = jamaahTimes[5];

  return jamaahs;
}
