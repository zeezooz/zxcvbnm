import '../feedback.dart';
import '../languages/common/translation.dart';
import '../options.dart';
import 'base_matcher.dart';
import 'dictionary_matcher.dart';

/// Matches reversed words from dictionaries.
class ReverseMatcher extends BaseMatcher {
  /// Creates a matcher.
  ReverseMatcher(this.dictionaryMatcher);

  /// A matcher to check cleaned words.
  final DictionaryMatcher dictionaryMatcher;

  @override
  List<List<ReverseMatch>> match(String password) {
    final String reversedPassword = password.split('').reversed.join('');
    return <List<ReverseMatch>>[
      dictionaryMatcher
          .match(reversedPassword)[0]
          .map((DictionaryMatch match) => match.toReverseMatch())
          .where((ReverseMatch match) {
        // Ignore palindromes because they're matched as a dictionary match.
        return match.token.toLowerCase() != match.matchedWord;
      }).toList(),
    ];
  }
}

/// A match for a reversed dictionary word.
class ReverseMatch extends DictionaryMatch {
  /// Creates a match.
  ReverseMatch({
    required String password,
    required int start,
    required int end,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
  }) : super(
          password: password,
          start: start,
          end: end,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
        );

  @override
  double get extraVariations => 2;

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    Feedback? feedback = super.feedback(isSoleMatch: isSoleMatch);
    if (length >= 4) {
      feedback = Feedback(
        warning: feedback?.warning,
        suggestions: <String>[
          ...?feedback?.suggestions,
          Translation.suggestions.reverseWords,
        ],
      );
    }
    return feedback;
  }
}
