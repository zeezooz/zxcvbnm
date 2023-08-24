import 'package:test/test.dart';
import 'package:zxcvbnm/src/data/const.dart';
import 'package:zxcvbnm/src/matcher/separator/scoring.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Separator scoring.', () {
    for (final String token in separatorChars) {
      test(
        "The separator pattern '$token'.",
        () {
          expect(
            separatorScoring(
              SeparatorMatch(password: token, start: 0, end: 1),
            ),
            separatorCharCount,
          );
        },
      );
    }
  });
}
