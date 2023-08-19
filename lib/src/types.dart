import 'dart:async';
import 'dart:math';

import 'data/const.dart';
import 'feedback.dart';
import 'matcher/bruteforce/scoring.dart';
import 'matcher/date/feedback.dart';
import 'matcher/date/scoring.dart';
import 'matcher/dictionary/feedback.dart';
import 'matcher/dictionary/scoring.dart';
import 'matcher/regex/feedback.dart';
import 'matcher/regex/scoring.dart';
import 'matcher/repeat/feedback.dart';
import 'matcher/repeat/scoring.dart';
import 'matcher/separator/scoring.dart';
import 'matcher/sequence/feedback.dart';
import 'matcher/sequence/scoring.dart';
import 'matcher/spatial/feedback.dart';
import 'matcher/spatial/scoring.dart';
import 'options.dart';
import 'scoring/utils.dart';

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

abstract class Match {
  const Match({
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
  String toString() => '$runtimeType [$i, $j] "$token"';

  double getMinGuesses(String password) {
    int minGuesses = 1;
    if (token.length < password.length) {
      if (token.length == 1) {
        minGuesses = minSubmatchGuessesSingleChar;
      } else {
        minGuesses = minSubmatchGuessesMultiChar;
      }
    }
    return minGuesses.toDouble();
  }

  MatchEstimated estimate(String password, Options options);
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
  }) : super(i: i, j: j, token: token);

  final String matchedWord;
  final int rank;
  final Dictionary dictionary;
  final int? levenshteinDistance;
  final String? levenshteinDistanceEntry;

  @override
  String toString() => '${super.toString()}, matchedWord: "$matchedWord", '
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
    int? i,
    int? j,
    required String token,
    required List<PasswordChange> changes,
    required String changesDisplay,
  }) =>
      L33tMatch(
        i: i ?? this.i,
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

  @override
  DictionaryMatchEstimated estimate(String password, Options options) {
    if (this is DictionaryMatchEstimated) {
      return this as DictionaryMatchEstimated;
    }
    final DictionaryReturn estimation = dictionaryScoring(this);
    final double guesses = max(estimation.calculation, getMinGuesses(password));
    return DictionaryMatchEstimated(
      i: i,
      j: j,
      token: token,
      matchedWord: matchedWord,
      rank: rank,
      dictionary: dictionary,
      levenshteinDistance: levenshteinDistance,
      levenshteinDistanceEntry: levenshteinDistanceEntry,
      guesses: guesses,
      guessesLog10: log10(guesses),
      baseGuesses: estimation.baseGuesses,
      uppercaseVariations: estimation.uppercaseVariations,
      l33tVariations: estimation.l33tVariations,
    );
  }
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

  @override
  ReverseMatchEstimated estimate(String password, Options options) {
    if (this is ReverseMatchEstimated) return this as ReverseMatchEstimated;
    final DictionaryReturn estimation = dictionaryScoring(this);
    final double guesses = max(estimation.calculation, getMinGuesses(password));
    return ReverseMatchEstimated(
      i: i,
      j: j,
      token: token,
      matchedWord: matchedWord,
      rank: rank,
      dictionary: dictionary,
      levenshteinDistance: levenshteinDistance,
      levenshteinDistanceEntry: levenshteinDistanceEntry,
      guesses: guesses,
      guessesLog10: log10(guesses),
      baseGuesses: estimation.baseGuesses,
      uppercaseVariations: estimation.uppercaseVariations,
      l33tVariations: estimation.l33tVariations,
    );
  }
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
  String toString() => '${super.toString()}, changes: $changes, '
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

  @override
  L33tMatchEstimated estimate(String password, Options options) {
    if (this is L33tMatchEstimated) return this as L33tMatchEstimated;
    final DictionaryReturn estimation = dictionaryScoring(this);
    final double guesses = max(estimation.calculation, getMinGuesses(password));
    return L33tMatchEstimated(
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
      guesses: guesses,
      guessesLog10: log10(guesses),
      baseGuesses: estimation.baseGuesses,
      uppercaseVariations: estimation.uppercaseVariations,
      l33tVariations: estimation.l33tVariations,
    );
  }
}

class SpatialMatch extends Match {
  const SpatialMatch({
    required int i,
    required int j,
    required String token,
    required this.graph,
    required this.turns,
    required this.shiftedCount,
  }) : super(i: i, j: j, token: token);

  final String graph;
  final int turns;
  final int shiftedCount;

  @override
  String toString() => '${super.toString()}, graph: "$graph", turns: $turns, '
      'shiftedCount: $shiftedCount';

