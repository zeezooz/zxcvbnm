import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/matching.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/matching/reverse.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

class ReverseMatchTest extends ReverseMatch {
  const ReverseMatchTest({
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
      other is ReverseMatch &&
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
  final Options options = Options(
    dictionaries: <Dictionary, List<int>>{
      Dictionary.passwords: <int>[123, 321, 456, 654],
    },
  );
  final MatchDictionary matchDictionary = MatchDictionary(options);
  group('Dictionary reverse matching.', () {
    final MatchReverse matchReverse =
        MatchReverse(matchDictionary.defaultMatch);
    test(
      'Matches against reversed words.',
      () => expect(
        matchReverse.match('0123456789'),
        <ReverseMatchTest>[
          ReverseMatchTest(
            i: 4,
            j: 6,
            token: '456',
            matchedWord: '654',
            rank: 4,
            dictionary: Dictionary.passwords,
          ),
          ReverseMatchTest(
            i: 1,
            j: 3,
            token: '123',
            matchedWord: '321',
            rank: 2,
            dictionary: Dictionary.passwords,
          ),
        ],
      ),
    );
  });
}
