import 'feedback.dart';
import 'matchers/base_matcher.dart';
import 'options.dart';

class Translation {
  const Translation({
    required this.warnings,
    required this.suggestions,
    required this.timeEstimation,
  });

  final WarningsTranslation warnings;
  final SuggestionsTranslation suggestions;
  final TimeEstimationTranslation timeEstimation;
}

class WarningsTranslation {
  const WarningsTranslation({
    required this.straightRow,
    required this.keyPattern,
    required this.simpleRepeat,
    required this.extendedRepeat,
    required this.sequences,
    required this.recentYears,
    required this.dates,
    required this.topTen,
    required this.topHundred,
    required this.common,
    required this.similarToCommon,
    required this.wordByItself,
    required this.namesByThemselves,
    required this.commonNames,
    required this.userInputs,
    required this.pwned,
  });

  final String straightRow;
  final String keyPattern;
  final String simpleRepeat;
  final String extendedRepeat;
  final String sequences;
  final String recentYears;
  final String dates;
  final String topTen;
  final String topHundred;
  final String common;
  final String similarToCommon;
  final String wordByItself;
  final String namesByThemselves;
  final String commonNames;
  final String userInputs;
  final String pwned;
}

class SuggestionsTranslation {
  const SuggestionsTranslation({
    required this.l33t,
    required this.reverseWords,
    required this.allUppercase,
    required this.capitalization,
    required this.dates,
    required this.recentYears,
    required this.associatedYears,
    required this.sequences,
    required this.repeated,
    required this.longerKeyboardPattern,
    required this.anotherWord,
    required this.useWords,
    required this.noNeed,
    required this.pwned,
  });

  final String l33t;
  final String reverseWords;
  final String allUppercase;
  final String capitalization;
  final String dates;
  final String recentYears;
  final String associatedYears;
  final String sequences;
  final String repeated;
  final String longerKeyboardPattern;
  final String anotherWord;
  final String useWords;
  final String noNeed;
  final String pwned;
}

class TimeEstimationTranslation {
  const TimeEstimationTranslation({
    required this.ltSecond,
    required this.second,
    required this.seconds,
    required this.minute,
    required this.minutes,
    required this.hour,
    required this.hours,
    required this.day,
    required this.days,
    required this.month,
    required this.months,
    required this.year,
    required this.years,
    required this.centuries,
  });

  final String ltSecond;
  final String second;
  final String seconds;
  final String minute;
  final String minutes;
  final String hour;
  final String hours;
  final String day;
  final String days;
  final String month;
  final String months;
  final String year;
  final String years;
  final String centuries;

  String property(String key) {
    switch (key) {
      case 'ltSecond':
        return ltSecond;
      case 'second':
        return second;
      case 'seconds':
        return seconds;
      case 'minute':
        return minute;
      case 'minutes':
        return minutes;
      case 'hour':
        return hour;
      case 'hours':
        return hours;
      case 'day':
        return day;
      case 'days':
        return days;
      case 'month':
        return month;
      case 'months':
        return months;
      case 'year':
        return year;
      case 'years':
        return years;
      case 'centuries':
        return centuries;
      default:
        return '';
    }
  }
}

class Optimal {
  const Optimal({
    required this.m,
    required this.pi,
    required this.g,
  });

  // Match.
  final BaseMatch m;

  // Product term Prod(m.guesses for m in sequence).
  // Allows for fast (non-looping) updates to the minimization function.
  final double pi;

  // Overall metric.
  final double g;
}

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
