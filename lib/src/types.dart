import 'matcher/dictionary/variants/matching/unmunger/getCleanPasswords.dart';

typedef TranslationKeys = Map<String, Map<String, String>>;
typedef L33tTableDefault = Map<String, List<String>>;

enum Pattern {
  dictionary,
  spatial,
  repeat,
  sequence,
  regex,
  date,
  bruteforce,
  separator,
}

enum DictionaryNames {
  passwords,
  commonWords,
  firstnames,
  lastnames,
  wikipedia,
  userInputs,
}

class Match {
  Match._({
    required this.pattern,
    required this.i,
    required this.j,
    required this.token,
  });

  /// The name of the matcher
  final Pattern pattern;

  /// The start index of the token found in the password
  final int i;

  /// The end index of the token found in the password
  final int j;

  /// The token found in the password
  final String token;
}

class DictionaryMatch extends Match {
  DictionaryMatch({
    required super.i,
    required super.j,
    required super.token,
    required this.matchedWord,
    required this.rank,
    required this.dictionaryName,
    required this.reversed,
    required this.l33t,
  }) : super._(pattern: Pattern.dictionary);

  final String matchedWord;
  final int rank;
  final DictionaryNames dictionaryName;
  final bool reversed;
  final bool l33t;
}

class L33tMatch extends DictionaryMatch {
  L33tMatch({
    required super.i,
    required super.j,
    required super.token,
    required super.matchedWord,
    required super.rank,
    required super.dictionaryName,
    required super.reversed,
    required this.subs,
    required this.subDisplay,
  }) : super(l33t: true);

  final List<PasswordChanges> subs;
  final String subDisplay;
}

class SpatialMatch extends Match {
  SpatialMatch({
    required super.i,
    required super.j,
    required super.token,
    required this.graph,
    required this.turns,
    required this.shiftedCount,
  }) : super._(pattern: Pattern.spatial);

  final String graph;
  final int turns;
  final int shiftedCount;
}

class RepeatMatch extends Match {
  RepeatMatch({
    required super.i,
    required super.j,
    required super.token,
    required this.baseToken,
    required this.baseGuesses,
    required this.repeatCount,
  }) : super._(pattern: Pattern.repeat);

  final String baseToken;
  final int baseGuesses;
  final int repeatCount;
}

class SequenceMatch extends Match {
  SequenceMatch({
    required super.i,
    required super.j,
    required super.token,
    required this.sequenceName,
    required this.sequenceSpace,
    required this.ascending,
  }) : super._(pattern: Pattern.sequence);

  final String sequenceName;
  final int sequenceSpace;
  final bool ascending;
}

class RegexMatch extends Match {
  RegexMatch({
    required super.i,
    required super.j,
    required super.token,
    required this.regexName,
    required this.regexMatch,
  }) : super._(pattern: Pattern.regex);

  final String regexName;
  final List<String> regexMatch;
}

class DateMatch extends Match {
  DateMatch({
    required super.i,
    required super.j,
    required super.token,
    required this.separator,
    required this.year,
    required this.month,
    required this.day,
  }) : super._(pattern: Pattern.date);

  final String separator;
  final int year;
  final int month;
  final int day;
}

class BruteForceMatch extends Match {
  BruteForceMatch({
    required super.i,
    required super.j,
    required super.token,
  }) : super._(pattern: Pattern.bruteforce);
}

class SeparatorMatch extends Match {
  SeparatorMatch({
    required super.i,
    required super.j,
    required super.token,
  }) : super._(pattern: Pattern.separator);
}

class FeedbackType {
  FeedbackType({
    this.warning,
    required this.suggestions,
  });

  String? warning;
  List<String> suggestions;
}

typedef DefaultFeedbackFunction = FeedbackType? Function({
  required Match match,
  required bool isSoleMatch,
});
