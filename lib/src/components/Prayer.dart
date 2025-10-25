/// Represents a single Islamic prayer with its timing information and status.
///
/// This class encapsulates all the information related to a prayer time including
/// the actual prayer time, jamaah (congregation) time, end time, and various
/// status flags that help determine the current state of the prayer.
///
/// The prayer IDs follow this convention:
/// - 0: Fajr (Dawn prayer)
/// - 1: Sunrise (Not a prayer, but marks end of Fajr time)
/// - 2: Dhuhr (Noon prayer)
/// - 3: Asr (Afternoon prayer)
/// - 4: Maghrib (Sunset prayer)
/// - 5: Isha (Night prayer)
class Prayer {
  /// Unique identifier for the prayer (0-5).
  /// 0=Fajr, 1=Sunrise, 2=Dhuhr, 3=Asr, 4=Maghrib, 5=Isha
  int id = 0;

  /// Human-readable name of the prayer (e.g., "Fajr", "Dhuhr", etc.)
  String name = '';

  /// The actual time when the prayer begins
  DateTime prayerTime = DateTime.now();

  /// The time when jamaah (congregation) prayer starts
  /// This is typically a few minutes after the prayer time
  DateTime jamaahTime = DateTime.now();

  /// The time when the prayer period ends
  /// For example, Fajr ends at sunrise, Dhuhr ends at Asr time
  DateTime endTime = DateTime.now();

  /// Time difference between current time and prayer time
  /// Positive if prayer is upcoming, negative if prayer has passed
  Duration diff = Duration.zero;

  /// Whether this prayer is currently active (between its start and end time)
  bool isCurrent = false;

  /// Whether this is the next upcoming prayer
  bool isNext = false;

  /// Whether jamaah time is pending (prayer time has started but jamaah hasn't)
  bool isJamaahPending = false;

  /// Default constructor initializing all properties to their default values
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
  }

  /// Static instance for default prayer object
  static Prayer prayer = new Prayer();

  /// Creates a string representation of the prayer for debugging
  @override
  String toString() {
    return 'Prayer{id: $id, name: $name, prayerTime: $prayerTime, '
        'jamaahTime: $jamaahTime, isCurrent: $isCurrent, isNext: $isNext}';
  }
}
