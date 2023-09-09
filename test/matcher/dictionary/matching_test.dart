import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/matcher/dictionary/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

import '../../helper/generate_passwords.dart';
import 'variants/matching/reverse_test.dart';

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
      (l33tVariationsTest == null ||
          l33tVariationsTest == other.l33tVariations);
}

void main() {
  group('Dictionary matching.', () {
    group('Default dictionaries.', () {
      final Options options = Options(dictionaries: dictionaries);
      final MatchDictionary matchDictionary = MatchDictionary(options);

      test(
        'Default dictionaries.',
        () => expect(
          matchDictionary.match('we'),
          <Matcher>[
            containsOnce(
              DictionaryMatchTest(
                password: 'we',
                start: 0,
                end: 2,
                matchedWord: 'we',
                rank: 13,
                dictionary: Dictionary.commonWords,
              ),
            ),
          ],
        ),
      );

      test(
        'Default dictionaries with duplicates.',
        () => expect(
          matchDictionary.match('elk'),
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
              ReverseMatchTest(
                password: 'elk',
                start: 0,
                end: 2,
                matchedWord: 'le',
                rank: 975,
                dictionary: Dictionary.lastNames,
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
      final MatchDictionary matchDictionary = MatchDictionary(options);

      test(
        'Matches words that contain other words.',
        () => expect(
          matchDictionary.match('motherboard'),
          <List<DictionaryMatchTest>>[
            <DictionaryMatchTest>[
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
          matchDictionary.match('abcdef'),
          <List<DictionaryMatchTest>>[
            <DictionaryMatchTest>[
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
          matchDictionary.match('BoaRdZ'),
          <List<DictionaryMatchTest>>[
            <DictionaryMatchTest>[
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
              matchDictionary.match(password.password),
              <List<DictionaryMatchTest>>[
                <DictionaryMatchTest>[
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
                matchDictionary.match(word),
                <List<DictionaryMatchTest>>[
                  <DictionaryMatchTest>[
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
      final MatchDictionary matchDictionary = MatchDictionary(options);

      test(
        'Matches with provided user input dictionary.',
        () {
          expect(
            matchDictionary.match('foobar'),
            <List<DictionaryMatchTest>>[
              <DictionaryMatchTest>[
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
  });
}
