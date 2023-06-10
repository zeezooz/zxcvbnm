import 'dart:async';

import 'matcher/dictionary/scoring.dart';
import 'matching.dart';
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
  firstnames,
  lastnames,
  wikipedia,
  userInputs,
}

class Match {
  const Match._({
    required this.i,
    required this.j,
    required this.token,
  });

  /// The start index of the token found in the password.
  final int i;

  /// The end index of the token found in the password.
  final int j;

  /// The token found in the password.
  final String token;

  @override
  String toString() => '[$i, $j] "$token"';
}

class DictionaryMatch extends Match {
  const DictionaryMatch({
    required int i,
    required int j,
    required String token,
    required this.matchedWord,
    required this.rank,
    required this.dictionary,
    this.levenshteinDistance,
    this.levenshteinDistanceEntry,
  }) : super._(i: i, j: j, token: token);

  final String matchedWord;
  final int rank;
  final Dictionary dictionary;
  final int? levenshteinDistance;
  final String? levenshteinDistanceEntry;

  @override
  String toString() => '[$i, $j] "$token", matchedWord: "$matchedWord", '
      'rank: $rank, dictionary: $dictionary, '
      'levenshteinDistance: $levenshteinDistance, '
      'levenshteinDistanceEntry: $levenshteinDistanceEntry';

  ReverseMatch toReverseMatch(String password) => ReverseMatch(
        i: password.length - 1 - j,
        j: password.length - 1 - i,
        token: token.split('').reversed.join(''),
        matchedWord: matchedWord,
        rank: rank,
        dictionary: dictionary,
        levenshteinDistance: levenshteinDistance,
        levenshteinDistanceEntry: levenshteinDistanceEntry,
      );

  L33tMatch toL33tMatch({
    int? j,
    required String token,
    required List<PasswordChange> changes,
    required String changesDisplay,
  }) =>
      L33tMatch(
        i: i,
        j: j ?? this.j,
        token: token,
        matchedWord: matchedWord,
        rank: rank,
        dictionary: dictionary,
        levenshteinDistance: levenshteinDistance,
        levenshteinDistanceEntry: levenshteinDistanceEntry,
        changes: changes,
        changesDisplay: changesDisplay,
      );
}

class ReverseMatch extends DictionaryMatch {
  const ReverseMatch({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
        );
}

class L33tMatch extends DictionaryMatch {
  const L33tMatch({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required this.changes,
    required this.changesDisplay,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
        );

  final List<PasswordChange> changes;
  final String changesDisplay;

  @override
  String toString() => '[$i, $j] "$token", matchedWord: "$matchedWord", '
      'rank: $rank, dictionary: $dictionary,'
      'levenshteinDistance: $levenshteinDistance, '
      'levenshteinDistanceEntry: $levenshteinDistanceEntry, changes: $changes, '
      'changesDisplay: $changesDisplay';

  // changes are ignored.
  bool isDuplicateOf(Object other) =>
      other is L33tMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
      changesDisplay == other.changesDisplay;
}

class SpatialMatch extends Match {
  const SpatialMatch({
    required int i,
    required int j,
    required String token,
    required this.graph,
    required this.turns,
    required this.shiftedCount,
  }) : super._(i: i, j: j, token: token);

  final String graph;
  final int turns;
  final int shiftedCount;
}

class RepeatMatch extends Match {
  const RepeatMatch({
    required int i,
    required int j,
    required String token,
    required this.baseToken,
    required this.baseGuesses,
    required this.repeatCount,
  }) : super._(i: i, j: j, token: token);

  final String baseToken;
  final int baseGuesses;
  final int repeatCount;
}

class SequenceMatch extends Match {
  const SequenceMatch({
    required int i,
    required int j,
    required String token,
    required this.sequenceName,
    required this.sequenceSpace,
    required this.ascending,
  }) : super._(i: i, j: j, token: token);

  final String sequenceName;
  final int sequenceSpace;
  final bool ascending;
}

class RegexMatch extends Match {
  const RegexMatch({
    required int i,
    required int j,
    required String token,
    required this.regexName,
    required this.regexMatch,
  }) : super._(i: i, j: j, token: token);

