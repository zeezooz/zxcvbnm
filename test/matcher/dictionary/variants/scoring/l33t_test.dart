import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/l33t.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/scoring/utils.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('L33t scoring.', () {
    final Options options = Options();

    test(
      "Extra l33t guesses of ''.",
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: '',
          start: 0,
          end: 0,
          matchedWord: '',
          rank: 1,
          dictionary: Dictionary.commonWords,
          options: options,
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
        final DictionaryMatch match = DictionaryMatch(
          password: 'a',
          start: 0,
          end: 1,
          matchedWord: 'a',
          rank: 1,
          dictionary: Dictionary.commonWords,
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: '4',
          start: 0,
          end: 1,
          matchedWord: 'a',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: '4pple',
          start: 0,
          end: 5,
          matchedWord: 'apple',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
          options: options,
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
        final DictionaryMatch match = DictionaryMatch(
          password: 'abcet',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: '4bcet',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: 'a8cet',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '8', clean: 'b')],
          changesDisplay: '8 -> b',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: 'abce+',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '+', clean: 't')],
          changesDisplay: '+ -> t',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: '48cet',
          start: 0,
          end: 5,
          matchedWord: 'abcet',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            PasswordChange(l33t: '4', clean: 'a'),
            PasswordChange(l33t: '8', clean: 'b'),
          ],
          changesDisplay: '4 -> a, 8 -> b',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: 'a4a4aa',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: '4a4a44',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: 'a44att+',
          start: 0,
          end: 7,
          matchedWord: 'aaaattt',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[
            PasswordChange(l33t: '4', clean: 'a'),
            PasswordChange(l33t: '+', clean: 't'),
          ],
          changesDisplay: '4 -> a, + -> t',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: 'wwwpassvvord',
          start: 0,
          end: 12,
          matchedWord: 'wwwpassword',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: 'vv', clean: 'w')],
          changesDisplay: 'vv -> w',
          options: options,
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
        final L33tMatch match = L33tMatch(
          password: 'Aa44aA',
          start: 0,
          end: 6,
          matchedWord: 'AaaaaA',
          rank: 1,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
          changesDisplay: '4 -> a',
          options: options,
        );
        expect(
          l33tScoring(match),
          nCk(6, 2) + nCk(6, 1),
        );
      },
    );
  });
}
