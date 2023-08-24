import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/bruteforce/scoring.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Bruteforce scoring.', () {
    test(
      'Token length.',
      () {
        expect(
          bruteforceScoring(
            BruteForceMatch(password: 'a' * 2, start: 0, end: 2),
          ),
          1e2,
        );
        expect(
          bruteforceScoring(
            BruteForceMatch(password: 'a' * 123, start: 0, end: 123),
          ),
          1e123,
        );
        expect(
          bruteforceScoring(
            BruteForceMatch(password: 'a' * 308, start: 0, end: 308),
          ),
          1e308,
        );
      },
    );

    test(
      'Overflow.',
      () => expect(
        bruteforceScoring(
          BruteForceMatch(password: 'a' * 309, start: 0, end: 309),
        ),
        double.maxFinite,
      ),
    );

    test(
      'Min guesses for single character.',
      () => expect(
        bruteforceScoring(
          BruteForceMatch(password: 'a', start: 0, end: 1),
        ),
        11,
      ),
    );

    test(
      'Min guesses for multiple characters.',
      () => expect(
        bruteforceScoring(
          BruteForceMatch(password: 'ab', start: 0, end: 2),
        ),
        51,
      ),
      skip: "This can't be reached because min guesses is 51 and with"
          ' a password length of 2 you get 100 already.',
    );
  });
}