  final String regexName;
  final List<String> regexMatch;
}

class DateMatch extends Match {
  const DateMatch({
    required int i,
    required int j,
    required String token,
    required this.separator,
    required this.year,
    required this.month,
    required this.day,
  }) : super._(i: i, j: j, token: token);

  final String separator;
  final int year;
  final int month;
  final int day;

  @override
  String toString() => '[$i, $j] "$token", separator: "$separator", '
      'date: $year-$month-$day';
}

class BruteForceMatch extends Match {
  const BruteForceMatch({
    required int i,
    required int j,
    required String token,
  }) : super._(i: i, j: j, token: token);
}

class SeparatorMatch extends Match {
  const SeparatorMatch({
    required int i,
    required int j,
    required String token,
  }) : super._(i: i, j: j, token: token);
}

class MatchEstimated extends Match {
  const MatchEstimated._({
    required int i,
    required int j,
    required String token,
    required this.guesses,
    required this.guessesLog10,
    this.baseGuesses,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super._(
          i: i,
          j: j,
          token: token,
        );

  final double guesses;
  final double guessesLog10;
  final int? baseGuesses;
  final int? uppercaseVariations;
  final int? l33tVariations;
}

class DictionaryMatchEstimated extends DictionaryMatch
    implements MatchEstimated {
  const DictionaryMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required this.guesses,
    required this.guessesLog10,
    this.baseGuesses,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
        );

  @override
  final double guesses;
  @override
  final double guessesLog10;
  @override
  final int? baseGuesses;
  @override
  final int? uppercaseVariations;
  @override
  final int? l33tVariations;
}

class ReverseMatchEstimated extends ReverseMatch implements MatchEstimated {
  const ReverseMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required this.guesses,
    required this.guessesLog10,
    this.baseGuesses,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
        );

  @override
  final double guesses;
  @override
  final double guessesLog10;
  @override
  final int? baseGuesses;
  @override
  final int? uppercaseVariations;
  @override
  final int? l33tVariations;
}

class L33tMatchEstimated extends L33tMatch implements MatchEstimated {
  const L33tMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required List<PasswordChange> changes,
    required String changesDisplay,
    required this.guesses,
    required this.guessesLog10,
    this.baseGuesses,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
          changes: changes,
          changesDisplay: changesDisplay,
        );

  @override
  final double guesses;
  @override
  final double guessesLog10;
  @override
  final int? baseGuesses;
  @override
  final int? uppercaseVariations;
  @override
  final int? l33tVariations;
}

class SpatialMatchEstimated extends SpatialMatch implements MatchEstimated {
  const SpatialMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String graph,
    required int turns,
    required int shiftedCount,
    required this.guesses,
    required this.guessesLog10,
    this.baseGuesses,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          graph: graph,
          turns: turns,
          shiftedCount: shiftedCount,
        );

  @override
  final double guesses;
  @override
  final double guessesLog10;
  @override
  final int? baseGuesses;
  @override
  final int? uppercaseVariations;
  @override
  final int? l33tVariations;
}

class RepeatMatchEstimated extends RepeatMatch implements MatchEstimated {
  const RepeatMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String baseToken,
    required int baseGuesses,
    required int repeatCount,
    required this.guesses,
    required this.guessesLog10,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
          repeatCount: repeatCount,
        );

  @override
  final double guesses;
  @override
  final double guessesLog10;
  @override
  final int? uppercaseVariations;
  @override
  final int? l33tVariations;
}

class SequenceMatchEstimated extends SequenceMatch implements MatchEstimated {
  const SequenceMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String sequenceName,
    required int sequenceSpace,
    required bool ascending,
    required this.guesses,
    required this.guessesLog10,
    this.baseGuesses,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          sequenceName: sequenceName,
          sequenceSpace: sequenceSpace,
          ascending: ascending,
        );

  @override
  final double guesses;
  @override
  final double guessesLog10;
  @override
  final int? baseGuesses;
  @override
  final int? uppercaseVariations;
  @override
  final int? l33tVariations;
}

