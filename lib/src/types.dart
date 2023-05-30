import 'matcher/dictionary/variants/matching/unmunger/get_clean_passwords.dart';

class TranslationKeys {
  const TranslationKeys({
    required this.warnings,
    required this.suggestions,
    required this.timeEstimation,
  });

  final TranslationKeysWarnings warnings;
  final TranslationKeysSuggestions suggestions;
  final TranslationKeysTimeEstimation timeEstimation;
}

class TranslationKeysWarnings {
  const TranslationKeysWarnings({
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

class TranslationKeysSuggestions {
  const TranslationKeysSuggestions({
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

class TranslationKeysTimeEstimation {
  const TranslationKeysTimeEstimation({
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

  /// The name of the matcher.
  final Pattern pattern;

  /// The start index of the token found in the password.
  final int i;

  /// The end index of the token found in the password.
  final int j;

  /// The token found in the password.
  final String token;

  Object? operator [](String key) {
    switch (key) {
      case 'pattern':
        return pattern;
      case 'i':
        return i;
      case 'j':
        return j;
      case 'token':
        return token;
      default:
        return null;
    }
  }
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

  @override
  Object? operator [](String key) {
    switch (key) {
      case 'matchedWord':
        return matchedWord;
      case 'rank':
        return rank;
      case 'dictionaryName':
        return dictionaryName;
      case 'reversed':
        return reversed;
      case 'l33t':
        return l33t;
      default:
        return super[key];
    }
  }
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

  @override
  Object? operator [](String key) {
    switch (key) {
      case 'subs':
        return subs;
      case 'subDisplay':
        return subDisplay;
      default:
        return super[key];
    }
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
  }) : super._(pattern: Pattern.spatial, i: i, j: j, token: token);

  final String graph;
  final int turns;
  final int shiftedCount;

  @override
  Object? operator [](String key) {
    switch (key) {
      case 'graph':
        return graph;
      case 'turns':
        return turns;
      case 'shiftedCount':
        return shiftedCount;
      default:
        return super[key];
    }
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
  }) : super._(pattern: Pattern.repeat, i: i, j: j, token: token);

  final String baseToken;
  final int baseGuesses;
  final int repeatCount;

  @override
  Object? operator [](String key) {
    switch (key) {
      case 'baseToken':
        return baseToken;
      case 'baseGuesses':
        return baseGuesses;
      case 'repeatCount':
        return repeatCount;
      default:
        return super[key];
    }
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
  }) : super._(pattern: Pattern.sequence, i: i, j: j, token: token);

  final String sequenceName;
  final int sequenceSpace;
  final bool ascending;

  @override
  Object? operator [](String key) {
    switch (key) {
      case 'sequenceName':
        return sequenceName;
      case 'sequenceSpace':
        return sequenceSpace;
      case 'ascending':
        return ascending;
      default:
        return super[key];
    }
  }
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

  @override
  Object? operator [](String key) {
    switch (key) {
      case 'regexName':
        return regexName;
      case 'regexMatch':
        return regexMatch;
      default:
        return super[key];
    }
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
  }) : super._(pattern: Pattern.date, i: i, j: j, token: token);

  final String separator;
  final int year;
  final int month;
  final int day;

  @override
  Object? operator [](String key) {
    switch (key) {
      case 'separator':
        return separator;
      case 'year':
        return year;
      case 'month':
        return month;
      case 'day':
        return day;
      default:
        return super[key];
    }
  }
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
    List<String>? suggestions,
  }) : suggestions = suggestions ?? <String>[];

  String? warning;
  List<String> suggestions;
}

class OptionsType {
  const OptionsType({
    this.translations,
  });

  /// Defines an object with a key value match to translate the feedback
  /// given by this library. The default values are plain keys so that you
  /// can use your own i18n library. Already implemented language can be
  /// found with something like @zxcvbn-ts/language-en.
  final TranslationKeys? translations;
}

typedef DefaultFeedbackFunction = FeedbackType? Function({
  required Match match,
  bool? isSoleMatch,
});
