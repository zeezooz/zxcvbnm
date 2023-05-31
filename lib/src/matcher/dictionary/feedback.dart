import '../../data/const.dart';
import '../../options.dart';
import '../../types.dart';

String? getDictionaryWarningPassword({
  required DictionaryMatchEstimated match,
  bool? isSoleMatch,
}) {
  if ((isSoleMatch ?? false) && !match.l33t && !match.reversed) {
    if (match.rank <= 10) return options.translations.warnings.topTen;
    if (match.rank <= 100) return options.translations.warnings.topHundred;
    return options.translations.warnings.common;
  }
  if (match.guessesLog10 <= 4) {
    return options.translations.warnings.similarToCommon;
  }
  return null;
}

String? getDictionaryWarningWikipedia({
  required DictionaryMatchEstimated match,
  bool? isSoleMatch,
}) {
  if (isSoleMatch ?? false) return options.translations.warnings.wordByItself;
  return null;
}

String getDictionaryWarningNames({
  required DictionaryMatchEstimated match,
  bool? isSoleMatch,
}) {
  if (isSoleMatch ?? false) {
    return options.translations.warnings.namesByThemselves;
  }
  return options.translations.warnings.commonNames;
}

String? getDictionaryWarning({
  required DictionaryMatchEstimated match,
  bool? isSoleMatch,
}) {
  final DictionaryNames dictName = match.dictionaryName;
  final bool isAName = dictName == DictionaryNames.lastnames ||
      dictName == DictionaryNames.firstnames;
  if (dictName == DictionaryNames.passwords) {
    return getDictionaryWarningPassword(match: match, isSoleMatch: isSoleMatch);
  }
  if (dictName == DictionaryNames.wikipedia) {
    return getDictionaryWarningWikipedia(
      match: match,
      isSoleMatch: isSoleMatch,
    );
  }
  if (isAName) {
    return getDictionaryWarningNames(match: match, isSoleMatch: isSoleMatch);
  }
  if (dictName == DictionaryNames.userInputs) {
    return options.translations.warnings.userInputs;
  }
  return null;
}

FeedbackType? dictionaryFeedback({
  required DictionaryMatchEstimated match,
  bool? isSoleMatch,
}) {
  final String? warning =
      getDictionaryWarning(match: match, isSoleMatch: isSoleMatch);
  final List<String> suggestions = <String>[];
  final String word = match.token;
  if (startUpper.hasMatch(word)) {
    suggestions.add(options.translations.suggestions.capitalization);
  } else if (allUpperInverted.hasMatch(word) && word.toLowerCase() != word) {
    suggestions.add(options.translations.suggestions.allUppercase);
  }
  if (match.reversed && match.token.length >= 4) {
    suggestions.add(options.translations.suggestions.reverseWords);
  }
  if (match.l33t) suggestions.add(options.translations.suggestions.l33t);
  return FeedbackType(warning: warning, suggestions: suggestions);
}
