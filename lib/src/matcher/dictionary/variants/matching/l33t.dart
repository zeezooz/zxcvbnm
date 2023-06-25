import '../../../../options.dart';
import '../../../../types.dart';
import '../../types.dart';
import 'unmunger/clean_password.dart';

/// Dictionary l33t matching.
class MatchL33t extends MatchingType {
  MatchL33t(this.defaultMatch, this.options);

  final DefaultMatch defaultMatch;
  final Options options;

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
      final List<DictionaryMatch> dictionaryMatches = defaultMatch(
        cleanedPassword.password,
        useLevenshtein: isFullSubstitution,
      );
      // Only the first entry has a full substitution.
      isFullSubstitution = false;
      for (final DictionaryMatch match in dictionaryMatches) {
        if (!hasFullMatch) {
          hasFullMatch = match.i == 0 && match.j == password.length - 1;
        }
        final Iterable<IndexedPasswordChange> previousChanges =
            cleanedPassword.changes.where((IndexedPasswordChange changes) {
          return changes.i < match.i;
        });
        final int i = previousChanges.fold(match.i,
            (int val, IndexedPasswordChange change) {
          return val - change.clean.length + change.l33t.length;
        });
        final Iterable<IndexedPasswordChange> usedChanges =
            cleanedPassword.changes.where((IndexedPasswordChange changes) {
          return changes.i >= match.i && changes.i <= match.j;
        });
        final int j = usedChanges.fold(match.j - match.i + i,
            (int val, IndexedPasswordChange change) {
          return val - change.clean.length + change.l33t.length;
        });
        final String token = password.substring(i, j + 1);
        final Set<String> seen = <String>{};
        // Filter duplicates.
        final List<PasswordChange> changes = <PasswordChange>[
          for (final IndexedPasswordChange change in usedChanges)
            if (seen.add('${change.l33t} -> ${change.clean}'))
              PasswordChange(
                l33t: change.l33t,
                clean: change.clean,
              )
        ];
        final L33tMatch newMatch = match.toL33tMatch(
          i: i,
          j: j,
          token: token,
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
