import 'package:test/test.dart';
import 'package:zxcvbnm/matchers.dart';

void main() {
  group('SeparatorMatcher.', () {
    final SeparatorMatcher separatorMatcher = SeparatorMatcher();

    test(
      "Doesn't match without separators.",
      () => expect(
        separatorMatcher.match(''),
        <List<SeparatorMatchTest>>[<SeparatorMatchTest>[]],
      ),
    );

    test(
      'Matches same separators.',
      () => expect(
        separatorMatcher.match('first second third'),
        <List<SeparatorMatchTest>>[
          <SeparatorMatchTest>[
            SeparatorMatchTest(
              password: 'first second third',
              start: 5,
              end: 6,
            ),
            SeparatorMatchTest(
              password: 'first second third',
              start: 12,
              end: 13,
            ),
          ],
        ],
      ),
    );

    test(
      'Matches with different potential separators.',
      () => expect(
        separatorMatcher.match('first-second-third,&'),
        <List<SeparatorMatchTest>>[
          <SeparatorMatchTest>[
            SeparatorMatchTest(
              password: 'first-second-third,&',
              start: 5,
              end: 6,
            ),
            SeparatorMatchTest(
              password: 'first-second-third,&',
              start: 12,
              end: 13,
            ),
          ],
        ],
      ),
    );
  });

  group('SeparatorMatch guesses.', () {
    for (final String token in SeparatorMatcher.separators) {
      test(
        "The separator pattern '$token'.",
        () {
          expect(
            SeparatorMatch(password: token, start: 0, end: 1).estimatedGuesses,
            SeparatorMatcher.separators.length,
          );
        },
      );
    }
  });
}

class SeparatorMatchTest extends SeparatorMatch {
  SeparatorMatchTest({
    required String password,
    required int start,
    required int end,
    double? guesses,
  })  : guessesTest = guesses,
        super(
          password: password,
          start: start,
          end: end,
        );

  final double? guessesTest;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is SeparatorMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      (guessesTest == null || guessesTest == other.guesses);
}
