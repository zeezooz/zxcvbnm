import 'package:test/test.dart';
import 'package:zxcvbnm/matchers.dart';
import 'package:zxcvbnm/src/scoring.dart';

import 'helpers/password_tests.dart';
import 'matchers/separator_matcher_test.dart';

void main() {
  group('Scoring.', () {
    const bool excludeAdditive = true;
    const String password = '0123456789';

    test(
      'Returns one bruteforce match given an empty match sequence.',
      () => expect(
        mostGuessableMatchSequence(password, <BaseMatch>[]).sequence,
        <BaseMatch>[BruteForceMatchTest(password: password, start: 0, end: 10)],
      ),
    );

    test(
      'Returns match + bruteforce when match covers a prefix of password.',
      () {
        final List<BaseMatch> matches = <BaseMatch>[
          SeparatorMatchTest(
            password: password,
            start: 0,
            end: 6,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <BaseMatch>[
            ...matches,
            BruteForceMatchTest(
              password: password,
              start: 6,
              end: 10,
            ),
          ],
        );
      },
    );

    test(
      'Returns bruteforce + match when match covers a suffix.',
      () {
        final List<BaseMatch> matches = <BaseMatch>[
          SeparatorMatchTest(
            password: password,
            start: 3,
            end: 10,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <BaseMatch>[
            BruteForceMatchTest(
              password: password,
              start: 0,
              end: 3,
            ),
            ...matches,
          ],
        );
      },
    );

    test(
      'Returns bruteforce + match + bruteforce when match covers an infix.',
      () {
        final List<BaseMatch> matches = <BaseMatch>[
          SeparatorMatchTest(
            password: password,
            start: 1,
            end: 9,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <BaseMatch>[
            BruteForceMatchTest(
              password: password,
              start: 0,
              end: 1,
            ),
            ...matches,
            BruteForceMatchTest(
              password: password,
              start: 9,
              end: 10,
            ),
          ],
        );
      },
    );

    test(
      'Chooses lower-guesses match given two matches of the same span.',
      () {
        final SeparatorMatch match1 = SeparatorMatchTest(
          password: password,
          start: 0,
          end: 10,
          guesses: 1,
        );
        final SeparatorMatch match2 = SeparatorMatchTest(
          password: password,
          start: 0,
          end: 10,
          guesses: 2,
        );
        final SeparatorMatch match3 = SeparatorMatchTest(
          password: password,
          start: 0,
          end: 10,
          guesses: 3,
        );
        final MatchSequence matchSequence1 = mostGuessableMatchSequence(
          password,
          <BaseMatch>[match1, match2],
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence1.sequence,
          <BaseMatch>[match1],
        );
        final MatchSequence matchSequence2 = mostGuessableMatchSequence(
          password,
          <BaseMatch>[match3, match2],
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence2.sequence,
          <BaseMatch>[match2],
        );
      },
    );

    test(
      'When m0 covers m1 and m2, choose [m0] when m0 < m1 * m2 * fact(2).',
      () {
        final List<BaseMatch> matches = <BaseMatch>[
          SeparatorMatchTest(
            password: password,
            start: 0,
            end: 10,
            guesses: 3,
          ),
          SeparatorMatchTest(
            password: password,
            start: 0,
            end: 4,
            guesses: 2,
          ),
          SeparatorMatchTest(
            password: password,
            start: 4,
            end: 10,
            guesses: 1,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <BaseMatch>[matches[0]],
        );
      },
    );

    test(
      'When m0 covers m1 and m2, choose [m1, m2] when m0 > m1 * m2 * fact(2).',
      () {
        final List<BaseMatch> matches = <BaseMatch>[
          SeparatorMatchTest(
            password: password,
            start: 0,
            end: 10,
            guesses: 5,
          ),
          SeparatorMatchTest(
            password: password,
            start: 0,
            end: 4,
            guesses: 2,
          ),
          SeparatorMatchTest(
            password: password,
            start: 4,
            end: 10,
            guesses: 1,
          ),
        ];
        final MatchSequence matchSequence = mostGuessableMatchSequence(
          password,
          matches,
          excludeAdditive: excludeAdditive,
        );
        expect(
          matchSequence.sequence,
          <BaseMatch>[matches[1], matches[2]],
        );
      },
    );
  });
}
