import 'translation.dart';
import 'types.dart';

const int second = 1;
const int minute = second * 60;
const int hour = minute * 60;
const int day = hour * 24;
const int month = day * 31;
const int year = month * 12;
const int century = year * 100;

const Map<TimeEstimationsPeriod, int> times = <TimeEstimationsPeriod, int>{
  TimeEstimationsPeriod.seconds: second,
  TimeEstimationsPeriod.minutes: minute,
  TimeEstimationsPeriod.hours: hour,
  TimeEstimationsPeriod.days: day,
  TimeEstimationsPeriod.months: month,
  TimeEstimationsPeriod.years: year,
  TimeEstimationsPeriod.centuries: century,
};

/// Estimates time for an attacker.
class TimeEstimates {
  const TimeEstimates();

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
    final List<TimeEstimationsPeriod> timePeriods = times.keys.toList();
    final int index = timePeriods.indexWhere(
      (TimeEstimationsPeriod period) => seconds < times[period]!,
    );
    int value = 0;
    if (index > -1) {
      if (index > 0) {
        displayPeriod = timePeriods[index - 1];
        value = (seconds / times[displayPeriod]!).round();
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
