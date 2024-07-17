import 'dart:math';

import '../feedback.dart';
import '../options.dart';
import '../translation.dart';
import 'base_matcher.dart';
import 'dictionary_matcher.dart';
import 'utils/clean_password.dart';
import 'utils/nck.dart';

/// Matches l33t words from dictionaries.
class L33tMatcher extends BaseMatcher {
  /// Creates a matcher.
  L33tMatcher(this.options, this.dictionaryMatcher);

  /// Options.
  final Options options;

  /// A matcher to check cleaned words.
  final DictionaryMatcher dictionaryMatcher;

  @override
  List<List<L33tMatch>> match(String password) {
    final List<L33tMatch> matches = <L33tMatch>[];
    final List<PasswordWithChanges> cleanedPasswords = cleanPassword(
      password,
      options.l33tMaxSubstitutions,
      options.trieNodeRoot,
    );
    bool hasFullMatch = false;
    bool isFullSubstitution = true;
    for (final PasswordWithChanges cleanedPassword in cleanedPasswords) {
      if (hasFullMatch) break;
      final List<DictionaryMatch> dictionaryMatches = dictionaryMatcher.match(
        cleanedPassword.password,
        useLevenshtein: isFullSubstitution,
      )[0];
      // Only the first entry has a full substitution.
      isFullSubstitution = false;
      for (final DictionaryMatch match in dictionaryMatches) {
        if (!hasFullMatch) {
          hasFullMatch = match.start == 0 && match.end == password.length;
        }
        final Iterable<IndexedPasswordChange> previousChanges =
            cleanedPassword.changes.where((IndexedPasswordChange changes) {
          return changes.start < match.start;
        });
        final int i = previousChanges.fold(match.start,
            (int val, IndexedPasswordChange change) {
          return val - change.clean.length + change.l33t.length;
        });
        final Iterable<IndexedPasswordChange> usedChanges =
            cleanedPassword.changes.where((IndexedPasswordChange changes) {
          return changes.start >= match.start && changes.start < match.end;
        });
        final int j = usedChanges.fold(match.end - match.start + i,
            (int val, IndexedPasswordChange change) {
          return val - change.clean.length + change.l33t.length;
        });
        final String token = password.substring(i, j);
        final Set<String> seen = <String>{};
        // Filter duplicates.
        final List<PasswordChange> changes = <PasswordChange>[
          for (final IndexedPasswordChange change in usedChanges)
            if (seen.add('${change.l33t} -> ${change.clean}'))
              PasswordChange(
                l33t: change.l33t,
                clean: change.clean,
              ),
        ];
        final L33tMatch newMatch = match.toL33tMatch(
          password: password,
          start: i,
          end: j,
          changes: changes,
          changesDisplay: changes.join(', '),
        );
        // Ignore single-character l33t matches to reduce noise.
        // Otherwise '1' matches 'i', '4' matches 'a', both very common
        // English words with low dictionary rank.
        // Only return the matches that contain an actual substitution.
        if (token.length > 1 &&
            token.toLowerCase() != match.matchedWord &&
            !matches.any(newMatch.isDuplicateOf)) {
          matches.add(newMatch);
        }
      }
    }
    return <List<L33tMatch>>[matches];
  }
}

/// A match for a l33t dictionary word.
class L33tMatch extends DictionaryMatch {
  /// Creates a match.
  L33tMatch({
    required String password,
    required int start,
    required int end,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required this.changes,
    required this.changesDisplay,
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

  /// The changes made in the [password] to match the [matchedWord].
  final List<PasswordChange> changes;

  /// The [changes] formatted as a string.
  final String changesDisplay;

  @override
  String toString() => '${super.toString()}, changes: $changes, '
      'changesDisplay: $changesDisplay';

  /// Check if the matches are duplicates.
  bool isDuplicateOf(Object other) =>
      other is L33tMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
      changesDisplay == other.changesDisplay;

  @override
  double get extraVariations {
    double variations = 1;
    // Lower-case match.token before calculating: capitalization shouldn't
    // affect l33t calc.
    final String tokenLower = token.toLowerCase();
    for (final PasswordChange change in changes) {
      // Num of l33t entries.
      final int l33tCount = _countSubstring(tokenLower, change.l33t);
      // Num of clean entries.
      final int cleanCount = _countSubstring(tokenLower, change.clean);
      if (l33tCount == 0 || cleanCount == 0) {
        // For this change, password is either fully l33t (444) or fully
        // clean (aaa) treat that as doubling the space (attacker needs to try
        // fully l33t chars in addition to clean).
        variations *= 2;
      } else {
        // This case is similar to capitalization:
        // with aa44a, clean = 3, l33t = 2, attacker needs to try
        // clean + one l33t + two l33ts
        double possibilities = 0;
        for (int i = 1; i <= min(cleanCount, l33tCount); i++) {
          possibilities += nCk(cleanCount + l33tCount, i);
        }
        variations *= possibilities;
      }
    }
    return variations;
  }

  int _countSubstring(String string, String substring) {
    int count = 0;
    int pos = string.indexOf(substring);
    while (pos >= 0) {
      count++;
      pos = string.indexOf(substring, pos + substring.length);
    }
    return count;
  }

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    final Feedback? feedback = super.feedback(isSoleMatch: isSoleMatch);
    return Feedback(
      warning: feedback?.warning,
      suggestions: <String>[
        ...?feedback?.suggestions,
        Translation.suggestions.l33t,
      ],
    );
  }
}
