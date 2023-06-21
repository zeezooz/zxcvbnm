import 'package:test/test.dart';
import 'package:zxcvbnm/src/helper.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Sort.', () {
    test('Sorting an empty list leaves it empty.', () {
      final List<Match> matches = <Match>[];
      sort(matches);
      expect(
        matches,
        <Match>[],
      );
    });

    test('Matches are sorted on i index primary, j secondary.', () {
      final Match m1 = BruteForceMatch(
        i: 5,
        j: 5,
        token: '',
      );
      final Match m2 = BruteForceMatch(
        i: 6,
        j: 7,
        token: '',
      );
      final Match m3 = BruteForceMatch(
        i: 2,
        j: 5,
        token: '',
      );
      final Match m4 = BruteForceMatch(
        i: 0,
        j: 0,
        token: '',
      );
      final Match m5 = BruteForceMatch(
        i: 2,
        j: 3,
        token: '',
      );
      final Match m6 = BruteForceMatch(
        i: 0,
        j: 3,
        token: '',
      );
      final List<Match> matches = <Match>[m1, m2, m3, m4, m5, m6];
      sort(matches);
      expect(
        matches,
        <Match>[m4, m6, m5, m3, m1, m2],
      );
    });
  });
}
