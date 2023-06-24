import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/date/scoring.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

class DateMatchEstimatedTest extends DateMatchEstimated {
  DateMatchEstimatedTest({
    required int i,
    required int j,
    required String token,
    required String separator,
    required int year,
    required int month,
    required int day,
    required double guesses,
    required double guessesLog10,
  }) : super(
          i: i,
          j: j,
          token: token,
          separator: separator,
          year: year,
          month: month,
          day: day,
          guesses: guesses,
          guessesLog10: guessesLog10,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is DateMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      separator == other.separator &&
      year == other.year &&
      month == other.month &&
      day == other.day &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10;
}

void main() {
  group('Scoring.', () {
    final Options options = Options();

    test(
      'estimate returns cached guesses when available',
      () {
        const BruteForceMatchEstimated match = BruteForceMatchEstimated(
          i: 0,
          j: 0,
          token: 'a',
          guesses: 1,
          guessesLog10: 0,
        );
        expect(
          match.estimate('', options),
          match,
        );
      },
    );

    test(
      'estimate delegates based on pattern',
      () {
        const DateMatch match = DateMatch(
          i: 0,
          j: 3,
          token: '1977',
          separator: '',
          year: 1977,
          month: 7,
          day: 14,
        );
        expect(
          match.estimate('1977', options),
          DateMatchEstimatedTest(
            i: 0,
            j: 3,
            token: '1977',
            separator: '',
            year: 1977,
            month: 7,
            day: 14,
            guesses: dateScoring(match),
            guessesLog10: 4.225050696138048,
          ),
        );
      },
    );
  });
}
