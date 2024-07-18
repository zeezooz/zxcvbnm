import 'package:test/test.dart';
import 'package:zxcvbnm/src/matchers/dictionary_matcher.dart';
import 'package:zxcvbnm/src/matchers/l33t_matcher.dart';
import 'package:zxcvbnm/src/matchers/utils/clean_password.dart';
import 'package:zxcvbnm/src/matchers/utils/nck.dart';
import 'package:zxcvbnm/src/options.dart';

void main() {
  group('L33tMatcher.', () {
    const Set<Dictionaries> dictionaries = <Dictionaries>{
      <Dictionary, List<String>>{
        Dictionary.commonWords: <String>[
          'aac',
          'password',
          'paassword',
          'asdf0',
          'computer',
          'pacific',
        ],
      },
      <Dictionary, List<String>>{
        Dictionary.wikipedia: <String>['cgo'],
      },
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
    final L33tMatcher matchL33t =
        L33tMatcher(options, DictionaryMatcher(options));

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
      'Should match when multiple l33t substitution are needed for the same '
      'letter.',
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
                  const PasswordChange(
                    l33t: '4',
                    clean: 'a',
                  ),
                  const PasswordChange(
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
                  const PasswordChange(
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
                  const PasswordChange(
                    l33t: '@',
                    clean: 'a',
                  ),
                  const PasswordChange(
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
                  const PasswordChange(
                    l33t: '(',
                    clean: 'c',
                  ),
                  const PasswordChange(
                    l33t: '()',
                    clean: 'o',
                  ),
                  const PasswordChange(
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
                  const PasswordChange(
                    l33t: '@',
                    clean: 'a',
                  ),
                  const PasswordChange(
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
                  const PasswordChange(
                    l33t: '{',
                    clean: 'c',
                  ),
                  const PasswordChange(
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
                const PasswordChange(
                  l33t: '@',
                  clean: 'a',
                ),
                const PasswordChange(
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
                const PasswordChange(
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
                const PasswordChange(
                  l33t: '{',
                  clean: 'c',
                ),
                const PasswordChange(
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

  group('L33tMatch guesses.', () {
    test(
      'Common l33t substitutions.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'aaa@@@',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '@', clean: 'a'),
          ],
          changesDisplay: '@ -> a',
        );
        expect(
          match.estimatedGuesses,
          32 * match.extraVariations,
        );
      },
    );

    test(
      'Both capitalization and common l33t substitutions.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'AaA@@@',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '@', clean: 'a'),
          ],
          changesDisplay: '@ -> a',
        );
        expect(
          match.estimatedGuesses,
          32 * match.uppercaseVariations * match.extraVariations,
        );
      },
    );

    test(
      "Extra l33t guesses of ''.",
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: '',
          start: 0,
          end: 0,
          matchedWord: '',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          match.extraVariations,
          1,
        );
      },
    );

    test(
      'Extra l33t guesses of a.',
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: 'a',
          start: 0,
          end: 1,
          matchedWord: 'a',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          match.extraVariations,
          1,
        );
      },
    );

    test(
      'Extra l33t guesses of 4.',
      () {
        final L33tMatch match = L33tMatch(
          password: '4',
          start: 0,
          end: 1,
          matchedWord: 'a',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '4', clean: 'a'),
          ],
          changesDisplay: '4 -> a',
        );
        expect(
          match.extraVariations,
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of 4pple.',
      () {
        final L33tMatch match = L33tMatch(
          password: '4pple',
          start: 0,
          end: 5,
          matchedWord: 'apple',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '4', clean: 'a'),
          ],
          changesDisplay: '4 -> a',
        );
        expect(
          match.extraVariations,
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of abcet.',
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: 'abcet',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          match.extraVariations,
          1,
        );
      },
    );

    test(
      'Extra l33t guesses of 4bcet.',
      () {
        final L33tMatch match = L33tMatch(
          password: '4bcet',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '4', clean: 'a'),
          ],
          changesDisplay: '4 -> a',
        );
        expect(
          match.extraVariations,
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of a8cet.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'a8cet',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '8', clean: 'b'),
          ],
          changesDisplay: '8 -> b',
        );
        expect(
          match.extraVariations,
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of abce+.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'abce+',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '+', clean: 't'),
          ],
          changesDisplay: '+ -> t',
        );
        expect(
          match.extraVariations,
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of 48cet.',
      () {
        final L33tMatch match = L33tMatch(
          password: '48cet',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '4', clean: 'a'),
            const PasswordChange(l33t: '8', clean: 'b'),
          ],
          changesDisplay: '4 -> a, 8 -> b',
        );
        expect(
          match.extraVariations,
          4,
        );
      },
    );

    test(
      'Extra l33t guesses of a4a4aa.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'a4a4aa',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '4', clean: 'a'),
          ],
          changesDisplay: '4 -> a',
        );
        expect(
          match.extraVariations,
          nCk(6, 2) + nCk(6, 1),
        );
      },
    );

    test(
      'Extra l33t guesses of 4a4a44.',
      () {
        final L33tMatch match = L33tMatch(
          password: '4a4a44',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '4', clean: 'a'),
          ],
          changesDisplay: '4 -> a',
        );
        expect(
          match.extraVariations,
          nCk(6, 2) + nCk(6, 1),
        );
      },
    );

    test(
      'Extra l33t guesses of a44att+.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'a44att+',
          start: 0,
          end: 7,
          matchedWord: 'aaaattt',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '4', clean: 'a'),
            const PasswordChange(l33t: '+', clean: 't'),
          ],
          changesDisplay: '4 -> a, + -> t',
        );
        expect(
          match.extraVariations,
          (nCk(4, 2) + nCk(4, 1)) * nCk(3, 1),
        );
      },
    );

    test(
      'Extra l33t guesses of wwwpassvvord.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'wwwpassvvord',
          start: 0,
          end: 12,
          matchedWord: 'wwwpassword',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: 'vv', clean: 'w'),
          ],
          changesDisplay: 'vv -> w',
        );
        expect(
          match.extraVariations,
          nCk(4, 1),
        );
      },
    );

    test(
      "Capitalization doesn't affect extra l33t guesses.",
      () {
        final L33tMatch match = L33tMatch(
          password: 'Aa44aA',
          start: 0,
          end: 6,
          matchedWord: 'AaaaaA',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            const PasswordChange(l33t: '4', clean: 'a'),
          ],
          changesDisplay: '4 -> a',
        );
        expect(
          match.extraVariations,
          nCk(6, 2) + nCk(6, 1),
        );
      },
    );
  });
}

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
    double? extraVariations,
  })  : guessesTest = guesses,
        uppercaseVariationsTest = uppercaseVariations,
        extraVariationsTest = extraVariations,
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
        );

  final double? guessesTest;
  final double? uppercaseVariationsTest;
  final double? extraVariationsTest;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  double get uppercaseVariations =>
      uppercaseVariationsTest ?? super.uppercaseVariations;

  @override
  double get extraVariations => extraVariationsTest ?? super.extraVariations;

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
      (extraVariationsTest == null ||
          extraVariationsTest == other.extraVariations);
}
