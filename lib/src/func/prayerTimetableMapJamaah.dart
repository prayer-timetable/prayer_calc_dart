import 'package:prayer_timetable/src/components/Prayers.dart';

/* *********************** */
/* MAIN FUNCTION           */
/* *********************** */
Prayers jamaahTimetable(
  Prayers prayers,
  List<String> jamaahMethods,
  List<List<int>> jamaahOffsets,
) {
  /* *********************** */
  /* TIMES                   */
  /* *********************** */

  /* *********************** */
  /* PRAYER LISTS            */
  /* *********************** */

  List<DateTime> jamaahTimes = [];

  // List prayerCount = [
  //   [
  //     prayers.dawn,
  //     prayers.sunrise,
  //     prayers.midday,
  //     prayers.afternoon,
  //     prayers.sunset,
  //     prayers.dusk
  //   ]
  // ];
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
    // String method =
    //     jamaahMethods[prayerId].isNotEmpty ? jamaahMethods[prayerId] : null;

    if (jamaahOffsets[prayerId].isNotEmpty) {
      offset = jamaahOffsets[prayerId][0] * 60 + jamaahOffsets[prayerId][1];
    } else
      offset = -1;

    // print('method: $method offset: $offset');

    if (jamaahMethods[prayerId] == 'afterthis') {
      // print('it is');
      jamaahTime = prayerList[prayerId].add(Duration(minutes: offset));
    } else if (jamaahMethods[prayerId] == 'fixed') {
      jamaahTime = DateTime(prayerList[prayerId].year,
              prayerList[prayerId].month, prayerList[prayerId].day)
          .add(Duration(minutes: offset));
      //
    } else {
      jamaahTime = prayerList[prayerId];
    }

    jamaahTimes.insert(
      prayerId,
      jamaahTime,
    );
  });

  // next prayer - add isNext
  // prayersList[next.id].isNext = true;//TODO

  Prayers jamaah = new Prayers();
  jamaah.dawn = jamaahTimes[0];
  jamaah.sunrise = jamaahTimes[1];
  jamaah.midday = jamaahTimes[2];
  jamaah.afternoon = jamaahTimes[3];
  jamaah.sunset = jamaahTimes[4];
  jamaah.dusk = jamaahTimes[5];

  return jamaah;
}

//export { prayersCalc, dayCalc }
