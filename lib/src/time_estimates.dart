import 'options.dart';
import 'types.dart';

const int second = 1;
const int minute = second * 60;
const int hour = minute * 60;
const int day = hour * 24;
const int month = day * 31;
const int year = month * 12;
const int century = year * 100;

const Map<String, int> times = <String, int>{
  'second': second,
  'minute': minute,
  'hour': hour,
  'day': day,
  'month': month,
  'year': year,
  'century': century,
};

/// Estimates time for an attacker.
class TimeEstimates {
  const TimeEstimates(this.options);

  final Options options;

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
    String displayString = 'centuries';
    final List<String> timeKeys = times.keys.toList();
    final int foundIndex =
        timeKeys.indexWhere((String time) => seconds < times[time]!);
    int? value;
    if (foundIndex > -1) {
      if (foundIndex > 0) {
        displayString = timeKeys[foundIndex - 1];
        value = (seconds / times[displayString]!).round();
      } else {
        displayString = 'ltSecond';
      }
    }
    return _translate(displayString, value);
  }

  String _translate(String displayString, int? value) {
    String key = displayString;
    if (value != null && value != 1) {
      key += 's';
    }
    final TimeEstimationTranslation timeEstimation =
        options.translation.timeEstimation;
    return timeEstimation.property(key).replaceAll('{base}', '$value');
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
}

class AttackTimes {
  const AttackTimes({
    required this.crackTimesSeconds,
    required this.crackTimesDisplay,
    required this.score,
  });

  final CrackTimesSeconds crackTimesSeconds;
  final CrackTimesDisplay crackTimesDisplay;
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
