import 'dart:math';

import 'package:test/test.dart';
import 'package:zxcvbnm/src/data/const.dart';
import 'package:zxcvbnm/src/matcher/regex/scoring.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Regex scoring.', () {
    test('Guesses of 26^7 for 7-char lowercase regex.', () {
      final String token = 'aizocdk';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: 6,
        token: token,
        regexName: 'alphaLower',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(regexScoring(match), pow(26, 7));
    });

    test('Guesses of 62^5 for 5-char alphanumeric regex.', () {
      final String token = 'ag7C8';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: 4,
        token: token,
        regexName: 'alphanumeric',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(regexScoring(match), pow(2 * 26 + 10, 5));
    });

    test('Guesses of |year - referenceYear| for distant year matches.', () {
      final String token = '1972';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: 3,
        token: token,
        regexName: 'recentYear',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(regexScoring(match), (referenceYear - 1972).abs());
    });

    test('Guesses of minYearSpace for a year close to referenceYear.', () {
      final String token = '2020';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: 3,
        token: token,
        regexName: 'recentYear',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(regexScoring(match), minYearSpace);
    });

    test('Should equal 0 for not found regex names.', () {
      final String token = '';
      final RegexMatch match = RegexMatch(
        i: 0,
        j: 0,
        token: token,
        regexName: 'someRegexName',
        regexMatch: RegExp('.*').firstMatch(token)!,
      );
      expect(regexScoring(match), 0);
    });
  });
}
