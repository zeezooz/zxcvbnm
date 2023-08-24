import 'package:test/test.dart';
import 'package:zxcvbnm/src/data/const.dart';
import 'package:zxcvbnm/src/matcher/date/scoring.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Date scoring.', () {
    final Options options = Options();

    test(
      'Guesses for 1123.',
      () {
        final DateMatch match = DateMatch(
          password: '1123',
          start: 0,
          end: 4,
          separator: '',
          year: 1923,
          month: 1,
          day: 1,
          options: options,
        );
        expect(
          dateScoring(match),
          365 * (referenceYear - match.year).abs(),
        );
      },
    );

    test(
      'Recent years assume minYearSpace. Extra guesses are added for separators.',
      () {
        final DateMatch match = DateMatch(
          password: '1/1/2020',
          start: 0,
          end: 8,
          separator: '/',
          year: 2020,
          month: 1,
          day: 1,
          options: options,
        );
        expect(
          dateScoring(match),
          365 * minYearSpace * 4,
        );
      },
    );
  });
}
