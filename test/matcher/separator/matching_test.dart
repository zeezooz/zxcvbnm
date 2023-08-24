import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/separator/matching.dart';
import 'package:zxcvbnm/src/types.dart';

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

void main() {
  group('Separator matching.', () {
    final MatchSeparator matchSeparator = MatchSeparator();

    test(
      "Doesn't match without separators.",
      () => expect(
        matchSeparator.match(''),
        <List<SeparatorMatchTest>>[<SeparatorMatchTest>[]],
      ),
    );

    test(
      'Matches same separators.',
      () => expect(
        matchSeparator.match('first second third'),
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
        matchSeparator.match('first-second-third,&'),
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
}
