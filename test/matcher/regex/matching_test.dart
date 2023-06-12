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
    const List<List<String>> data = <List<String>>[
      <String>['1922', 'recentYear'],
      <String>['2017', 'recentYear'],
    ];
    final MatchRegex matchRegex = MatchRegex();
    for (final List<String> item in data) {
      final String pattern = item[0];
      final String name = item[1];
      test(
        'Matches $pattern as a $name pattern.',
        () {
          expect(
            matchRegex.match(pattern),
            <RegexMatchTest>[
              RegexMatchTest(
                i: 0,
                j: pattern.length - 1,
                token: pattern,
                regexName: name,
                regexMatch: RegExp('.*').firstMatch(pattern)!,
              ),
            ],
          );
        },
      );
    }
    test(
      'Matches recentYear pattern multiple times.',
      () {
        expect(
          matchRegex.match('1922-2017'),
          <RegexMatchTest>[
            RegexMatchTest(
              i: 0,
              j: 3,
              token: '1922',
              regexName: 'recentYear',
              regexMatch: RegExp('.*').firstMatch('1922')!,
            ),
            RegexMatchTest(
              i: 5,
              j: 8,
              token: '2017',
              regexName: 'recentYear',
              regexMatch: RegExp(r'\d+').firstMatch('-----2017')!,
            ),
          ],
        );
      },
    );
  });
}
