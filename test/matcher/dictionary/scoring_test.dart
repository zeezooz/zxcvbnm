import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/scoring.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/l33t.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/uppercase.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Dictionary scoring.', () {
    final Options options = Options();

    test(
      'Base guesses.',
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: 'aaaaa',
          start: 0,
          end: 5,
          matchedWord: 'aaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          options: options,
        );
        expect(
          dictionaryScoring(match),
          32,
        );
      },
    );

    test(
      'Capitalization.',
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: 'AAAaaa',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          options: options,
        );
        expect(
          dictionaryScoring(match),
          32 * uppercaseScoring(match),
        );
      },
    );

    test(
      'Word is reversed.',
      () {
        final ReverseMatch match = ReverseMatch(
          password: 'aaa',
          start: 0,
          end: 3,
          matchedWord: 'aaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          options: options,
        );
        expect(
          dictionaryScoring(match),
          32 * 2,
        );
      },
    );

    test(
      'Common l33t substitutions.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'aaa@@@',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '@', clean: 'a')],
          changesDisplay: '@ -> a',
          options: options,
        );
        expect(
          dictionaryScoring(match),
          32 * l33tScoring(match),
        );
      },
    );

    test(
      'Both capitalization and common l33t substitutions.',
      () {
        final L33tMatch match = L33tMatch(
          password: 'AaA@@@',
          start: 0,
          end: 6,
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '@', clean: 'a')],
          changesDisplay: '@ -> a',
          options: options,
        );
        expect(
          dictionaryScoring(match),
          32 * uppercaseScoring(match) * l33tScoring(match),
        );
      },
    );

    test(
      'Diceware findings.',
      () {
        final DictionaryMatch match = DictionaryMatch(
          password: 'AaA@@@',
          start: 0,
          end: 6,
          matchedWord: 'AaA@@@',
          rank: 32,
          dictionary: Dictionary.diceware,
          options: options,
        );
        expect(
          dictionaryScoring(match),
          3888,
        );
      },
    );
  });
}
