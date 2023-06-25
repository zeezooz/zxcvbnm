import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/separator/matching.dart';
import 'package:zxcvbnm/src/types.dart';

class SeparatorMatchTest extends SeparatorMatch {
  SeparatorMatchTest({
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
      other is SeparatorMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token;
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
            SeparatorMatchTest(i: 5, j: 5, token: ' '),
            SeparatorMatchTest(i: 12, j: 12, token: ' '),
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
            SeparatorMatchTest(i: 5, j: 5, token: '-'),
            SeparatorMatchTest(i: 12, j: 12, token: '-'),
          ],
        ],
      ),
    );
  });
}
