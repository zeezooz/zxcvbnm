import 'package:test/test.dart';
import 'package:zxcvbnm/src/matchers/brute_force_matcher.dart';

void main() {
  group('BruteForceMatch guesses.', () {
    test(
      'Token length.',
      () {
        final BruteForceMatch match1 = BruteForceMatch(
          password: 'a' * 2,
          start: 0,
          end: 2,
        );
        expect(
          match1.estimatedGuesses,
          1e2,
        );

        final BruteForceMatch match2 = BruteForceMatch(
          password: 'a' * 123,
          start: 0,
          end: 123,
        );
        expect(
          match2.estimatedGuesses,
          1e123,
        );

        final BruteForceMatch match3 = BruteForceMatch(
          password: 'a' * 308,
          start: 0,
          end: 308,
        );
        expect(
          match3.estimatedGuesses,
          1e308,
        );
      },
    );

    test(
      'Overflow.',
      () {
        final BruteForceMatch match = BruteForceMatch(
          password: 'a' * 309,
          start: 0,
          end: 309,
        );
        expect(
          match.estimatedGuesses,
          double.maxFinite,
        );
      },
    );

    test(
      'Min guesses for single character.',
      () {
        final BruteForceMatch match = BruteForceMatch(
          password: 'a',
          start: 0,
          end: 1,
        );
        expect(
          match.estimatedGuesses,
          11,
        );
      },
    );

    test(
      'Min guesses for multiple characters.',
      () {
        final BruteForceMatch match = BruteForceMatch(
          password: 'ab',
          start: 0,
          end: 2,
        );
        expect(
          match.estimatedGuesses,
          51,
        );
      },
      skip: "This can't be reached because min guesses is 51 and with"
          ' a password length of 2 you get 100 already.',
    );
  });
}
