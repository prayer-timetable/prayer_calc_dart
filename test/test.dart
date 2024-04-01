import 'package:prayer_timetable/src/PrayerTimetable.dart';

timetableTest(PrayerTimetable location) {
  print('*************** Current ***************');
  print('dawn:\t\t${location.currentPrayerTimes.dawn}');
  print('sunrise:\t${location.currentPrayerTimes.sunrise}');
  print('midday:\t\t${location.currentPrayerTimes.midday}');
  print('afternoon:\t${location.currentPrayerTimes.afternoon}');
  print('sunset:\t\t${location.currentPrayerTimes.sunset}');
  print('dusk:\t\t${location.currentPrayerTimes.dusk}');
  print('**************** Next *****************');
  print('dawn:\t\t${location.nextPrayerTimes.dawn}');
  print('sunrise:\t${location.nextPrayerTimes.sunrise}');
  print('midday:\t\t${location.nextPrayerTimes.midday}');
  print('afternoon:\t${location.nextPrayerTimes.afternoon}');
  print('sunset:\t\t${location.nextPrayerTimes.sunset}');
  print('dusk:\t\t${location.nextPrayerTimes.dusk}');
  print('************** Previous ***************');
  print('dawn:\t\t${location.previousPrayerTimes.dawn}');
  print('sunrise:\t${location.previousPrayerTimes.sunrise}');
  print('midday:\t\t${location.previousPrayerTimes.midday}');
  print('afternoon:\t${location.previousPrayerTimes.afternoon}');
  print('sunset:\t\t${location.previousPrayerTimes.sunset}');
  print('dusk:\t\t${location.previousPrayerTimes.dusk}');
  print('*************** Sunnah *****************');
  print('midnight:\t${location.sunnah.midnight}');
  print('lastThird\t${location.sunnah.lastThird}');
  print('************** Calc ***************');
  print('time:\t${location.calc.time}');
  print('current:\t${location.calc.current}');
  print('next:\t\t${location.calc.next}');
  print('previous:\t${location.calc.previous}');
  print('isAfterIsha:\t${location.calc.isAfterIsha}');
  print('currentId:\t${location.calc.currentId}');
  print('countDown:\t${location.calc.countDown}');
  print('countUp:\t${location.calc.countUp}');
  print('Qibla:\t${location.calc.qibla}');
  print('percentage:\t${location.calc.percentage}');
}

jamaahTest(PrayerTimetable location) {
  print('**************** Today *****************');
  print('dawn:\t\t${location.currentPrayerTimes.dawn}');
  print('sunrise:\t${location.currentPrayerTimes.sunrise}');
  print('midday:\t\t${location.currentPrayerTimes.midday}');
  print('afternoon:\t${location.currentPrayerTimes.afternoon}');
  print('sunset:\t\t${location.currentPrayerTimes.sunset}');
  print('dusk:\t\t${location.currentPrayerTimes.dusk}');

  print('************ Today Jamaah *************');
  print('dawn:\t\t${location.currentJamaahTimes.dawn}');
  print('sunrise:\t${location.currentJamaahTimes.sunrise}');
  print('midday:\t\t${location.currentJamaahTimes.midday}');
  print('afternoon:\t${location.currentJamaahTimes.afternoon}');
  print('sunset:\t\t${location.currentJamaahTimes.sunset}');
  print('dusk:\t\t${location.currentJamaahTimes.dusk}');

  print('*************** Tomorrow **************');
  print('dawn:\t\t${location.nextPrayerTimes.dawn}');
  print('sunrise:\t${location.nextPrayerTimes.sunrise}');
  print('midday:\t\t${location.nextPrayerTimes.midday}');
  print('afternoon:\t${location.nextPrayerTimes.afternoon}');
  print('sunset:\t\t${location.nextPrayerTimes.sunset}');
  print('dusk:\t\t${location.nextPrayerTimes.dusk}');

  print('*********** Tomorrow Jamaah ***********');
  print('dawn:\t\t${location.nextJamaahTimes.dawn}');
  print('sunrise:\t${location.nextJamaahTimes.sunrise}');
  print('midday:\t\t${location.nextJamaahTimes.midday}');
  print('afternoon:\t${location.nextJamaahTimes.afternoon}');
  print('sunset:\t\t${location.nextJamaahTimes.sunset}');
  print('dusk:\t\t${location.nextJamaahTimes.dusk}');

  print('************** Yesterday ***************');
  print('dawn:\t\t${location.previousPrayerTimes.dawn}');
  print('sunrise:\t${location.previousPrayerTimes.sunrise}');
  print('midday:\t\t${location.previousPrayerTimes.midday}');
  print('afternoon:\t${location.previousPrayerTimes.afternoon}');
  print('sunset:\t\t${location.previousPrayerTimes.sunset}');
  print('dusk:\t\t${location.previousPrayerTimes.dusk}');

  print('********** Yesterday Jamaah ***********');
  print('dawn:\t\t${location.previousJamaahTimes.dawn}');
  print('sunrise:\t${location.previousJamaahTimes.sunrise}');
  print('midday:\t\t${location.previousJamaahTimes.midday}');
  print('afternoon:\t${location.previousJamaahTimes.afternoon}');
  print('sunset:\t\t${location.previousJamaahTimes.sunset}');
  print('dusk:\t\t${location.previousJamaahTimes.dusk}');

  print('*************** Sunnah *****************');
  print('midnight:\t${location.sunnah.midnight}');
  print('lastThird\t${location.sunnah.lastThird}');
  print('************** Calc ***************');
  print('time:\t${location.calc.time}');
  print('current:\t${location.calc.current}');
  print('next:\t\t${location.calc.next}');
  print('previous:\t${location.calc.previous}');
  print('isAfterIsha:\t${location.calc.isAfterIsha}');
  print('jamaahPending:\t${location.calc.jamaahPending}');
  print('currentId:\t${location.calc.currentId}');
  print('countDown:\t${location.calc.countDown}');
  print('countUp:\t${location.calc.countUp}');
  print('percentage:\t${location.calc.percentage}');
  // print(location.current);
}
