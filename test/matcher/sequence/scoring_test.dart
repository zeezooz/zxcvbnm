import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/sequence/scoring.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Sequence scoring.', () {
    const List<List<Object>> data = <List<Object>>[
      <Object>['ab', true, 4 * 2], // obvious start * len-2
      <Object>['XYZ', true, 26 * 3], // base26 * len-3
      <Object>['4567', true, 10 * 4], // base10 * len-4
      <Object>['7654', false, 10 * 4 * 2], // base10 * len 4 * descending
      <Object>['ZYX', false, 4 * 3 * 2], // obvious start * len-3 * descending
    ];
    for (final List<Object> item in data) {
      final String token = item[0] as String;
      final bool ascending = item[1] as bool;
      final int guesses = item[2] as int;
      test(
        "The sequence pattern '$token' has guesses of $guesses.",
        () {
          final SequenceMatch match = SequenceMatch(
            i: 0,
            j: token.length - 1,
            token: token,
            sequenceName: '',
            sequenceSpace: 0,
            ascending: ascending,
          );
          expect(
            sequenceScoring(match),
            guesses,
          );
        },
      );
    }
  });
}
