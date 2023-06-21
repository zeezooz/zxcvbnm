import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/uppercase.dart';
import 'package:zxcvbnm/src/scoring/utils.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Uppercase scoring.', () {
    test(
      "Guess multiplier of ''.",
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
          uppercaseScoring(match),
          1,
        );
      },
    );

    test(
      'Guess multiplier of a.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 0,
          token: 'a',
          matchedWord: 'a',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          1,
        );
      },
    );

    test(
      'Guess multiplier of A.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 0,
          token: 'A',
          matchedWord: 'A',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          2,
        );
      },
    );

    test(
      'Guess multiplier of abcdef.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'abcdef',
          matchedWord: 'abcdef',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          1,
        );
      },
    );

    test(
      'Guess multiplier of Abcdef.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'Abcdef',
          matchedWord: 'Abcdef',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          2,
        );
      },
    );

    test(
      'Guess multiplier of abcdeF.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'abcdeF',
          matchedWord: 'abcdeF',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          2,
        );
      },
    );

    test(
      'Guess multiplier of ABCDEF.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'ABCDEF',
          matchedWord: 'ABCDEF',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          2,
        );
      },
    );

    test(
      'Guess multiplier of aBcdef.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'aBcdef',
          matchedWord: 'aBcdef',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          nCk(6, 1),
        );
      },
    );

    test(
      'Guess multiplier of aBcDef.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'aBcDef',
          matchedWord: 'aBcDef',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          nCk(6, 1) + nCk(6, 2),
        );
      },
    );

    test(
      'Guess multiplier of ABCDEf.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'ABCDEf',
          matchedWord: 'ABCDEf',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          nCk(6, 1),
        );
      },
    );

    test(
      'Guess multiplier of aBCDEf.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'aBCDEf',
          matchedWord: 'aBCDEf',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          nCk(6, 1) + nCk(6, 2),
        );
      },
    );

    test(
      'Guess multiplier of ABCdef.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'ABCdef',
          matchedWord: 'ABCdef',
          rank: 1,
          dictionary: Dictionary.commonWords,
        );
        expect(
          uppercaseScoring(match),
          nCk(6, 1) + nCk(6, 2) + nCk(6, 3),
        );
      },
    );
  });
}
