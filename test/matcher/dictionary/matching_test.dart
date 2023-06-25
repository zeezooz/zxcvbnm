import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/matcher/dictionary/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart' hide Matcher;

import '../../helper/generate_passwords.dart';
import 'variants/matching/reverse_test.dart';

class DictionaryMatchTest extends DictionaryMatch {
  const DictionaryMatchTest({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is DictionaryMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry;
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
                i: 0,
                j: 1,
                token: 'we',
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
                i: 0,
                j: 1,
                token: 'el',
                matchedWord: 'el',
                rank: 2967,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                i: 0,
                j: 2,
                token: 'elk',
                matchedWord: 'elk',
                rank: 2167,
                dictionary: Dictionary.diceware,
              ),
              DictionaryMatchTest(
                i: 0,
                j: 2,
                token: 'elk',
                matchedWord: 'elk',
                rank: 16651,
                dictionary: Dictionary.commonWords,
              ),
              ReverseMatchTest(
                i: 0,
                j: 1,
                token: 'el',
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
                i: 0,
                j: 5,
                token: 'mother',
                matchedWord: 'mother',
                rank: 2,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                i: 0,
                j: 10,
                token: 'motherboard',
                matchedWord: 'motherboard',
                rank: 1,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                i: 6,
                j: 10,
                token: 'board',
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
                i: 0,
                j: 3,
                token: 'abcd',
                matchedWord: 'abcd',
                rank: 4,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                i: 2,
                j: 5,
                token: 'cdef',
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
                i: 0,
                j: 4,
                token: 'BoaRd',
                matchedWord: 'board',
                rank: 3,
                dictionary: Dictionary.commonWords,
              ),
              DictionaryMatchTest(
                i: 5,
                j: 5,
                token: 'Z',
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
                    i: password.i,
                    j: password.j,
                    token: token,
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
                      i: 0,
                      j: word.length - 1,
                      token: word,
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
                  i: 0,
                  j: 2,
                  token: 'foo',
                  matchedWord: 'foo',
                  rank: 1,
                  dictionary: Dictionary.userInputs,
                ),
                DictionaryMatchTest(
                  i: 3,
                  j: 5,
                  token: 'bar',
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
