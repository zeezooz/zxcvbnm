import 'package:test/test.dart';
import 'package:zxcvbnm/src/data/const.dart';
import 'package:zxcvbnm/src/matcher/date/scoring.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Scoring: guesses date.', () {
    test(
      'Guesses for 1123 is 365 * distance_from_ref_year.',
      () {
        const DateMatch match = DateMatch(
          i: 0,
          j: 0,
          token: '1123',
          separator: '',
          year: 1923,
          month: 1,
          day: 1,
        );
        final int result = 365 * (referenceYear - match.year).abs();
        expect(dateScoring(match), result);
      },
    );
    test(
      'Recent years assume minYearSpace. extra guesses are added for separators.',
      () {
        const DateMatch match = DateMatch(
          i: 0,
          j: 0,
          token: '1/1/2020',
          separator: '/',
          year: 2020,
          month: 1,
          day: 1,
        );
        final int result = 365 * minYearSpace * 4;
        expect(dateScoring(match), result);
      },
    );
  });
}
