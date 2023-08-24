import '../../levenshtein.dart';
import '../../matchers/base_matcher.dart';
import '../../options.dart';
import '../../types.dart';
import 'variants/matching/l33t.dart';
import 'variants/matching/reverse.dart';

class MatchDictionary extends BaseMatcher {
  MatchDictionary(this.options) {
    l33t = MatchL33t(defaultMatch, options);
    reverse = MatchReverse(defaultMatch);
  }

  final Options options;
  late final MatchL33t l33t;
  late final MatchReverse reverse;

  @override
  List<List<DictionaryMatch>> match(String password) {
    final List<DictionaryMatch> matches = <DictionaryMatch>[
      ...defaultMatch(password),
      ...reverse.match(password)[0],
      ...l33t.match(password)[0],
    ];
    return <List<DictionaryMatch>>[matches];
  }

  List<DictionaryMatch> defaultMatch(
    String password, {
    bool useLevenshtein = true,
  }) {
    final List<DictionaryMatch> matches = <DictionaryMatch>[];
    final int passwordLength = password.length;
    final String passwordLower = password.toLowerCase();
    for (int i = 0; i < passwordLength; i++) {
      // Whether any dictionary has such a long word.
      bool fitsDictionaryWordSize = true;
      for (int j = i + 1; j <= passwordLength; j++) {
        if (!fitsDictionaryWordSize) break;
        fitsDictionaryWordSize = false;
        final String usedPassword = passwordLower.substring(i, j);
        DictionaryMatch? tokenMatch;
        for (final Dictionary dictionary in options.rankedDictionaries.keys) {
          final int longestDictionaryWordSize =
              options.rankedDictionariesMaxWordSize[dictionary]!;
          if (j > i + longestDictionaryWordSize) continue;
          fitsDictionaryWordSize = true;
          final RankedDictionary rankedDictionary =
              options.rankedDictionaries[dictionary]!;
          final bool isInDictionary =
              rankedDictionary.containsKey(usedPassword);
          LevenshteinDistance? distance;
          // Only use levenshtein distance on full password to minimize the
          // performance drop and because otherwise there would be to many
          // false positives.
          final bool isFullPassword = i == 0 && j == passwordLength;
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
            final DictionaryMatch match = DictionaryMatch(
              password: password,
              start: i,
              end: j,
              matchedWord: usedPassword,
              rank: rank,
              dictionary: dictionary,
              levenshteinDistance: distance?.distance,
              levenshteinDistanceEntry: distance?.entry,
              options: options,
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
    return matches;
  }
}
