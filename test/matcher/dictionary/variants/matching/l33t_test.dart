import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/matching.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/matching/l33t.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

class L33tMatchTest extends L33tMatch {
  const L33tMatchTest({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required List<PasswordChange> changes,
    required String changesDisplay,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
          changes: changes,
          changesDisplay: changesDisplay,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is L33tMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
      changes.join(',') == other.changes.join(',') &&
      changesDisplay == other.changesDisplay;
}

void main() {
  group('L33t matching.', () {
    group('Default const.', () {
      final Options options = Options();
      final MatchDictionary matchDictionary = MatchDictionary(options);
      final MatchL33t matchL33t =
          MatchL33t(matchDictionary.defaultMatch, options);

      test(
        "Doesn't match single-character l33ted words.",
        () => expect(matchL33t.match('4 1 @'), <L33tMatchTest>[]),
      );
    });

    group('Main match.', () {
      const Map<Dictionary, List<String>> dictionaries =
          <Dictionary, List<String>>{
        Dictionary.commonWords: <String>[
          'aac',
          'password',
          'paassword',
          'asdf0',
          'computer',
          'pacific',
        ],
        Dictionary.wikipedia: <String>['cgo'],
      };
      const L33tTable l33tTable = <String, List<String>>{
        'a': <String>['4', '@'],
        'c': <String>['(', '{', '[', '<'],
        'g': <String>['6', '9'],
        'o': <String>['0', '()'],
        'u': <String>['|_|'],
        'fi': <String>['ﬁ'],
      };
      final Options options = Options(
        dictionaries: dictionaries,
        l33tTable: l33tTable,
        l33tMaxSubstitutions: 15,
      );
      final MatchDictionary matchDictionary = MatchDictionary(options);
      final MatchL33t matchL33t =
          MatchL33t(matchDictionary.defaultMatch, options);

      test(
        "Doesn't match ''.",
        () => expect(matchL33t.match(''), <L33tMatchTest>[]),
      );

      test(
        "Doesn't match pure dictionary words.",
        () => expect(matchL33t.match('password'), <L33tMatchTest>[]),
      );

      test(
        'Should match when multiple l33t substitution are needed for the same letter.',
        () {
          const String password = 'p4@ssword';
          expect(
            matchL33t.match(password),
            <L33tMatchTest>[
              L33tMatchTest(
                i: 0,
                j: password.length - 1,
                token: password,
                matchedWord: 'paassword',
                rank: 3,
                dictionary: Dictionary.commonWords,
                changes: <PasswordChange>[
                  PasswordChange(
                    l33t: '4',
                    clean: 'a',
                  ),
                  PasswordChange(
                    l33t: '@',
                    clean: 'a',
                  ),
                ],
                changesDisplay: '4 -> a, @ -> a',
              ),
            ],
          );
        },
      );

      test(
        "Doesn't match with subsets of possible l33t substitution.",
        () => expect(matchL33t.match(r'P4$$w0rd'), <L33tMatchTest>[]),
      );

      test(
        'Matches against common l33t substitution.',
        () {
          expect(
            matchL33t.match('p4ssword'),
            <L33tMatchTest>[
              L33tMatchTest(
                i: 0,
                j: 7,
                token: 'p4ssword',
                matchedWord: 'password',
                rank: 2,
                dictionary: Dictionary.commonWords,
                changes: <PasswordChange>[
                  PasswordChange(
                    l33t: '4',
                    clean: 'a',
                  ),
                ],
                changesDisplay: '4 -> a',
              ),
            ],
          );
          expect(
            matchL33t.match('p@@ssw0rd'),
            <L33tMatchTest>[
              L33tMatchTest(
                i: 0,
                j: 8,
                token: 'p@@ssw0rd',
                matchedWord: 'paassword',
                rank: 3,
                dictionary: Dictionary.commonWords,
                changes: <PasswordChange>[
                  PasswordChange(
                    l33t: '@',
                    clean: 'a',
                  ),
                  PasswordChange(
                    l33t: '0',
                    clean: 'o',
                  ),
                ],
                changesDisplay: '@ -> a, 0 -> o',
              ),
            ],
          );
          expect(
            matchL33t.match('|_|(()mp|_|ter'),
            <L33tMatchTest>[
              L33tMatchTest(
                i: 3,
                j: 13,
                token: '(()mp|_|ter',
                matchedWord: 'computer',
                rank: 5,
                dictionary: Dictionary.commonWords,
                changes: <PasswordChange>[
                  PasswordChange(
                    l33t: '(',
                    clean: 'c',
                  ),
                  PasswordChange(
                    l33t: '()',
                    clean: 'o',
                  ),
                  PasswordChange(
                    l33t: '|_|',
                    clean: 'u',
                  ),
                ],
                changesDisplay: '( -> c, () -> o, |_| -> u',
              ),
            ],
          );
          expect(
            matchL33t.match('ﬁp@ciﬁc'),
            <L33tMatchTest>[
              L33tMatchTest(
                i: 1,
                j: 6,
                token: 'p@ciﬁc',
                matchedWord: 'pacific',
                rank: 6,
                dictionary: Dictionary.commonWords,
                changes: <PasswordChange>[
                  PasswordChange(
                    l33t: '@',
                    clean: 'a',
                  ),
                  PasswordChange(
                    l33t: 'ﬁ',
                    clean: 'fi',
                  ),
                ],
                changesDisplay: '@ -> a, ﬁ -> fi',
              ),
            ],
          );
          expect(
            matchL33t.match('aSdfO{G0asDfO'),
            <L33tMatchTest>[
              L33tMatchTest(
                i: 5,
                j: 7,
                token: '{G0',
                matchedWord: 'cgo',
                rank: 1,
                dictionary: Dictionary.wikipedia,
                changes: <PasswordChange>[
                  PasswordChange(
                    l33t: '{',
                    clean: 'c',
                  ),
                  PasswordChange(
                    l33t: '0',
                    clean: 'o',
                  ),
                ],
                changesDisplay: '{ -> c, 0 -> o',
              ),
            ],
          );
        },
      );

      test(
        'Matches against overlapping l33t patterns.',
        () => expect(
          matchL33t.match('@a(go{G0'),
          <L33tMatchTest>[
            L33tMatchTest(
              i: 0,
              j: 2,
              token: '@a(',
              matchedWord: 'aac',
              rank: 1,
              dictionary: Dictionary.commonWords,
              changes: <PasswordChange>[
                PasswordChange(
                  l33t: '@',
                  clean: 'a',
                ),
                PasswordChange(
                  l33t: '(',
                  clean: 'c',
                ),
              ],
              changesDisplay: '@ -> a, ( -> c',
            ),
            L33tMatchTest(
              i: 2,
              j: 4,
              token: '(go',
              matchedWord: 'cgo',
              rank: 1,
              dictionary: Dictionary.wikipedia,
              changes: <PasswordChange>[
                PasswordChange(
                  l33t: '(',
                  clean: 'c',
                ),
              ],
              changesDisplay: '( -> c',
            ),
            L33tMatchTest(
              i: 5,
              j: 7,
              token: '{G0',
              matchedWord: 'cgo',
              rank: 1,
              dictionary: Dictionary.wikipedia,
              changes: <PasswordChange>[
                PasswordChange(
                  l33t: '{',
                  clean: 'c',
                ),
                PasswordChange(
                  l33t: '0',
                  clean: 'o',
                ),
              ],
              changesDisplay: '{ -> c, 0 -> o',
            ),
          ],
        ),
      );
    });
  });
}
