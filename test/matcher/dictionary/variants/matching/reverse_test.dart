import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/matching.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/matching/reverse.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

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
      (l33tVariationsTest == null ||
          l33tVariationsTest == other.l33tVariations);
}

void main() {
  group('Dictionary reverse matching.', () {
    final Options options = Options(
      dictionaries: <Dictionary, List<int>>{
        Dictionary.passwords: <int>[123, 321, 456, 654, 999],
      },
    );
    final MatchDictionary matchDictionary = MatchDictionary(options);
    final MatchReverse matchReverse =
        MatchReverse(matchDictionary.defaultMatch);

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
}
