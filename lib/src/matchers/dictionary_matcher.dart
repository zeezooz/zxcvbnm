import 'dart:math';

import '../feedback.dart';
import '../languages/common/translation.dart';
import '../options.dart';
import '../types.dart';
import 'base_matcher.dart';
import 'l33t_matcher.dart';
import 'reverse_matcher.dart';
import 'utils/clean_password.dart';
import 'utils/levenshtein.dart';
import 'utils/nck.dart';

/// Matches words from dictionaries.
class DictionaryMatcher extends BaseMatcher {
  /// Creates a matcher.
  DictionaryMatcher(this.options);

  /// Options.
  final Options options;

  @override
  List<List<DictionaryMatch>> match(
    String password, {
    bool useLevenshtein = true,
  }) {
    final List<DictionaryMatch> matches = <DictionaryMatch>[];
    final String passwordLower = password.toLowerCase();
    for (int start = 0; start < password.length; start++) {
      // Whether any dictionary has such a long word.
      bool fitsDictionaryWordSize = true;
      for (int end = start + 1; end <= password.length; end++) {
        if (!fitsDictionaryWordSize) break;
        fitsDictionaryWordSize = false;
        final String usedPassword = passwordLower.substring(start, end);
        DictionaryMatch? tokenMatch;
        for (final Dictionary dictionary in options.rankedDictionaries.keys) {
          final int longestDictionaryWordSize =
              options.rankedDictionariesMaxWordSize[dictionary]!;
          if (end > start + longestDictionaryWordSize) continue;
          fitsDictionaryWordSize = true;
          final RankedDictionary rankedDictionary =
              options.rankedDictionaries[dictionary]!;
          final bool isInDictionary =
              rankedDictionary.containsKey(usedPassword);
          LevenshteinDistance? distance;
          // Only use levenshtein distance on full password to minimize the
          // performance drop and because otherwise there would be to many
          // false positives.
          final bool isFullPassword = start == 0 && end == password.length;
          if (options.useLevenshteinDistance &&
              isFullPassword &&
              !isInDictionary &&
              useLevenshtein) {
            distance = levenshteinDistance(
              usedPassword,
              rankedDictionary.keys,
              options.levenshteinThreshold,
            );
          }
          final bool isLevenshteinMatch = distance != null;
          if (isInDictionary || isLevenshteinMatch) {
            final String usedRankPassword =
                isLevenshteinMatch ? distance.entry : usedPassword;
            final int rank = rankedDictionary[usedRankPassword]!;
            final DictionaryMatch match = DictionaryMatch(
              password: password,
              start: start,
              end: end,
              matchedWord: usedPassword,
              rank: rank,
              dictionary: dictionary,
              levenshteinDistance: distance?.distance,
              levenshteinDistanceEntry: distance?.entry,
            );
            if (dictionary == Dictionary.diceware) {
              // Always include matches from diceware because they're scored
              // differently.
              matches.add(match);
            } else if (tokenMatch == null || tokenMatch.rank > match.rank) {
              tokenMatch = match;
            }
          }
        }
        if (tokenMatch != null) matches.add(tokenMatch);
      }
    }
    return <List<DictionaryMatch>>[matches];
  }
}

/// A match for a dictionary word.
class DictionaryMatch extends BaseMatch {
  /// Creates a match.
  DictionaryMatch({
    required String password,
    required int start,
    required int end,
    required this.matchedWord,
    required this.rank,
    required this.dictionary,
    this.levenshteinDistance,
    this.levenshteinDistanceEntry,
  }) : super(password: password, start: start, end: end);

  /// The matched word.
  final String matchedWord;

  /// The frequency rank of the [matchedWord].
  final int rank;

  /// The dictionary containing the [matchedWord].
  final Dictionary dictionary;

  /// The Levenshtein distance between the [matchedWord] and
  /// the [levenshteinDistanceEntry].
  final int? levenshteinDistance;

  /// The word from the [dictionary] used to calculate
  /// the [levenshteinDistance].
  final String? levenshteinDistanceEntry;

  /// Converts the match to a [ReverseMatch].
  ReverseMatch toReverseMatch() => ReverseMatch(
        password: password.split('').reversed.join(''),
        start: password.length - end,
        end: password.length - start,
        matchedWord: matchedWord,
        rank: rank,
        dictionary: dictionary,
        levenshteinDistance: levenshteinDistance,
        levenshteinDistanceEntry: levenshteinDistanceEntry,
      );

