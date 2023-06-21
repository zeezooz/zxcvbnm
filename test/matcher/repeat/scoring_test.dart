import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/repeat/scoring.dart';
import 'package:zxcvbnm/src/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/scoring/index.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Repeat scoring.', () {
    final Options options = Options();
    final OmniMatch omniMatch = OmniMatch(options);

    test(
      "The repeat pattern 'aa'.",
      () async {
        const String baseToken = 'a';
        const int repeatCount = 2;
        final double baseGuesses = mostGuessableMatchSequence(
          baseToken,
          await omniMatch.match(baseToken),
        ).guesses;
        final RepeatMatch match = RepeatMatch(
          i: 0,
          j: baseToken.length * repeatCount - 1,
          token: baseToken * repeatCount,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
          repeatCount: repeatCount,
        );
        expect(
          repeatScoring(match),
          baseGuesses * repeatCount,
        );
      },
    );

    test(
      "The repeat pattern '999'.",
      () async {
        const String baseToken = '9';
        const int repeatCount = 3;
        final double baseGuesses = mostGuessableMatchSequence(
          baseToken,
          await omniMatch.match(baseToken),
        ).guesses;
        final RepeatMatch match = RepeatMatch(
          i: 0,
          j: baseToken.length * repeatCount - 1,
          token: baseToken * repeatCount,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
          repeatCount: repeatCount,
        );
        expect(
          repeatScoring(match),
          baseGuesses * repeatCount,
        );
      },
    );

    test(
      r"The repeat pattern '$$$$'.",
      () async {
        const String baseToken = r'$';
        const int repeatCount = 4;
        final double baseGuesses = mostGuessableMatchSequence(
          baseToken,
          await omniMatch.match(baseToken),
        ).guesses;
        final RepeatMatch match = RepeatMatch(
          i: 0,
          j: baseToken.length * repeatCount - 1,
          token: baseToken * repeatCount,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
          repeatCount: repeatCount,
        );
        expect(
          repeatScoring(match),
          baseGuesses * repeatCount,
        );
      },
    );

    test(
      "The repeat pattern 'abab'.",
      () async {
        const String baseToken = 'ab';
        const int repeatCount = 2;
        final double baseGuesses = mostGuessableMatchSequence(
          baseToken,
          await omniMatch.match(baseToken),
        ).guesses;
        final RepeatMatch match = RepeatMatch(
          i: 0,
          j: baseToken.length * repeatCount - 1,
          token: baseToken * repeatCount,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
          repeatCount: repeatCount,
        );
        expect(
          repeatScoring(match),
          baseGuesses * repeatCount,
        );
      },
    );

    test(
      "The repeat pattern 'batterystaplebatterystaplebatterystaple'.",
      () async {
        const String baseToken = 'batterystaple';
        const int repeatCount = 3;
        final double baseGuesses = mostGuessableMatchSequence(
          baseToken,
          await omniMatch.match(baseToken),
        ).guesses;
        final RepeatMatch match = RepeatMatch(
          i: 0,
          j: baseToken.length * repeatCount - 1,
          token: baseToken * repeatCount,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
          repeatCount: repeatCount,
        );
        expect(
          repeatScoring(match),
          baseGuesses * repeatCount,
        );
      },
    );
  });
}
