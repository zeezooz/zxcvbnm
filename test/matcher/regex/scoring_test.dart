import 'dart:math';

import 'package:test/test.dart';
import 'package:zxcvbnm/src/data/const.dart';
import 'package:zxcvbnm/src/matcher/regex/scoring.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Regex scoring.', () {
    test('Lowercase regex.', () {
      final String token = 'aizocdk';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: token.length - 1,
        token: token,
        regexName: 'alphaLower',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(
        regexScoring(match),
        pow(26, token.length),
      );
    });

    test('Alphanumeric regex.', () {
      final String token = 'ag7C8';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: token.length - 1,
        token: token,
        regexName: 'alphanumeric',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(
        regexScoring(match),
        pow(2 * 26 + 10, token.length),
      );
    });

    test('Distant year matches.', () {
      final String token = '1972';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: token.length - 1,
        token: token,
        regexName: 'recentYear',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(
        regexScoring(match),
        (referenceYear - 1972).abs(),
      );
    });

    test('A year close to referenceYear.', () {
      final String token = '2020';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: token.length - 1,
        token: token,
        regexName: 'recentYear',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(
        regexScoring(match),
        minYearSpace,
      );
    });

    test('Not found regex names.', () {
      final String token = '';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: 0,
        token: token,
        regexName: 'someRegexName',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(
        regexScoring(match),
        0,
      );
    });
  });
}
