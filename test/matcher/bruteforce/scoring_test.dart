import 'package:test/test.dart';
import 'package:zxcvbnm/src/data/const.dart';
import 'package:zxcvbnm/src/matcher/bruteforce/scoring.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('scoring: guesses bruteforce', () {
    test(
      'should be Exponentiation of $bruteforceCardinality and the token length',
      () {
        expect(
          bruteforceScoring(BruteForceMatch(i: 0, j: 0, token: 'a' * 2)),
          1e2,
        );
        expect(
          bruteforceScoring(BruteForceMatch(i: 0, j: 0, token: 'a' * 123)),
          1e123,
        );
        expect(
          bruteforceScoring(BruteForceMatch(i: 0, j: 0, token: 'a' * 308)),
          1e308,
        );
      },
    );
    test(
      'should be ${double.maxFinite} from double.maxFinite',
      () {
        expect(
          bruteforceScoring(BruteForceMatch(i: 0, j: 0, token: 'a' * 309)),
          double.maxFinite,
        );
      },
    );
    test(
      'should be $minSubmatchGuessesSingleChar from minSubmatchGuessesSingleChar',
      () {
        expect(
          bruteforceScoring(BruteForceMatch(i: 0, j: 0, token: 'a')),
          11,
        );
      },
    );
    // TODO this can't be reached because min guesses is 51 and with a password length of 2 you get 100 already
    test(
      'should be $minSubmatchGuessesMultiChar from minSubmatchGuessesMultiChar',
      () {
        expect(
          bruteforceScoring(BruteForceMatch(i: 0, j: 0, token: 'ab')),
          51,
        );
      },
      skip: "can't be reached",
    );
  });
}
