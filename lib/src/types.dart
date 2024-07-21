import 'feedback.dart';
import 'matchers/base_matcher.dart';
import 'options.dart';

class CrackTimesSeconds {
  const CrackTimesSeconds({
    required this.onlineThrottling100PerHour,
    required this.onlineNoThrottling10PerSecond,
    required this.offlineSlowHashing1e4PerSecond,
    required this.offlineFastHashing1e10PerSecond,
  });

  final double onlineThrottling100PerHour;
  final double onlineNoThrottling10PerSecond;
  final double offlineSlowHashing1e4PerSecond;
  final double offlineFastHashing1e10PerSecond;

  @override
  String toString() => '[$onlineThrottling100PerHour, '
      '$onlineNoThrottling10PerSecond, $offlineSlowHashing1e4PerSecond, '
      '$offlineFastHashing1e10PerSecond]';
}

class CrackTimesDisplay {
  const CrackTimesDisplay({
    required this.onlineThrottling100PerHour,
    required this.onlineNoThrottling10PerSecond,
    required this.offlineSlowHashing1e4PerSecond,
    required this.offlineFastHashing1e10PerSecond,
  });

  final String onlineThrottling100PerHour;
  final String onlineNoThrottling10PerSecond;
  final String offlineSlowHashing1e4PerSecond;
  final String offlineFastHashing1e10PerSecond;

  @override
  String toString() => '[$onlineThrottling100PerHour, '
      '$onlineNoThrottling10PerSecond, $offlineSlowHashing1e4PerSecond, '
      '$offlineFastHashing1e10PerSecond]';
}

typedef GraphEntry = Map<String, List<String?>>;

typedef Graph = Map<String, GraphEntry>;

typedef RankedDictionary = Map<String, int>;

typedef RankedDictionaries = Map<Dictionary, RankedDictionary>;

class Result {
  const Result({
    required this.feedback,
    required this.crackTimesSeconds,
    required this.crackTimesDisplay,
    required this.score,
    required this.password,
    required this.guesses,
    required this.guessesLog10,
    required this.sequence,
    required this.calcTime,
  });

  final Feedback feedback;
  final CrackTimesSeconds crackTimesSeconds;
  final CrackTimesDisplay crackTimesDisplay;
  final int score;
  final String password;
  final double guesses;
  final double guessesLog10;
  final List<BaseMatch> sequence;
  final int calcTime;

  @override
  String toString() => '$feedback, $crackTimesSeconds, $crackTimesDisplay, '
      '$score, $password, $guesses, $guessesLog10, $sequence, $calcTime';
}
