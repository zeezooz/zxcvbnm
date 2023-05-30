import 'matcher/dictionary/variants/matching/unmunger/get_clean_passwords.dart';

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
  const Match._({
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
  const DictionaryMatch({
    required int i,
    required int j,
    required String token,
    required this.matchedWord,
    required this.rank,
    required this.dictionaryName,
    required this.reversed,
    required this.l33t,
  }) : super._(pattern: Pattern.dictionary, i: i, j: j, token: token);

  final String matchedWord;
  final int rank;
  final DictionaryNames dictionaryName;
  final bool reversed;
  final bool l33t;
}

class L33tMatch extends DictionaryMatch {
  const L33tMatch({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required DictionaryNames dictionaryName,
    required bool reversed,
    required this.subs,
    required this.subDisplay,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionaryName: dictionaryName,
          reversed: reversed,
          l33t: true,
        );

  final List<PasswordChanges> subs;
  final String subDisplay;
}

class SpatialMatch extends Match {
  const SpatialMatch({
    required int i,
    required int j,
    required String token,
    required this.graph,
    required this.turns,
    required this.shiftedCount,
  }) : super._(pattern: Pattern.spatial, i: i, j: j, token: token);

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
  }) : super._(pattern: Pattern.repeat, i: i, j: j, token: token);

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
  }) : super._(pattern: Pattern.sequence, i: i, j: j, token: token);

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
  }) : super._(pattern: Pattern.regex, i: i, j: j, token: token);

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
  }) : super._(pattern: Pattern.date, i: i, j: j, token: token);

  final String separator;
  final int year;
  final int month;
  final int day;
}

class BruteForceMatch extends Match {
  const BruteForceMatch({
    required int i,
    required int j,
    required String token,
  }) : super._(pattern: Pattern.bruteforce, i: i, j: j, token: token);
}

class SeparatorMatch extends Match {
  const SeparatorMatch({
    required int i,
    required int j,
    required String token,
  }) : super._(pattern: Pattern.separator, i: i, j: j, token: token);
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
