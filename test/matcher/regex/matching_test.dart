import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/regex/matching.dart';
import 'package:zxcvbnm/src/types.dart';

class RegexMatchTest extends RegexMatch {
  const RegexMatchTest({
    required int i,
    required int j,
    required String token,
    required String regexName,
    required RegExpMatch regexMatch,
  }) : super(
          i: i,
          j: j,
          token: token,
          regexName: regexName,
          regexMatch: regexMatch,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is RegexMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      regexName == other.regexName &&
      regexMatch.start == other.regexMatch.start &&
      regexMatch.end == other.regexMatch.end &&
      regexMatch[0] == other.regexMatch[0];
}

void main() {
  group('Regex matching.', () {
    final MatchRegex matchRegex = MatchRegex();

    test(
      'Matches 1922 as a recentYear pattern.',
      () {
        const String pattern = '1922';
        expect(
          matchRegex.match(pattern),
          <RegexMatchTest>[
            RegexMatchTest(
              i: 0,
              j: pattern.length - 1,
              token: pattern,
              regexName: 'recentYear',
              regexMatch: RegExp('.*').firstMatch(pattern)!,
            ),
          ],
        );
      },
    );

    test(
      'Matches 2017 as a recentYear pattern.',
      () {
        const String pattern = '2017';
        expect(
          matchRegex.match(pattern),
          <RegexMatchTest>[
            RegexMatchTest(
              i: 0,
              j: pattern.length - 1,
              token: pattern,
              regexName: 'recentYear',
              regexMatch: RegExp('.*').firstMatch(pattern)!,
            ),
          ],
        );
      },
    );

    test(
      'Matches 2016-2015 as a recentYear pattern.',
      () {
        expect(
          matchRegex.match('2016-2015'),
          <RegexMatchTest>[
            RegexMatchTest(
              i: 0,
              j: 3,
              token: '2016',
              regexName: 'recentYear',
              regexMatch: RegExp('.*').firstMatch('2016')!,
            ),
            RegexMatchTest(
              i: 5,
              j: 8,
              token: '2015',
              regexName: 'recentYear',
              regexMatch: RegExp(r'\d+').firstMatch('-----2015')!,
            ),
          ],
        );
      },
    );
  });
}
