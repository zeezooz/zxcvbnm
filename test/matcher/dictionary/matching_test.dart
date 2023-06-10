import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/matcher/dictionary/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

import '../../helper/generate_passwords.dart';

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
      final List<DictionaryMatch> matches = matchDictionary
          .match('we')
          .where((DictionaryMatch match) => match is! ReverseMatch)
          .toList();
      test(
        'Default dictionaries.',
        () => expect(matches, <DictionaryMatchTest>[
          DictionaryMatchTest(
            i: 0,
            j: 1,
            token: 'we',
            matchedWord: 'we',
            rank: 13,
            dictionary: Dictionary.commonWords,
          ),
        ]),
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
      List<DictionaryMatch> match(String password) => matchDictionary
          .match(password)
          .where((DictionaryMatch match) => match is! ReverseMatch)
          .toList();

      test(
        'Matches words that contain other words.',
        () => expect(match('motherboard'), <DictionaryMatchTest>[
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
        ]),
      );

      test(
        'Matches multiple words when they overlap.',
        () => expect(match('abcdef'), <DictionaryMatchTest>[
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
        ]),
      );

      test(
        'Ignores uppercase.',
        () => expect(match('BoaRdZ'), <DictionaryMatchTest>[
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
        ]),
      );

      const List<String> prefixes = <String>['q', '%%'];
      const List<String> suffixes = <String>['%', 'qq'];
      const String pattern = 'asdf1234&*';
      final List<IndexedPassword> passwords =
          generatePasswords(pattern, prefixes, suffixes);
      for (final IndexedPassword password in passwords) {
        test(
          'Identifies words surrounded by non-words.',
          () => expect(match(password.password), <DictionaryMatchTest>[
            DictionaryMatchTest(
              i: password.i,
              j: password.j,
              token: pattern,
              matchedWord: pattern,
              rank: 5,
              dictionary: Dictionary.passwords,
            )
          ]),
        );
      }

      options.rankedDictionaries.forEach(
        (Dictionary dictionary, RankedDictionary rankedDictionary) {
          rankedDictionary.forEach((String word, int rank) {
            if (word == 'motherboard') return;
            test(
              'Matches against all words in provided dictionaries.',
              () => expect(match(word), <DictionaryMatchTest>[
                DictionaryMatchTest(
                  i: 0,
                  j: word.length - 1,
                  token: word,
                  matchedWord: word,
                  rank: rank,
                  dictionary: dictionary,
                )
              ]),
            );
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
      final Iterable<DictionaryMatch> matches = matchDictionary
          .match('foobar')
          .where(
            (DictionaryMatch match) =>
                match.dictionary == Dictionary.userInputs,
          )
          .toList();
      test(
        'Matches with provided user input dictionary.',
        () => expect(matches, <DictionaryMatchTest>[
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
        ]),
      );
    });
  });
}
