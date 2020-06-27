import 'package:prayer_calc/src/PrayerTimetableMap.dart';
import 'src/timetable_map.dart';

PrayerTimetable dublin = PrayerTimetable(
  timetableDublin,
  // optional parameters:
  // year: 2020,
  // month: 3,
  // day: 28,
);

PrayerTimetable location = dublin;

timetableTest() {
  print('**************** Today *****************');
  print('dawn:\t\t${location.prayers.current.dawn}');
  print('sunrise:\t${location.prayers.current.sunrise}');
  print('midday:\t\t${location.prayers.current.midday}');
  print('afternoon:\t${location.prayers.current.afternoon}');
  print('sunset:\t\t${location.prayers.current.sunset}');
  print('dusk:\t\t${location.prayers.current.dusk}');
  print('*************** Tomorrow **************');
  print('dawn:\t\t${location.prayers.next.dawn}');
  print('sunrise:\t${location.prayers.next.sunrise}');
  print('midday:\t\t${location.prayers.next.midday}');
  print('afternoon:\t${location.prayers.next.afternoon}');
  print('sunset:\t\t${location.prayers.next.sunset}');
  print('dusk:\t\t${location.prayers.next.dusk}');
  print('************** Yesterday ***************');
  print('dawn:\t\t${location.prayers.previous.dawn}');
  print('sunrise:\t${location.prayers.previous.sunrise}');
  print('midday:\t\t${location.prayers.previous.midday}');
  print('afternoon:\t${location.prayers.previous.afternoon}');
  print('sunset:\t\t${location.prayers.previous.sunset}');
  print('dusk:\t\t${location.prayers.previous.dusk}');
  print('*************** Sunnah *****************');
  print('midnight:\t${location.sunnah.midnight}');
  print('lastThird\t${location.sunnah.lastThird}');
  print('************** Durations ***************');
  print('nowLocal:\t${location.durations.now}');
  print('current:\t${location.durations.current}');
  print('next:\t\t${location.durations.next}');
  print('previous:\t${location.durations.previous}');
  print('isAfterIsha:\t${location.durations.isAfterIsha}');
  print('currentId:\t${location.durations.currentId}');
  print('countDown:\t${location.durations.countDown}');
  print('countUp:\t${location.durations.countUp}');
  // print(location.current);
}
