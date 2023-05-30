import 'package:test/test.dart';
import 'package:zxcvbnm/src/types.dart';

void checkMatches(
  String prefix,
  List<Match> matches,
  Pattern patternNames,
  List<String> patterns,
  List<List<int>> ijs,
  Map<String, List<Object>> props,
) {
  final List<Pattern> usedPatternNames =
      patterns.map((String pattern) => patternNames).toList();
  bool isEqualLenArgs = usedPatternNames.length == patterns.length &&
      patterns.length == ijs.length;

  for (final String prop in props.keys) {
    final List<Object> lst = props[prop]!;
    isEqualLenArgs = isEqualLenArgs && lst.length == patterns.length;
  }
  if (!isEqualLenArgs) {
    throw Exception('Unequal argument lists to check_matches.');
  }
  test('$prefix: matches.length == ${patterns.length}', () {
    expect(matches.length, patterns.length);
  });
  for (int k = 0; k < patterns.length; k += 1) {
    final Match match = matches[k];
    final Pattern patternName = usedPatternNames[k];
    final String pattern = patterns[k];
    final int i = ijs[k][0];
    final int j = ijs[k][1];
    test('$prefix: matches[$k].pattern == $usedPatternNames', () {
      expect(match.pattern, patternName);
    });
    test('$prefix: matches[$k] should have [i, j] of [$i, $j]', () {
      expect(<int>[match.i, match.j], <int>[i, j]);
    });
    test("$prefix: matches[$k].token == '$pattern'", () {
      expect(match.token, pattern);
    });

    for (final String propName in props.keys) {
      final List<Object> propList = props[propName]!;
      Object propMsg = propList[k];
      if (propMsg is String) propMsg = "'$propMsg'";
      test('$prefix: matches[$k].$propName == $propMsg', () {
        expect(match[propName], propList[k]);
      });
    }
  }
}
