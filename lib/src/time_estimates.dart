import 'translation.dart';

/// Estimates time for an attacker.
AttackTimes estimateAttackTimes(double guesses) {
  final CrackTimesSeconds crackTimesSeconds = CrackTimesSeconds(
    onlineThrottling100PerHour: guesses / (100 / 3600),
    onlineNoThrottling10PerSecond: guesses / 10,
    offlineSlowHashing1e4PerSecond: guesses / 1e4,
    offlineFastHashing1e10PerSecond: guesses / 1e10,
  );
  final CrackTimesDisplay crackTimesDisplay = CrackTimesDisplay(
    onlineThrottling100PerHour:
        _displayTime(crackTimesSeconds.onlineThrottling100PerHour),
    onlineNoThrottling10PerSecond:
        _displayTime(crackTimesSeconds.onlineNoThrottling10PerSecond),
    offlineSlowHashing1e4PerSecond:
        _displayTime(crackTimesSeconds.offlineSlowHashing1e4PerSecond),
    offlineFastHashing1e10PerSecond:
        _displayTime(crackTimesSeconds.offlineFastHashing1e10PerSecond),
  );
  return AttackTimes(
    crackTimesSeconds: crackTimesSeconds,
    crackTimesDisplay: crackTimesDisplay,
    score: _guessesToScore(guesses),
  );
}

String _displayTime(double seconds) {
  TimeEstimationsPeriod displayPeriod = TimeEstimationsPeriod.centuries;
  final List<TimeEstimationsPeriod> timePeriods = _times.keys.toList();
  final int index = timePeriods.indexWhere(
    (TimeEstimationsPeriod period) => seconds < _times[period]!,
  );
  int value = 0;
  if (index > -1) {
    if (index > 0) {
      displayPeriod = timePeriods[index - 1];
      value = (seconds / _times[displayPeriod]!).round();
    } else {
      displayPeriod = TimeEstimationsPeriod.ltSecond;
    }
  }
  return Translation.timeEstimations.displayTime(displayPeriod, value);
}

int _guessesToScore(double guesses) {
  const int delta = 5;
  if (guesses < 1e3 + delta) {
    // Risky password: "too guessable".
    return 0;
  }
  if (guesses < 1e6 + delta) {
    // Modest protection from throttled online attacks: "very guessable".
    return 1;
  }
  if (guesses < 1e8 + delta) {
    // Modest protection from unthrottled online attacks:
    // "somewhat guessable".
    return 2;
  }
  if (guesses < 1e10 + delta) {
    // Modest protection from offline attacks: "safely unguessable".
    // Assuming a salted, slow hash function like bcrypt, scrypt, PBKDF2,
    // argon, etc.
    return 3;
  }
  // Strong protection from offline attacks under same scenario:
  // "very unguessable".
  return 4;
}

const Map<TimeEstimationsPeriod, int> _times = <TimeEstimationsPeriod, int>{
  TimeEstimationsPeriod.seconds: _second,
  TimeEstimationsPeriod.minutes: _minute,
  TimeEstimationsPeriod.hours: _hour,
  TimeEstimationsPeriod.days: _day,
  TimeEstimationsPeriod.months: _month,
  TimeEstimationsPeriod.years: _year,
  TimeEstimationsPeriod.centuries: _century,
};

const int _second = 1;
const int _minute = _second * 60;
const int _hour = _minute * 60;
const int _day = _hour * 24;
const int _month = _day * 31;
const int _year = _month * 12;
const int _century = _year * 100;

/// Estimated times for an attacker.
class AttackTimes {
  /// Creates a new instance.
  const AttackTimes({
    required this.crackTimesSeconds,
    required this.crackTimesDisplay,
    required this.score,
  });

  /// Estimated times in seconds.
  final CrackTimesSeconds crackTimesSeconds;

  /// Estimated times in human readable format.
  final CrackTimesDisplay crackTimesDisplay;

  /// Password strength from 0 (the weakest) to 4 (the strongest).
  final int score;

  @override
  String toString() => '${crackTimesSeconds.onlineThrottling100PerHour}, '
      '${crackTimesSeconds.onlineNoThrottling10PerSecond}, '
      '${crackTimesSeconds.offlineSlowHashing1e4PerSecond}, '
      '${crackTimesSeconds.offlineFastHashing1e10PerSecond}, '
      '${crackTimesDisplay.onlineThrottling100PerHour}, '
      '${crackTimesDisplay.onlineNoThrottling10PerSecond}, '
      '${crackTimesDisplay.offlineSlowHashing1e4PerSecond}, '
      '${crackTimesDisplay.offlineFastHashing1e10PerSecond}, '
      '$score ';
}

/// Estimated times in seconds.
class CrackTimesSeconds {
  /// Creates a new instance.
  const CrackTimesSeconds({
    required this.onlineThrottling100PerHour,
    required this.onlineNoThrottling10PerSecond,
    required this.offlineSlowHashing1e4PerSecond,
    required this.offlineFastHashing1e10PerSecond,
  });

  /// Estimated time when trying 100 passwords per hour.
  final double onlineThrottling100PerHour;

  /// Estimated time when trying 10 passwords per second.
  final double onlineNoThrottling10PerSecond;

  /// Estimated time when trying 10000 passwords per second.
  final double offlineSlowHashing1e4PerSecond;

  /// Estimated time when trying 10000000000 passwords per second.
  final double offlineFastHashing1e10PerSecond;

  @override
  String toString() => '[$onlineThrottling100PerHour, '
      '$onlineNoThrottling10PerSecond, $offlineSlowHashing1e4PerSecond, '
      '$offlineFastHashing1e10PerSecond]';
}

/// Estimated times in human readable format.
class CrackTimesDisplay {
  /// Creates a new instance.
  const CrackTimesDisplay({
    required this.onlineThrottling100PerHour,
    required this.onlineNoThrottling10PerSecond,
    required this.offlineSlowHashing1e4PerSecond,
    required this.offlineFastHashing1e10PerSecond,
  });

  /// Estimated time when trying 100 passwords per hour.
  final String onlineThrottling100PerHour;

  /// Estimated time when trying 10 passwords per second.
  final String onlineNoThrottling10PerSecond;

  /// Estimated time when trying 10000 passwords per second.
  final String offlineSlowHashing1e4PerSecond;

  /// Estimated time when trying 10000000000 passwords per second.
  final String offlineFastHashing1e10PerSecond;

  @override
  String toString() => '[$onlineThrottling100PerHour, '
      '$onlineNoThrottling10PerSecond, $offlineSlowHashing1e4PerSecond, '
      '$offlineFastHashing1e10PerSecond]';
}
