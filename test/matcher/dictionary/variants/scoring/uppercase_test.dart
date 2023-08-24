import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/uppercase.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/scoring/utils.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Uppercase scoring.', () {
    final Options options = Options();
    final List<List<Object>> data = <List<Object>>[
      <Object>['', 1],
      <Object>['a', 1],
      <Object>['A', 2],
      <Object>['abcdef', 1],
      <Object>['Abcdef', 2],
      <Object>['abcdeF', 2],
      <Object>['ABCDEF', 2],
      <Object>['aBcdef', nCk(6, 1)],
      <Object>['aBcDef', nCk(6, 1) + nCk(6, 2)],
      <Object>['ABCDEf', nCk(6, 1)],
      <Object>['aBCDEf', nCk(6, 1) + nCk(6, 2)],
      <Object>['ABCdef', nCk(6, 1) + nCk(6, 2) + nCk(6, 3)],
    ];
    for (final List<Object> item in data) {
      final String token = item[0] as String;
      final num score = item[1] as num;
      test(
        "Guess multiplier of '$token'.",
        () {
          final DictionaryMatch match = DictionaryMatch(
            password: token,
            start: 0,
            end: token.length,
            matchedWord: token,
            rank: 1,
            dictionary: Dictionary.commonWords,
            options: options,
          );
          expect(
            uppercaseScoring(match),
            score,
          );
        },
      );
    }
  });
}
