import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/regex/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

class RegexMatchTest extends RegexMatch {
  RegexMatchTest({
    required String password,
    required int start,
    required int end,
    required String regexName,
    required RegExpMatch regexMatch,
    double? guesses,
    Options? options,
  })  : guessesTest = guesses,
        super(
          password: password,
          start: start,
          end: end,
          regexName: regexName,
          regexMatch: regexMatch,
          options: options ?? Options(),
        );

  final double? guessesTest;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is RegexMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      regexName == other.regexName &&
      regexMatch.start == other.regexMatch.start &&
      regexMatch.end == other.regexMatch.end &&
      regexMatch[0] == other.regexMatch[0] &&
      (guessesTest == null || guessesTest == other.guesses);
}

void main() {
  group('Regex matching.', () {
    final Options options = Options();
    final MatchRegex matchRegex = MatchRegex(options);

    test(
      'Matches 1922 as a recentYear pattern.',
      () {
        const String password = '1922';
        expect(
          matchRegex.match(password),
          <List<RegexMatchTest>>[
            <RegexMatchTest>[
              RegexMatchTest(
                password: password,
                start: 0,
                end: password.length,
                regexName: 'recentYear',
                regexMatch: RegExp('.*').firstMatch(password)!,
              ),
            ],
          ],
        );
      },
    );

    test(
      'Matches 2017 as a recentYear pattern.',
      () {
        const String password = '2017';
        expect(
          matchRegex.match(password),
          <List<RegexMatchTest>>[
            <RegexMatchTest>[
              RegexMatchTest(
                password: password,
                start: 0,
                end: password.length,
                regexName: 'recentYear',
                regexMatch: RegExp('.*').firstMatch(password)!,
              ),
            ],
          ],
        );
      },
    );

    test(
      'Matches 2016-2015 as a recentYear pattern.',
      () {
        const String password = '2016-2015';
        expect(
          matchRegex.match(password),
          <List<RegexMatchTest>>[
            <RegexMatchTest>[
              RegexMatchTest(
                password: password,
                start: 0,
                end: 4,
                regexName: 'recentYear',
                regexMatch: RegExp('.*').firstMatch('2016')!,
              ),
              RegexMatchTest(
                password: password,
                start: 5,
                end: 9,
                regexName: 'recentYear',
                regexMatch: RegExp(r'\d+').firstMatch('-----2015')!,
              ),
            ],
          ],
        );
      },
    );
  });
}