class RegexMatchEstimated extends RegexMatch implements MatchEstimated {
  const RegexMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String regexName,
    required List<String> regexMatch,
    required this.guesses,
    required this.guessesLog10,
    this.baseGuesses,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          regexName: regexName,
          regexMatch: regexMatch,
        );

  @override
  final double guesses;
  @override
  final double guessesLog10;
  @override
  final int? baseGuesses;
  @override
  final int? uppercaseVariations;
  @override
  final int? l33tVariations;
}

class DateMatchEstimated extends DateMatch implements MatchEstimated {
  const DateMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String separator,
    required int year,
    required int month,
    required int day,
    required this.guesses,
    required this.guessesLog10,
    this.baseGuesses,
    this.uppercaseVariations,
    this.l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          separator: separator,
          year: year,
          month: month,
          day: day,
        );

  @override
  final double guesses;
  @override
  final double guessesLog10;
  @override
  final int? baseGuesses;
  @override
  final int? uppercaseVariations;
  @override
  final int? l33tVariations;
}

class BruteForceMatchEstimated extends MatchEstimated
    implements BruteForceMatch {
  const BruteForceMatchEstimated({
    required int i,
    required int j,
    required String token,
    required double guesses,
    required double guessesLog10,
    int? baseGuesses,
    int? uppercaseVariations,
    int? l33tVariations,
  }) : super._(
          i: i,
          j: j,
          token: token,
          guesses: guesses,
          guessesLog10: guessesLog10,
          baseGuesses: baseGuesses,
          uppercaseVariations: uppercaseVariations,
          l33tVariations: l33tVariations,
        );
}

class SeparatorMatchEstimated extends MatchEstimated implements SeparatorMatch {
  const SeparatorMatchEstimated({
    required int i,
    required int j,
    required String token,
    required double guesses,
    required double guessesLog10,
    int? baseGuesses,
    int? uppercaseVariations,
    int? l33tVariations,
  }) : super._(
          i: i,
          j: j,
          token: token,
          guesses: guesses,
          guessesLog10: guessesLog10,
          baseGuesses: baseGuesses,
          uppercaseVariations: uppercaseVariations,
          l33tVariations: l33tVariations,
        );
}

class Optimal {
  const Optimal({
    required this.m,
    required this.pi,
    required this.g,
  });

  final Match m;
  final Match pi;
  final Match g;
}

class CrackTimesSeconds {
  const CrackTimesSeconds({
    required this.onlineThrottling100PerHour,
    required this.onlineNoThrottling10PerSecond,
    required this.offlineSlowHashing1e4PerSecond,
    required this.offlineFastHashing1e10PerSecond,
  });

  final int onlineThrottling100PerHour;
  final int onlineNoThrottling10PerSecond;
  final int offlineSlowHashing1e4PerSecond;
  final int offlineFastHashing1e10PerSecond;
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
}

class Feedback {
  const Feedback({
    this.warning,
    List<String>? suggestions,
  }) : suggestions = suggestions ?? const <String>[];

  final String? warning;
  final List<String> suggestions;
}

typedef Dictionaries = Map<Dictionary, List<Object>>;

typedef GraphEntry = Map<String, List<String?>>;

typedef Graph = Map<String, GraphEntry>;

typedef RankedDictionary = Map<String, int>;

typedef RankedDictionaries = Map<Dictionary, RankedDictionary>;

typedef DefaultFeedbackFunction = Feedback? Function({
  required MatchEstimated match,
  required Options options,
  bool? isSoleMatch,
});

typedef DefaultScoringFunction = DictionaryReturn Function(Match match);

abstract class MatchingType {
  FutureOr<List<Match>> match({
    required String password,
    required Matching omniMatch,
  });
}

class Matcher {
  const Matcher({
    required this.feedback,
    required this.scoring,
    required this.matching,
  });

  final DefaultFeedbackFunction feedback;
  final DefaultScoringFunction scoring;
  final MatchingType matching;
}

typedef Matchers = Map<String, Matcher>;

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
  final List<Match> sequence;
  final int calcTime;
}
