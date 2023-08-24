import 'package:test/test.dart';
import 'package:zxcvbnm/src/helper.dart';
import 'package:zxcvbnm/src/matcher/repeat/scoring.dart';
import 'package:zxcvbnm/src/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/scoring/index.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Repeat scoring.', () {
    final Options options = Options();
    final OmniMatch omniMatch = OmniMatch(options);
    const List<List<Object>> data = <List<Object>>[
      <Object>['a', 2],
      <Object>['9', 3],
      <Object>[r'$', 4],
      <Object>['ab', 2],
      <Object>['batterystaple', 3],
    ];
    for (final List<Object> item in data) {
      final String baseToken = item[0] as String;
      final int repeatCount = item[1] as int;
      final String token = baseToken * repeatCount;
      test(
        "The repeat pattern '$token'.",
        () {
          final double baseGuesses = mostGuessableMatchSequence(
            baseToken,
            synchronousMatches(omniMatch.match(baseToken)),
            options,
          ).guesses;
          final RepeatMatch match = RepeatMatch(
            password: token,
            start: 0,
            end: token.length,
            baseToken: baseToken,
            baseGuesses: baseGuesses,
            repeatCount: repeatCount,
            options: options,
          );
          expect(
            repeatScoring(match),
            baseGuesses * repeatCount,
          );
        },
      );
    }
  });
}
