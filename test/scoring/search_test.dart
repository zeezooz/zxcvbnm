import 'package:test/test.dart';
import 'package:zxcvbnm/src/scoring/index.dart';
import 'package:zxcvbnm/src/types.dart';

class BruteForceMatchTest extends BruteForceMatch {
  const BruteForceMatchTest({
    required int i,
    required int j,
    required String token,
  }) : super(
          i: i,
          j: j,
          token: token,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is BruteForceMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token;
}

void main() {
  group('Scoring search.', () {
    const bool excludeAdditive = true;
    const String password = '0123456789';

    test(
      'Returns one bruteforce match given an empty match sequence.',
      () => expect(
        mostGuessableMatchSequence(password, <Match>[]).sequence,
        <Match>[BruteForceMatchTest(i: 0, j: 9, token: password)],
      ),
    );

    test(
      'Returns match + bruteforce when match covers a prefix of password.',
      () {
        final List<MatchEstimated> matches = <MatchEstimated>[
          SeparatorMatchEstimated(
            i: 0,
            j: 5,
            token: password.substring(0, 6),
            guesses: 1,
            guessesLog10: 0,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <Match>[
            ...matches,
            BruteForceMatchTest(i: 6, j: 9, token: password.substring(6, 10)),
          ],
        );
      },
    );

    test(
      'Returns bruteforce + match when match covers a suffix.',
      () {
        final List<MatchEstimated> matches = <MatchEstimated>[
          SeparatorMatchEstimated(
            i: 3,
            j: 9,
            token: password.substring(3, 10),
            guesses: 1,
            guessesLog10: 0,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <Match>[
            BruteForceMatchTest(i: 0, j: 2, token: password.substring(0, 3)),
            ...matches,
          ],
        );
      },
    );

    test(
      'Returns bruteforce + match + bruteforce when match covers an infix.',
      () {
        final List<MatchEstimated> matches = <MatchEstimated>[
          SeparatorMatchEstimated(
            i: 1,
            j: 8,
            token: password.substring(1, 9),
            guesses: 1,
            guessesLog10: 0,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <Match>[
            BruteForceMatchTest(i: 0, j: 0, token: password.substring(0, 1)),
            ...matches,
            BruteForceMatchTest(i: 9, j: 9, token: password.substring(9, 10)),
          ],
        );
      },
    );

    test(
      'Chooses lower-guesses match given two matches of the same span.',
      () {
        final SeparatorMatchEstimated match1 = SeparatorMatchEstimated(
          i: 0,
          j: 9,
          token: password,
          guesses: 1,
          guessesLog10: 0,
        );
        final SeparatorMatchEstimated match2 = SeparatorMatchEstimated(
          i: 0,
          j: 9,
          token: password,
          guesses: 2,
          guessesLog10: 0.301,
        );
        final SeparatorMatchEstimated match3 = SeparatorMatchEstimated(
          i: 0,
          j: 9,
          token: password,
          guesses: 3,
          guessesLog10: 0.477,
        );
        final MatchSequence matchSequence1 = mostGuessableMatchSequence(
          password,
          <MatchEstimated>[match1, match2],
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence1.sequence,
          <MatchEstimated>[match1],
        );
        final MatchSequence matchSequence2 = mostGuessableMatchSequence(
          password,
          <MatchEstimated>[match3, match2],
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence2.sequence,
          <MatchEstimated>[match2],
        );
      },
    );

    test(
      'When m0 covers m1 and m2, choose [m0] when m0 < m1 * m2 * fact(2).',
      () {
        final List<MatchEstimated> matches = <MatchEstimated>[
          SeparatorMatchEstimated(
            i: 0,
            j: 9,
            token: password,
            guesses: 3,
            guessesLog10: 0.477,
          ),
          SeparatorMatchEstimated(
            i: 0,
            j: 3,
            token: password.substring(1, 4),
            guesses: 2,
            guessesLog10: 0.301,
          ),
          SeparatorMatchEstimated(
            i: 4,
            j: 9,
            token: password.substring(4, 10),
            guesses: 1,
            guessesLog10: 0,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <Match>[matches[0]],
        );
      },
    );

    test(
      'When m0 covers m1 and m2, choose [m1, m2] when m0 > m1 * m2 * fact(2).',
      () {
        final List<MatchEstimated> matches = <MatchEstimated>[
          SeparatorMatchEstimated(
            i: 0,
            j: 9,
            token: password,
            guesses: 5,
            guessesLog10: 0.699,
          ),
          SeparatorMatchEstimated(
            i: 0,
            j: 3,
            token: password.substring(1, 4),
            guesses: 2,
            guessesLog10: 0.301,
          ),
          SeparatorMatchEstimated(
            i: 4,
            j: 9,
            token: password.substring(4, 10),
            guesses: 1,
            guessesLog10: 0,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <Match>[matches[1], matches[2]],
        );
      },
    );
  });
}
