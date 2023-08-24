import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/matching.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/matching/l33t.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

class L33tMatchTest extends L33tMatch {
  L33tMatchTest({
    required String password,
    required int start,
    required int end,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required List<PasswordChange> changes,
    required String changesDisplay,
    double? guesses,
    double? uppercaseVariations,
    double? l33tVariations,
    Options? options,
  })  : guessesTest = guesses,
        uppercaseVariationsTest = uppercaseVariations,
        l33tVariationsTest = l33tVariations,
        super(
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
          options: options ?? Options(),
        );

  final double? guessesTest;
  final double? uppercaseVariationsTest;
  final double? l33tVariationsTest;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  double get uppercaseVariations =>
      uppercaseVariationsTest ?? super.uppercaseVariations;

  @override
  double get l33tVariations => l33tVariationsTest ?? super.l33tVariations;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is L33tMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
      changes.join(',') == other.changes.join(',') &&
      changesDisplay == other.changesDisplay &&
      (guessesTest == null || guessesTest == other.guesses) &&
      (uppercaseVariationsTest == null ||
          uppercaseVariationsTest == other.uppercaseVariations) &&
      (l33tVariationsTest == null ||
          l33tVariationsTest == other.l33tVariations);
}

void main() {
  group('L33t matching.', () {
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
      "Doesn't match single-character l33ted words.",
      () => expect(
        matchL33t.match('4 1 @'),
        <List<L33tMatchTest>>[<L33tMatchTest>[]],
      ),
    );

    test(
      "Doesn't match ''.",
      () => expect(
        matchL33t.match(''),
        <List<L33tMatchTest>>[<L33tMatchTest>[]],
      ),
    );

    test(
      "Doesn't match pure dictionary words.",
      () => expect(
        matchL33t.match('password'),
        <List<L33tMatchTest>>[<L33tMatchTest>[]],
      ),
    );

    test(
      'Should match when multiple l33t substitution are needed for the same letter.',
      () {
        const String password = 'p4@ssword';
        expect(
          matchL33t.match(password),
          <List<L33tMatchTest>>[
            <L33tMatchTest>[
              L33tMatchTest(
                password: password,
                start: 0,
                end: password.length,
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
          ],
        );
      },
    );

    test(
      "Doesn't match with subsets of possible l33t substitution.",
      () => expect(
        matchL33t.match(r'P4$$w0rd'),
        <List<L33tMatchTest>>[<L33tMatchTest>[]],
      ),
    );

    test(
      'Matches against common l33t substitution.',
      () {
        expect(
          matchL33t.match('p4ssword'),
          <List<L33tMatchTest>>[
            <L33tMatchTest>[
              L33tMatchTest(
                password: 'p4ssword',
                start: 0,
                end: 8,
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
          ],
        );
        expect(
          matchL33t.match('p@@ssw0rd'),
          <List<L33tMatchTest>>[
            <L33tMatchTest>[
              L33tMatchTest(
                password: 'p@@ssw0rd',
                start: 0,
                end: 9,
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
          ],
        );
        expect(
          matchL33t.match('|_|(()mp|_|ter'),
          <List<L33tMatchTest>>[
            <L33tMatchTest>[
              L33tMatchTest(
                password: '|_|(()mp|_|ter',
                start: 3,
                end: 14,
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
          ],
        );
        expect(
          matchL33t.match('ﬁp@ciﬁc'),
          <List<L33tMatchTest>>[
            <L33tMatchTest>[
              L33tMatchTest(
                password: 'ﬁp@ciﬁc',
                start: 1,
                end: 7,
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
          ],
        );
        expect(
          matchL33t.match('aSdfO{G0asDfO'),
          <List<L33tMatchTest>>[
            <L33tMatchTest>[
              L33tMatchTest(
                password: 'aSdfO{G0asDfO',
                start: 5,
                end: 8,
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
          ],
        );
      },
    );

    test(
      'Matches against overlapping l33t patterns.',
      () => expect(
        matchL33t.match('@a(go{G0'),
        <List<L33tMatchTest>>[
          <L33tMatchTest>[
            L33tMatchTest(
              password: '@a(go{G0',
              start: 0,
              end: 3,
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
              password: '@a(go{G0',
              start: 2,
              end: 5,
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
              password: '@a(go{G0',
              start: 5,
              end: 8,
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
        ],
      ),
    );
  });
}
