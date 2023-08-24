import 'dart:math';

import 'package:test/test.dart';
import 'package:zxcvbnm/src/data/const.dart';
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
        regexScoring(match),
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
        regexScoring(match),
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
        regexScoring(match),
        (referenceYear - 1972).abs(),
      );
    });

    test('A year close to referenceYear.', () {
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
        regexScoring(match),
        minYearSpace,
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
        regexScoring(match),
        0,
      );
    });
  });
}
