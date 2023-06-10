import 'dart:math';

import '../../helper.dart';
import '../../levenshtein.dart';
import '../../options.dart';
import '../../types.dart';
import 'variants/matching/l33t.dart';
import 'variants/matching/reverse.dart';

class MatchDictionary {
  MatchDictionary(this.options) {
    l33t = MatchL33t(defaultMatch, options);
    reverse = MatchReverse(defaultMatch);
  }

  final Options options;
  late final MatchL33t l33t;
  late final MatchReverse reverse;

  List<DictionaryMatch> match(String password) {
    final List<DictionaryMatch> matches = <DictionaryMatch>[
      ...defaultMatch(password),
      ...reverse.match(password),
      ...l33t.match(password),
    ];
    sort(matches);
    return matches;
  }

  List<DictionaryMatch> defaultMatch(
    String password, {
    bool useLevenshtein = true,
  }) {
    final List<DictionaryMatch> matches = <DictionaryMatch>[];
    final int passwordLength = password.length;
    final String passwordLower = password.toLowerCase();
    for (final Dictionary dictionary in options.rankedDictionaries.keys) {
      final RankedDictionary rankedDictionary =
          options.rankedDictionaries[dictionary]!;
      final int longestDictionaryWordSize =
          options.rankedDictionariesMaxWordSize[dictionary]!;
      final int searchWidth = min(longestDictionaryWordSize, passwordLength);
      for (int i = 0; i < passwordLength; i += 1) {
        for (int j = i; j < i + searchWidth && j < passwordLength; j += 1) {
          final String usedPassword = passwordLower.substring(i, j + 1);
          final bool isInDictionary =
              rankedDictionary.containsKey(usedPassword);
          LevenshteinDistance? distance;
          // Only use levenshtein distance on full password to minimize the
          // performance drop and because otherwise there would be to many
          // false positives.
          final bool isFullPassword = i == 0 && j == passwordLength - 1;
          if (options.useLevenshteinDistance &&
              isFullPassword &&
              !isInDictionary &&
              useLevenshtein) {
            distance = levenshteinDistance(
              usedPassword,
              rankedDictionary,
              options.levenshteinThreshold,
            );
          }
          final bool isLevenshteinMatch = distance != null;
          if (isInDictionary || isLevenshteinMatch) {
            final String usedRankPassword =
                isLevenshteinMatch ? distance.entry : usedPassword;
            final int rank = rankedDictionary[usedRankPassword]!;
            matches.add(
              DictionaryMatch(
                i: i,
                j: j,
                token: password.substring(i, j + 1),
                matchedWord: usedPassword,
                rank: rank,
                dictionary: dictionary,
                levenshteinDistance: distance?.distance,
                levenshteinDistanceEntry: distance?.entry,
              ),
            );
          }
        }
      }
    }
    return matches;
  }
}
