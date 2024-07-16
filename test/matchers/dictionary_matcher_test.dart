import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/matchers/dictionary_matcher.dart';
import 'package:zxcvbnm/src/matchers/utils/nck.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

import '../helpers/generate_passwords.dart';

void main() {
  group('DictionaryMatcher.', () {
    group('Default dictionaries.', () {
      final Options options = Options(dictionaries: dictionaries);
      final DictionaryMatcher dictionaryMatcher = DictionaryMatcher(options);

      test(
        'Default dictionaries.',
        () => expect(
          dictionaryMatcher.match('we'),
          <List<DictionaryMatch>>[
            <DictionaryMatch>[
              DictionaryMatchTest(
                password: 'we',
                start: 0,
                end: 2,
                matchedWord: 'we',
                rank: 13,
                dictionary: Dictionary.commonWords,
              ),
            ],
          ],
        ),
      );

      test(
        'Default dictionaries with duplicates.',
        () => expect(
          dictionaryMatcher.match('elk'),
          <List<DictionaryMatch>>[
            <DictionaryMatch>[
              DictionaryMatchTest(
                password: 'elk',
                start: 0,
                end: 2,
                matchedWord: 'el',
                rank: 2967,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                password: 'elk',
                start: 0,
                end: 3,
                matchedWord: 'elk',
                rank: 2167,
                dictionary: Dictionary.diceware,
              ),
              DictionaryMatchTest(
                password: 'elk',
                start: 0,
                end: 3,
                matchedWord: 'elk',
                rank: 16651,
                dictionary: Dictionary.commonWords,
              ),
            ],
          ],
        ),
      );
    });

    group('Without user input.', () {
      final Options options = Options(
        dictionaries: <Dictionary, List<String>>{
          Dictionary.commonWords: <String>[
            'motherboard',
            'mother',
            'board',
            'abcd',
            'cdef',
          ],
          Dictionary.passwords: <String>['z', '8', '99', r'$', 'asdf1234&*'],
        },
      );
      final DictionaryMatcher dictionaryMatcher = DictionaryMatcher(options);

      test(
        'Matches words that contain other words.',
        () => expect(
          dictionaryMatcher.match('motherboard'),
          <List<DictionaryMatch>>[
            <DictionaryMatch>[
              DictionaryMatchTest(
                password: 'motherboard',
                start: 0,
                end: 6,
                matchedWord: 'mother',
                rank: 2,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                password: 'motherboard',
                start: 0,
                end: 11,
                matchedWord: 'motherboard',
                rank: 1,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                password: 'motherboard',
                start: 6,
                end: 11,
                matchedWord: 'board',
                rank: 3,
                dictionary: Dictionary.commonWords,
              ),
            ],
          ],
        ),
      );

      test(
        'Matches multiple words when they overlap.',
        () => expect(
          dictionaryMatcher.match('abcdef'),
          <List<DictionaryMatch>>[
            <DictionaryMatch>[
              DictionaryMatchTest(
                password: 'abcdef',
                start: 0,
                end: 4,
                matchedWord: 'abcd',
                rank: 4,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                password: 'abcdef',
                start: 2,
                end: 6,
                matchedWord: 'cdef',
                rank: 5,
                dictionary: Dictionary.commonWords,
              ),
            ],
          ],
        ),
      );

      test(
        'Ignores uppercase.',
        () => expect(
          dictionaryMatcher.match('BoaRdZ'),
          <List<DictionaryMatch>>[
            <DictionaryMatch>[
              DictionaryMatchTest(
                password: 'BoaRdZ',
                start: 0,
                end: 5,
                matchedWord: 'board',
                rank: 3,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                password: 'BoaRdZ',
                start: 5,
                end: 6,
                matchedWord: 'z',
                rank: 1,
                dictionary: Dictionary.passwords,
              ),
            ],
          ],
        ),
      );

      test(
        'Identifies words surrounded by non-words.',
        () {
          const List<String> prefixes = <String>['q', '%%'];
          const List<String> suffixes = <String>['%', 'qq'];
          const String token = 'asdf1234&*';
          final List<IndexedPassword> passwords =
              generatePasswords(token, prefixes, suffixes);
          for (final IndexedPassword password in passwords) {
            expect(
              dictionaryMatcher.match(password.password),
              <List<DictionaryMatch>>[
                <DictionaryMatch>[
                  DictionaryMatchTest(
                    password: password.password,
                    start: password.start,
                    end: password.end,
                    matchedWord: token,
                    rank: 5,
                    dictionary: Dictionary.passwords,
                  ),
                ],
              ],
            );
          }
        },
      );

      test(
        'Matches against all words in provided dictionaries.',
        () {
          options.rankedDictionaries.forEach(
              (Dictionary dictionary, RankedDictionary rankedDictionary) {
            rankedDictionary.forEach((String word, int rank) {
              if (word == 'motherboard') return;
              expect(
                dictionaryMatcher.match(word),
                <List<DictionaryMatch>>[
                  <DictionaryMatch>[
                    DictionaryMatchTest(
                      password: word,
                      start: 0,
                      end: word.length,
                      matchedWord: word,
                      rank: rank,
                      dictionary: dictionary,
                    ),
                  ],
                ],
              );
            });
          });
        },
      );
    });

    group('With user input.', () {
      final Options options = Options(
        dictionaries: <Dictionary, List<Object>>{
          Dictionary.userInputs: <String>['foo', 'bar'],
        },
      );
      final DictionaryMatcher dictionaryMatcher = DictionaryMatcher(options);

      test(
        'Matches with provided user input dictionary.',
        () {
          expect(
            dictionaryMatcher.match('foobar'),
            <List<DictionaryMatch>>[
              <DictionaryMatch>[
                DictionaryMatchTest(
                  password: 'foobar',
                  start: 0,
                  end: 3,
                  matchedWord: 'foo',
                  rank: 1,
                  dictionary: Dictionary.userInputs,
                ),
                DictionaryMatchTest(
                  password: 'foobar',
                  start: 3,
                  end: 6,
                  matchedWord: 'bar',
                  rank: 2,
                  dictionary: Dictionary.userInputs,
                ),
              ],
            ],
          );
        },
      );
    });

    group('Uppercase scoring.', () {
      final List<List<Object>> data = <List<Object>>[
        <Object>['', 1],
        <Object>['a', 1],
        <Object>['A', 2],
        <Object>['abcdef', 1],
        <Object>['Abcdef', 2],
        <Object>['abcdeF', 2],
        <Object>['ABCDEF', 2],
        <Object>['aBcdef', nCk(6, 1)],
        <Object>['aBcDef', nCk(6, 1) + nCk(6, 2)],
        <Object>['ABCDEf', nCk(6, 1)],
        <Object>['aBCDEf', nCk(6, 1) + nCk(6, 2)],
        <Object>['ABCdef', nCk(6, 1) + nCk(6, 2) + nCk(6, 3)],
      ];
      for (final List<Object> item in data) {
        final String token = item[0] as String;
        final num score = item[1] as num;
        test(
          "Guess multiplier of '$token'.",
          () {
            final DictionaryMatch match = DictionaryMatch(
              password: token,
              start: 0,
              end: token.length,
              matchedWord: token,
              rank: 1,
              dictionary: Dictionary.commonWords,
            );
            expect(
              match.uppercaseVariations,
              score,
            );
          },
        );
      }
    });
  });

  group('DictionaryMatch guesses.', () {
    test(
      'Base guesses.',
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: 'aaaaa',
          start: 0,
          end: 5,
          matchedWord: 'aaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
        );
        expect(
          match.estimatedGuesses,
          32,
        );
      },
    );

    test(
      'Capitalization.',
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: 'AAAaaa',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
        );
        expect(
          match.estimatedGuesses,
          32 * match.uppercaseVariations,
        );
      },
    );

    test(
      'Diceware findings.',
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: 'AaA@@@',
          start: 0,
          end: 6,
          matchedWord: 'AaA@@@',
          rank: 32,
          dictionary: Dictionary.diceware,
        );
        expect(
          match.estimatedGuesses,
          3888,
        );
      },
    );
  });
}

class DictionaryMatchTest extends DictionaryMatch {
  DictionaryMatchTest({
    required String password,
    required int start,
    required int end,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
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
      other is DictionaryMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
      (guessesTest == null || guessesTest == other.guesses) &&
      (uppercaseVariationsTest == null ||
          uppercaseVariationsTest == other.uppercaseVariations) &&
      (extraVariationsTest == null ||
          extraVariationsTest == other.extraVariations);
}