  /// Converts the match to a [L33tMatch].
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
      );

  @override
  double get estimatedGuesses {
    // Diceware dictionaries are special, so we get a simple scoring of
    // 1/2 of 6^5 (6 digits on 5 dice).
    // To get fix entropy of ~12.9 bits for every entry
    // https://en.wikipedia.org/wiki/Diceware#:~:text=The%20level%20of,bits
    if (dictionary == Dictionary.diceware) return pow(6, 5) / 2;
    return rank * uppercaseVariations * extraVariations;
  }

  /// Guess multiplier for capital letters.
  double get uppercaseVariations {
    // Clean words of non alpha characters to remove the reward effect to
    // capitalize the first letter https://github.com/dropbox/zxcvbn/issues/232
    final String cleanedWord = token.replaceAll(_alphaInverted, '');
    if (_allLowerInverted.hasMatch(cleanedWord) ||
        cleanedWord.toLowerCase() == cleanedWord) {
      return 1;
    }
    // A capitalized word is the most common capitalization scheme,
    // so it only doubles the search space (uncapitalized + capitalized).
    // All caps and end-capitalized are common enough too, underestimate as 2x
    // factor to be safe.
    final List<RegExp> commonCases = <RegExp>[
      _startUpper,
      _endUpper,
      _allUpperInverted,
    ];
    for (final RegExp regExp in commonCases) {
      if (regExp.hasMatch(cleanedWord)) return 2;
    }
    // Otherwise calculate the number of ways to capitalize uppercase+lowercase
    // letters with upperCaseCount uppercase letters or less. Or, if there's
    // more uppercase than lower (for eg. PASSwORD), the number of ways to
    // lowercase uppercase+lowercase letters with lowerCaseCount lowercase
    // letters or less.
    final int upperCaseCount = _oneUpper.allMatches(cleanedWord).length;
    final int lowerCaseCount = _oneLower.allMatches(cleanedWord).length;
    double variations = 0;
    for (int i = 1; i <= min(upperCaseCount, lowerCaseCount); i++) {
      variations += nCk(upperCaseCount + lowerCaseCount, i);
    }
    return variations;
  }

  // \xbf-\xdf is a range for almost all special uppercase letter like Ä and so on
  final RegExp _alphaInverted =
      RegExp(r'[^A-Za-z\xbf-\xdf]', caseSensitive: false);
  final RegExp _allLowerInverted = RegExp(r'^[^A-Z\xbf-\xdf]+$');
  final RegExp _startUpper = RegExp(r'^[A-Z\xbf-\xdf][^A-Z\xbf-\xdf]+$');
  final RegExp _endUpper = RegExp(r'^[^A-Z\xbf-\xdf]+[A-Z\xbf-\xdf]$');
  // \xdf-\xff is a range for almost all special lowercase letter like ä and so on
  final RegExp _allUpperInverted = RegExp(r'^[^a-z\xdf-\xff]+$');
  final RegExp _oneUpper = RegExp(r'[A-Z\xbf-\xdf]');
  final RegExp _oneLower = RegExp(r'[a-z\xdf-\xff]');

  /// Optional guess multiplier.
  double get extraVariations => 1;

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    final String? warning;
    switch (dictionary) {
      case Dictionary.diceware:
      case Dictionary.commonWords:
        warning = null;
        break;
      case Dictionary.passwords:
        if (isSoleMatch && this is! L33tMatch && this is! ReverseMatch) {
          if (rank <= 10) {
            warning = Translation.warnings.topTen;
          } else if (rank <= 100) {
            warning = Translation.warnings.topHundred;
          } else {
            warning = Translation.warnings.common;
          }
        } else if (guesses <= 1e4) {
          warning = Translation.warnings.similarToCommon;
        } else {
          warning = null;
        }
        break;
      case Dictionary.names:
        warning = isSoleMatch
            ? Translation.warnings.namesByThemselves
            : Translation.warnings.commonNames;
        break;
      case Dictionary.wikipedia:
        warning = isSoleMatch ? Translation.warnings.wordByItself : null;
        break;
      case Dictionary.userInputs:
        warning = Translation.warnings.userInputs;
        break;
    }
    final List<String> suggestions;
    if (_startUpper.hasMatch(token)) {
      suggestions = <String>[Translation.suggestions.capitalization];
    } else if (_allUpperInverted.hasMatch(token) &&
        token.toLowerCase() != token) {
      suggestions = <String>[Translation.suggestions.allUppercase];
    } else {
      suggestions = const <String>[];
    }
    return Feedback(warning: warning, suggestions: suggestions);
  }

  @override
  String toString() => '${super.toString()}, '
      'uppercaseVariations: $uppercaseVariations, '
      'extraVariations: $extraVariations, matchedWord: "$matchedWord", '
      'rank: $rank, dictionary: $dictionary, '
      'levenshteinDistance: $levenshteinDistance, '
      'levenshteinDistanceEntry: $levenshteinDistanceEntry';
}