  @override
  SpatialMatchEstimated estimate(String password, Options options) {
    if (this is SpatialMatchEstimated) return this as SpatialMatchEstimated;
    final double guesses =
        max(spatialScoring(this, options), getMinGuesses(password));
    return SpatialMatchEstimated(
      i: i,
      j: j,
      token: token,
      graph: graph,
      turns: turns,
      shiftedCount: shiftedCount,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
}

class RepeatMatch extends Match {
  const RepeatMatch({
    required int i,
    required int j,
    required String token,
    required this.baseToken,
    required this.baseGuesses,
    required this.repeatCount,
  }) : super(i: i, j: j, token: token);

  final String baseToken;
  final double baseGuesses;
  final int repeatCount;

  @override
  String toString() => '${super.toString()}, baseToken: "$baseToken", '
      'baseGuesses: $baseGuesses, repeatCount: $repeatCount';

  @override
  RepeatMatchEstimated estimate(String password, Options options) {
    if (this is RepeatMatchEstimated) return this as RepeatMatchEstimated;
    final double guesses = max(repeatScoring(this), getMinGuesses(password));
    return RepeatMatchEstimated(
      i: i,
      j: j,
      token: token,
      baseToken: baseToken,
      baseGuesses: baseGuesses,
      repeatCount: repeatCount,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
}

class SequenceMatch extends Match {
  const SequenceMatch({
    required int i,
    required int j,
    required String token,
    required this.sequenceName,
    required this.sequenceSpace,
    required this.ascending,
  }) : super(i: i, j: j, token: token);

  final String sequenceName;
  final int sequenceSpace;
  final bool ascending;

  @override
  String toString() => '${super.toString()}, sequenceName: $sequenceName, '
      'sequenceSpace: $sequenceSpace, ascending: $ascending';

  @override
  SequenceMatchEstimated estimate(String password, Options options) {
    if (this is SequenceMatchEstimated) return this as SequenceMatchEstimated;
    final double guesses = max(sequenceScoring(this), getMinGuesses(password));
    return SequenceMatchEstimated(
      i: i,
      j: j,
      token: token,
      sequenceName: sequenceName,
      sequenceSpace: sequenceSpace,
      ascending: ascending,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
}

class RegexMatch extends Match {
  const RegexMatch({
    required int i,
    required int j,
    required String token,
    required this.regexName,
    required this.regexMatch,
  }) : super(i: i, j: j, token: token);

  final String regexName;
  final RegExpMatch regexMatch;

  @override
  String toString() => '${super.toString()}, regexName: $regexName, '
      'regexMatch: [${regexMatch.start}, ${regexMatch.end}] "${regexMatch[0]}"';

  @override
  RegexMatchEstimated estimate(String password, Options options) {
    if (this is RegexMatchEstimated) return this as RegexMatchEstimated;
    final double guesses = max(regexScoring(this), getMinGuesses(password));
    return RegexMatchEstimated(
      i: i,
      j: j,
      token: token,
      regexName: regexName,
      regexMatch: regexMatch,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
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
  }) : super(i: i, j: j, token: token);

  final String separator;
  final int year;
  final int month;
  final int day;

  @override
  String toString() => '${super.toString()}, separator: "$separator", '
      'date: $year-$month-$day';

  @override
  DateMatchEstimated estimate(String password, Options options) {
    if (this is DateMatchEstimated) return this as DateMatchEstimated;
    final double guesses = max(dateScoring(this), getMinGuesses(password));
    return DateMatchEstimated(
      i: i,
      j: j,
      token: token,
      separator: separator,
      year: year,
      month: month,
      day: day,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
}

class BruteForceMatch extends Match {
  const BruteForceMatch({
    required int i,
    required int j,
    required String token,
  }) : super(i: i, j: j, token: token);

  @override
  BruteForceMatchEstimated estimate(String password, Options options) {
    if (this is BruteForceMatchEstimated) {
      return this as BruteForceMatchEstimated;
    }
    final double guesses =
        max(bruteforceScoring(this), getMinGuesses(password));
    return BruteForceMatchEstimated(
      i: i,
      j: j,
      token: token,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
}

class SeparatorMatch extends Match {
  const SeparatorMatch({
    required int i,
    required int j,
    required String token,
  }) : super(i: i, j: j, token: token);

  @override
  SeparatorMatchEstimated estimate(String password, Options options) {
    if (this is SeparatorMatchEstimated) return this as SeparatorMatchEstimated;
    final double guesses = max(separatorScoring(this), getMinGuesses(password));
    return SeparatorMatchEstimated(
      i: i,
      j: j,
      token: token,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
}

abstract class MatchEstimated extends Match {
  const MatchEstimated({
    required int i,
    required int j,
    required String token,
    required this.guesses,
    required this.guessesLog10,
  }) : super(i: i, j: j, token: token);

  final double guesses;
  final double guessesLog10;

  @override
  String toString() => '${super.toString()}, guesses: $guesses, '
      'guessesLog10: $guessesLog10';

  Feedback? feedback(Options options, {bool? isSoleMatch});
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
    required this.baseGuesses,
    required this.uppercaseVariations,
    required this.l33tVariations,
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
  final int baseGuesses;
  final double uppercaseVariations;
  final double l33tVariations;

  @override
  String toString() => '${super.toString()}, guesses: $guesses, '
      'guessesLog10: $guessesLog10, baseGuesses: $baseGuesses, '
      'uppercaseVariations: $uppercaseVariations, '
      'l33tVariations: $l33tVariations';

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) {
    return dictionaryFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
}

class ReverseMatchEstimated extends DictionaryMatchEstimated
    implements ReverseMatch {
  const ReverseMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required double guesses,
    required double guessesLog10,
    required int baseGuesses,
    required double uppercaseVariations,
    required double l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
          guesses: guesses,
          guessesLog10: guessesLog10,
          baseGuesses: baseGuesses,
          uppercaseVariations: uppercaseVariations,
          l33tVariations: l33tVariations,
        );

  @override
  ReverseMatchEstimated estimate(String password, Options options) => this;
}

class L33tMatchEstimated extends DictionaryMatchEstimated implements L33tMatch {
  const L33tMatchEstimated({
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
    required double guesses,
    required double guessesLog10,
    required int baseGuesses,
    required double uppercaseVariations,
    required double l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
          guesses: guesses,
          guessesLog10: guessesLog10,
          baseGuesses: baseGuesses,
          uppercaseVariations: uppercaseVariations,
          l33tVariations: l33tVariations,
        );

  @override
  final List<PasswordChange> changes;
  @override
  final String changesDisplay;

  @override
  String toString() => '$runtimeType [$i, $j] "$token", '
      'matchedWord: "$matchedWord", rank: $rank, dictionary: $dictionary, '
      'levenshteinDistance: $levenshteinDistance, '
      'levenshteinDistanceEntry: $levenshteinDistanceEntry, '
      'changes: $changes, changesDisplay: $changesDisplay, '
      'guesses: $guesses, guessesLog10: $guessesLog10, '
      'baseGuesses: $baseGuesses, uppercaseVariations: $uppercaseVariations, '
      'l33tVariations: $l33tVariations';

  // changes are ignored.
  @override
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

  @override
  L33tMatchEstimated estimate(String password, Options options) => this;
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
  String toString() => '${super.toString()}, guesses: $guesses, '
      'guessesLog10: $guessesLog10';

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) {
    return spatialFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
}

class RepeatMatchEstimated extends RepeatMatch implements MatchEstimated {
  const RepeatMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String baseToken,
    required double baseGuesses,
    required int repeatCount,
    required this.guesses,
    required this.guessesLog10,
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
  String toString() => '${super.toString()}, guesses: $guesses, '
      'guessesLog10: $guessesLog10';

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) {
    return repeatFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
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
  String toString() => '${super.toString()}, guesses: $guesses, '
      'guessesLog10: $guessesLog10';

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) {
    return sequenceFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
}

class RegexMatchEstimated extends RegexMatch implements MatchEstimated {
  const RegexMatchEstimated({
    required int i,
    required int j,
    required String token,
    required String regexName,
    required RegExpMatch regexMatch,
    required this.guesses,
    required this.guessesLog10,
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
  String toString() => '${super.toString()}, guesses: $guesses, '
      'guessesLog10: $guessesLog10';

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) {
    return regexFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
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
  String toString() => '${super.toString()}, guesses: $guesses, '
      'guessesLog10: $guessesLog10';

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) {
    return dateFeedback(
      match: this,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
}

class BruteForceMatchEstimated extends MatchEstimated
    implements BruteForceMatch {
  const BruteForceMatchEstimated({
    required int i,
    required int j,
    required String token,
    required double guesses,
    required double guessesLog10,
  }) : super(
          i: i,
          j: j,
          token: token,
          guesses: guesses,
          guessesLog10: guessesLog10,
        );

  @override
  BruteForceMatchEstimated estimate(String password, Options options) => this;

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) => null;
}

class SeparatorMatchEstimated extends MatchEstimated implements SeparatorMatch {
  const SeparatorMatchEstimated({
    required int i,
    required int j,
    required String token,
    required double guesses,
    required double guessesLog10,
  }) : super(
          i: i,
          j: j,
          token: token,
          guesses: guesses,
          guessesLog10: guessesLog10,
        );

  @override
  SeparatorMatchEstimated estimate(String password, Options options) => this;

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) => null;
}

class Optimal {
  const Optimal({
    required this.m,
    required this.pi,
    required this.g,
  });

  // Match.
  final MatchEstimated m;

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

typedef DefaultFeedbackFunction = Feedback? Function({
  required MatchEstimated match,
  required Options options,
  bool? isSoleMatch,
});

typedef DefaultScoringFunction = DictionaryReturn Function(Match match);

abstract class MatchingType {
  List<FutureOr<List<Match>>> match(String password);
}

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
  final List<MatchEstimated> sequence;
  final int calcTime;

  @override
  String toString() => '$feedback, $crackTimesSeconds, $crackTimesDisplay, '
      '$score, $password, $guesses, $guessesLog10, $sequence, $calcTime';
}
