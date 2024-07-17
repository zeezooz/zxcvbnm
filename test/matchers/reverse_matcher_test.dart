import 'package:test/test.dart';
import 'package:zxcvbnm/src/matchers/dictionary_matcher.dart';
import 'package:zxcvbnm/src/matchers/reverse_matcher.dart';
import 'package:zxcvbnm/src/options.dart';

void main() {
  group('ReverseMatcher.', () {
    final Options options = Options(
      dictionaries: <Dictionary, List<List<int>>>{
        Dictionary.passwords: <List<int>>[
          <int>[123, 321, 456, 654, 999],
        ],
      },
    );
    final ReverseMatcher matchReverse =
        ReverseMatcher(DictionaryMatcher(options));

    test(
      'Matches against reversed words.',
      () {
        const String password = '012345678999';
        expect(
          matchReverse.match(password),
          <List<ReverseMatchTest>>[
            <ReverseMatchTest>[
              ReverseMatchTest(
                password: password,
                start: 4,
                end: 7,
                matchedWord: '654',
                rank: 4,
                dictionary: Dictionary.passwords,
              ),
              ReverseMatchTest(
                password: password,
                start: 1,
                end: 4,
                matchedWord: '321',
                rank: 2,
                dictionary: Dictionary.passwords,
              ),
            ],
          ],
        );
      },
    );
  });

  group('ReverseMatch guesses.', () {
    test(
      'Word is reversed.',
      () {
        final ReverseMatch match = ReverseMatch(
          password: 'aaa',
          start: 0,
          end: 3,
          matchedWord: 'aaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
        );
        expect(
          match.estimatedGuesses,
          32 * 2,
        );
      },
    );
  });
}

class ReverseMatchTest extends ReverseMatch {
  ReverseMatchTest({
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
      other is ReverseMatch &&
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
