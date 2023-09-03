import 'dart:math';

import 'package:test/test.dart';
import 'package:zxcvbnm/src/matchers/reg_ex_matcher.dart';
import 'package:zxcvbnm/src/options.dart';

void main() {
  group('RegExMatcher.', () {
    final Options options = Options();
    final RegExMatcher matchRegex = RegExMatcher(options);

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
                regExName: 'recentYear',
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
                regExName: 'recentYear',
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
                regExName: 'recentYear',
              ),
              RegexMatchTest(
                password: password,
                start: 5,
                end: 9,
                regExName: 'recentYear',
              ),
            ],
          ],
        );
      },
    );
  });

  group('RegExMatch guesses.', () {
    final Options options = Options();

    test('Lowercase regex.', () {
      final String token = 'aizocdk';
      final RegExMatch match = RegExMatch(
        password: token,
        start: 0,
        end: token.length,
        regExName: 'alphaLower',
        options: options,
      );
      expect(
        match.estimatedGuesses,
        pow(26, token.length),
      );
    });

    test('Alphanumeric regex.', () {
      final String token = 'ag7C8';
      final RegExMatch match = RegExMatch(
        password: token,
        start: 0,
        end: token.length,
        regExName: 'alphanumeric',
        options: options,
      );
      expect(
        match.estimatedGuesses,
        pow(2 * 26 + 10, token.length),
      );
    });

    test('Distant year matches.', () {
      final String token = '1972';
      final RegExMatch match = RegExMatch(
        password: token,
        start: 0,
        end: token.length,
        regExName: 'recentYear',
        options: options,
      );
      expect(
        match.estimatedGuesses,
        (options.currentYear - 1972).abs(),
      );
    });

    test('A year close to currentYear.', () {
      final String token = '2020';
      final RegExMatch match = RegExMatch(
        password: token,
        start: 0,
        end: token.length,
        regExName: 'recentYear',
        options: options,
      );
      expect(
        match.estimatedGuesses,
        options.minYearSpace,
      );
    });

    test('Not found regex names.', () {
      final String token = '';
      final RegExMatch match = RegExMatch(
        password: token,
        start: 0,
        end: 0,
        regExName: 'someRegexName',
        options: options,
      );
      expect(
        match.estimatedGuesses,
        0,
      );
    });
  });
}

class RegexMatchTest extends RegExMatch {
  RegexMatchTest({
    required String password,
    required int start,
    required int end,
    required String regExName,
    double? guesses,
    Options? options,
  })  : guessesTest = guesses,
        super(
          password: password,
          start: start,
          end: end,
          regExName: regExName,
          options: options ?? Options(),
        );

  final double? guessesTest;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is RegExMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      regExName == other.regExName &&
      (guessesTest == null || guessesTest == other.guesses);
}
