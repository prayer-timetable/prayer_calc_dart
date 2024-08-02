class Prayer {
  int id = 0;
  String name = '';
  DateTime prayerTime = DateTime.now();
  DateTime jamaahTime = DateTime.now();
  DateTime endTime = DateTime.now();

  Duration diff = Duration.zero;

  bool isCurrent = false;
  bool isNext = false;
  bool isJamaahPending = false;
  // bool isAfterIsha = false;

  Prayer() {
    this.id;
    this.name;
    this.prayerTime;
    this.jamaahTime;
    this.endTime;

    this.diff;

    this.isCurrent;
    this.isNext;
    this.isJamaahPending;
    // this.isAfterIsha;
  }

  static Prayer prayer = new Prayer();
}
