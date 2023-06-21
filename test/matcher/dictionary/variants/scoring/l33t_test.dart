import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/l33t.dart';
import 'package:zxcvbnm/src/scoring/utils.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('L33t scoring.', () {
    test(
      "Extra l33t guesses of ''.",
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 0,
          token: '',
          matchedWord: '',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          l33tScoring(match),
          1,
        );
      },
    );

    test(
      'Extra l33t guesses of a.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 1,
          token: 'a',
          matchedWord: 'a',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          l33tScoring(match),
          1,
        );
      },
    );

    test(
      'Extra l33t guesses of 4.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 1,
          token: '4',
          matchedWord: 'a',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
        );
        expect(
          l33tScoring(match),
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of 4pple.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 4,
          token: '4pple',
          matchedWord: 'apple',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
        );
        expect(
          l33tScoring(match),
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of abcet.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 4,
          token: 'abcet',
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          l33tScoring(match),
          1,
        );
      },
    );

    test(
      'Extra l33t guesses of 4bcet.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 4,
          token: '4bcet',
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
        );
        expect(
          l33tScoring(match),
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of a8cet.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 4,
          token: 'a8cet',
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '8', clean: 'b')],
          changesDisplay: '8 -> b',
        );
        expect(
          l33tScoring(match),
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of abce+.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 4,
          token: 'abce+',
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '+', clean: 't')],
          changesDisplay: '+ -> t',
        );
        expect(
          l33tScoring(match),
          2,
        );
      },
    );

    test(
      'Extra l33t guesses of 48cet.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 4,
          token: '48cet',
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            PasswordChange(l33t: '4', clean: 'a'),
            PasswordChange(l33t: '8', clean: 'b'),
          ],
          changesDisplay: '4 -> a, 8 -> b',
        );
        expect(
          l33tScoring(match),
          4,
        );
      },
    );

    test(
      'Extra l33t guesses of a4a4aa.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 5,
          token: 'a4a4aa',
          matchedWord: 'aaaaaa',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
        );
        expect(
          l33tScoring(match),
          nCk(6, 2) + nCk(6, 1),
        );
      },
    );

    test(
      'Extra l33t guesses of 4a4a44.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 5,
          token: '4a4a44',
          matchedWord: 'aaaaaa',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
        );
        expect(
          l33tScoring(match),
          nCk(6, 2) + nCk(6, 1),
        );
      },
    );

    test(
      'Extra l33t guesses of a44att+.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 6,
          token: 'a44att+',
          matchedWord: 'aaaattt',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            PasswordChange(l33t: '4', clean: 'a'),
            PasswordChange(l33t: '+', clean: 't'),
          ],
          changesDisplay: '4 -> a, + -> t',
        );
        expect(
          l33tScoring(match),
          (nCk(4, 2) + nCk(4, 1)) * nCk(3, 1),
        );
      },
    );

    test(
      'Extra l33t guesses of wwwpassvvord.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 11,
          token: 'wwwpassvvord',
          matchedWord: 'wwwpassword',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: 'vv', clean: 'w')],
          changesDisplay: 'vv -> w',
        );
        expect(
          l33tScoring(match),
          nCk(4, 1),
        );
      },
    );

    test(
      "Capitalization doesn't affect extra l33t guesses.",
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 5,
          token: 'Aa44aA',
          matchedWord: 'AaaaaA',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
        );
        expect(
          l33tScoring(match),
          nCk(6, 2) + nCk(6, 1),
        );
      },
    );
  });
}
