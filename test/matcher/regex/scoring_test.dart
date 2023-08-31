import 'dart:math';

import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/regex/scoring.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Regex scoring.', () {
    final Options options = Options();

    test('Lowercase regex.', () {
      final String token = 'aizocdk';
      final RegexMatch match = RegexMatch(
        password: token,
        start: 0,
        end: token.length,
        regexName: 'alphaLower',
        regexMatch: RegExp('.*').firstMatch(token)!,
        options: options,
      );
      expect(
        regexScoring(match, options),
        pow(26, token.length),
      );
    });

    test('Alphanumeric regex.', () {
      final String token = 'ag7C8';
      final RegexMatch match = RegexMatch(
        password: token,
        start: 0,
        end: token.length,
        regexName: 'alphanumeric',
        regexMatch: RegExp('.*').firstMatch(token)!,
        options: options,
      );
      expect(
        regexScoring(match, options),
        pow(2 * 26 + 10, token.length),
      );
    });

    test('Distant year matches.', () {
      final String token = '1972';
      final RegexMatch match = RegexMatch(
        password: token,
        start: 0,
        end: token.length,
        regexName: 'recentYear',
        regexMatch: RegExp('.*').firstMatch(token)!,
        options: options,
      );
      expect(
        regexScoring(match, options),
        (options.currentYear - 1972).abs(),
      );
    });

    test('A year close to currentYear.', () {
      final String token = '2020';
      final RegexMatch match = RegexMatch(
        password: token,
        start: 0,
        end: token.length,
        regexName: 'recentYear',
        regexMatch: RegExp('.*').firstMatch(token)!,
        options: options,
      );
      expect(
        regexScoring(match, options),
        options.minYearSpace,
      );
    });

    test('Not found regex names.', () {
      final String token = '';
      final RegexMatch match = RegexMatch(
        password: token,
        start: 0,
        end: 0,
        regexName: 'someRegexName',
        regexMatch: RegExp('.*').firstMatch(token)!,
        options: options,
      );
      expect(
        regexScoring(match, options),
        0,
      );
    });
  });
}
