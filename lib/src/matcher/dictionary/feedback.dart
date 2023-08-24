import '../../data/const.dart';
import '../../feedback.dart';
import '../../options.dart';
import '../../types.dart';

Feedback? dictionaryFeedback({
  required DictionaryMatch match,
  required Options options,
  required bool isSoleMatch,
}) {
  final String? warning = _dictionaryWarning(
    match: match,
    options: options,
    isSoleMatch: isSoleMatch,
  );
  final List<String> suggestions = <String>[];
  final String token = match.token;
  if (startUpper.hasMatch(token)) {
    suggestions.add(options.translation.suggestions.capitalization);
  } else if (allUpperInverted.hasMatch(token) && token.toLowerCase() != token) {
    suggestions.add(options.translation.suggestions.allUppercase);
  }
  if (match is ReverseMatch && match.length >= 4) {
    suggestions.add(options.translation.suggestions.reverseWords);
  }
  if (match is L33tMatch) suggestions.add(options.translation.suggestions.l33t);
  return Feedback(warning: warning, suggestions: suggestions);
}

String? _dictionaryWarning({
  required DictionaryMatch match,
  required Options options,
  required bool isSoleMatch,
}) {
  if (match.dictionary == Dictionary.passwords) {
    return _passwordDictionaryWarning(
      match: match,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
  if (match.dictionary == Dictionary.wikipedia) {
    return _wikipediaDictionaryWarning(
      match: match,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
  if (match.dictionary == Dictionary.lastNames ||
      match.dictionary == Dictionary.firstNames) {
    return _namesDictionaryWarning(
      match: match,
      options: options,
      isSoleMatch: isSoleMatch,
    );
  }
  if (match.dictionary == Dictionary.userInputs) {
    return options.translation.warnings.userInputs;
  }
  return null;
}

String? _passwordDictionaryWarning({
  required DictionaryMatch match,
  required Options options,
  required bool isSoleMatch,
}) {
  if (isSoleMatch && match is! L33tMatch && match is! ReverseMatch) {
    if (match.rank <= 10) return options.translation.warnings.topTen;
    if (match.rank <= 100) return options.translation.warnings.topHundred;
    return options.translation.warnings.common;
  }
  if (match.guesses <= 1e4) {
    return options.translation.warnings.similarToCommon;
  }
  return null;
}

String? _wikipediaDictionaryWarning({
  required DictionaryMatch match,
  required Options options,
  required bool isSoleMatch,
}) {
  if (isSoleMatch) return options.translation.warnings.wordByItself;
  return null;
}

String _namesDictionaryWarning({
  required DictionaryMatch match,
  required Options options,
  required bool isSoleMatch,
}) {
  if (isSoleMatch) {
    return options.translation.warnings.namesByThemselves;
  }
  return options.translation.warnings.commonNames;
}
