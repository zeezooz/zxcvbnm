import 'feedback.dart';
import 'matcher/dictionary/feedback.dart';
import 'matcher/dictionary/scoring.dart';
import 'matcher/dictionary/variants/scoring/l33t.dart';
import 'matcher/dictionary/variants/scoring/uppercase.dart';
import 'matcher/repeat/feedback.dart';
import 'matcher/repeat/scoring.dart';
import 'matcher/separator/scoring.dart';
import 'matcher/sequence/feedback.dart';
import 'matcher/sequence/scoring.dart';
import 'matcher/spatial/feedback.dart';
import 'matcher/spatial/scoring.dart';
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

typedef L33tTable = Map<String, List<String>>;

class PasswordChange {
  const PasswordChange({
    required this.l33t,
    required this.clean,
  });

  final String l33t;
  final String clean;

  @override
  String toString() => '$l33t -> $clean';
}

enum Dictionary {
  diceware,
  passwords,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
  userInputs,
}

class DictionaryMatch extends BaseMatch {
  DictionaryMatch({
    required String password,
    required int start,
    required int end,
    required this.matchedWord,
    required this.rank,
    required this.dictionary,
    this.levenshteinDistance,
    this.levenshteinDistanceEntry,
    required this.options,
  }) : super(password: password, start: start, end: end);

  final String matchedWord;
  final int rank;
  final Dictionary dictionary;
  final int? levenshteinDistance;
  final String? levenshteinDistanceEntry;
  final Options options;

  @override
  String toString() => '${super.toString()}, '
      'uppercaseVariations: $uppercaseVariations, '
      'l33tVariations: $l33tVariations, matchedWord: "$matchedWord", '
      'rank: $rank, dictionary: $dictionary, '
      'levenshteinDistance: $levenshteinDistance, '
      'levenshteinDistanceEntry: $levenshteinDistanceEntry';

  ReverseMatch toReverseMatch() => ReverseMatch(
        password: password.split('').reversed.join(''),
        start: password.length - end,
        end: password.length - start,
        matchedWord: matchedWord,
        rank: rank,
        dictionary: dictionary,
        levenshteinDistance: levenshteinDistance,
        levenshteinDistanceEntry: levenshteinDistanceEntry,
        options: options,
      );

  L33tMatch toL33tMatch({
    required String password,
    required int start,
    required int end,
    required List<PasswordChange> changes,
    required String changesDisplay,
  }) =>
      L33tMatch(
        password: password,
        start: start,
        end: end,
        matchedWord: matchedWord,
        rank: rank,
        dictionary: dictionary,
        levenshteinDistance: levenshteinDistance,
        levenshteinDistanceEntry: levenshteinDistanceEntry,
        changes: changes,
        changesDisplay: changesDisplay,
        options: options,
      );

  @override
  double get estimatedGuesses => dictionaryScoring(this);

  double get uppercaseVariations => uppercaseScoring(this);

  double get l33tVariations => l33tScoring(this);

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return dictionaryFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
}

class ReverseMatch extends DictionaryMatch {
  ReverseMatch({
    required String password,
    required int start,
    required int end,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required Options options,
  }) : super(
          password: password,
          start: start,
          end: end,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
          options: options,
        );
}

class L33tMatch extends DictionaryMatch {
  L33tMatch({
    required String password,
    required int start,
    required int end,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required this.changes,
    required this.changesDisplay,
    required Options options,
  }) : super(
          password: password,
          start: start,
          end: end,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
          options: options,
        );

  final List<PasswordChange> changes;
  final String changesDisplay;

  @override
  String toString() => '${super.toString()}, changes: $changes, '
      'changesDisplay: $changesDisplay';

  // changes are ignored.
  bool isDuplicateOf(Object other) =>
      other is L33tMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
      changesDisplay == other.changesDisplay;
}

class SpatialMatch extends BaseMatch {
  SpatialMatch({
    required String password,
    required int start,
    required int end,
    required this.graph,
    required this.turns,
    required this.shiftedCount,
    required this.options,
  }) : super(password: password, start: start, end: end);

  final String graph;
  final int turns;
  final int shiftedCount;
  final Options options;

  @override
  String toString() => '${super.toString()}, graph: "$graph", turns: $turns, '
      'shiftedCount: $shiftedCount';

  @override
  double get estimatedGuesses => spatialScoring(this, options);

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return spatialFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
}

class RepeatMatch extends BaseMatch {
  RepeatMatch({
    required String password,
    required int start,
    required int end,
    required this.baseToken,
    required this.baseGuesses,
    required this.repeatCount,
    required this.options,
  }) : super(password: password, start: start, end: end);

  final String baseToken;
  final double baseGuesses;
  final int repeatCount;
  final Options options;

  @override
  String toString() => '${super.toString()}, baseToken: "$baseToken", '
      'baseGuesses: $baseGuesses, repeatCount: $repeatCount';

  @override
  double get estimatedGuesses => repeatScoring(this);

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return repeatFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
}

class SequenceMatch extends BaseMatch {
  SequenceMatch({
    required String password,
    required int start,
    required int end,
    required this.sequenceName,
    required this.sequenceSpace,
    required this.ascending,
    required this.options,
  }) : super(password: password, start: start, end: end);

  final String sequenceName;
  final int sequenceSpace;
  final bool ascending;
  final Options options;

  @override
  String toString() => '${super.toString()}, sequenceName: $sequenceName, '
      'sequenceSpace: $sequenceSpace, ascending: $ascending';

  @override
  double get estimatedGuesses => sequenceScoring(this);

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return sequenceFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
}

class SeparatorMatch extends BaseMatch {
  SeparatorMatch({
    required String password,
    required int start,
    required int end,
  }) : super(password: password, start: start, end: end);

  @override
  double get estimatedGuesses => separatorScoring(this);

  @override
  Feedback? feedback({required bool isSoleMatch}) => null;
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

typedef Dictionaries = Map<Dictionary, List<Object>>;

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
