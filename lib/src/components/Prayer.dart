class Prayer {
  int id = 0;
  String name = '';
  DateTime prayerTime = DateTime.now();
  DateTime jamaahTime = DateTime.now();
  Duration diff = Duration.zero;

  bool isCurrent = false;
  bool isNext = false;
  bool isJamaahPending = false;

  Prayer() {
    this.id;
    this.name;
    this.prayerTime;
    this.jamaahTime;

    this.diff;

    this.isCurrent;
    this.isNext;
    this.isJamaahPending;
  }

  static Prayer prayer = new Prayer();
}
