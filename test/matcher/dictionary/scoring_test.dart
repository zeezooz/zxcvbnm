import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/scoring.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/l33t.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/uppercase.dart';
import 'package:zxcvbnm/src/types.dart';

class DictionaryReturnTest extends DictionaryReturn {
  DictionaryReturnTest({
    required int baseGuesses,
    required int uppercaseVariations,
    required int l33tVariations,
    required int calculation,
  }) : super(
          baseGuesses: baseGuesses,
          uppercaseVariations: uppercaseVariations,
          l33tVariations: l33tVariations,
          calculation: calculation,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is DictionaryReturn &&
      baseGuesses == other.baseGuesses &&
      uppercaseVariations == other.uppercaseVariations &&
      l33tVariations == other.l33tVariations &&
      calculation == other.calculation;
}

void main() {
  group('Dictionary scoring.', () {
    test(
      'Base guesses == the rank.',
      () => expect(
        dictionaryScoring(
          DictionaryMatch(
            i: 0,
            j: 4,
            token: 'aaaaa',
            matchedWord: 'aaaaa',
            rank: 32,
            dictionary: Dictionary.commonWords,
          ),
        ),
        DictionaryReturnTest(
          baseGuesses: 32,
          uppercaseVariations: 1,
          l33tVariations: 1,
          calculation: 32,
        ),
      ),
    );

    test(
      'Extra guesses are added for capitalization.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'AAAaaa',
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
        );
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: 41,
            l33tVariations: 1,
            calculation: 32 * uppercaseScoring(match),
          ),
        );
      },
    );

    test(
      'Guesses are doubled when word is reversed.',
      () => expect(
        dictionaryScoring(
          ReverseMatch(
            i: 0,
            j: 2,
            token: 'aaa',
            matchedWord: 'aaa',
            rank: 32,
            dictionary: Dictionary.commonWords,
          ),
        ),
        DictionaryReturnTest(
          baseGuesses: 32,
          uppercaseVariations: 1,
          l33tVariations: 1,
          calculation: 32 * 2,
        ),
      ),
    );

    test(
      'Extra guesses are added for common l33t substitutions.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 5,
          token: 'aaa@@@',
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '@', clean: 'a')],
          changesDisplay: '@ -> a',
        );
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: 1,
            l33tVariations: 41,
            calculation: 32 * l33tScoring(match),
          ),
        );
      },
    );

    test(
      'Extra guesses are added for both capitalization and common l33t substitutions.',
      () {
        const L33tMatch match = L33tMatch(
          i: 0,
          j: 5,
          token: 'AaA@@@',
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
          changes: <PasswordChange>[PasswordChange(l33t: '@', clean: 'a')],
          changesDisplay: '@ -> a',
        );
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: 3,
            l33tVariations: 41,
            calculation: 32 * l33tScoring(match) * uppercaseScoring(match),
          ),
        );
      },
    );

    test(
      'Special scoring for diceware findings.',
      () => expect(
        dictionaryScoring(
          DictionaryMatch(
            i: 0,
            j: 5,
            token: 'AaA@@@',
            matchedWord: 'AaA@@@',
            rank: 32,
            dictionary: Dictionary.diceware,
          ),
        ),
        DictionaryReturnTest(
          baseGuesses: 32,
          uppercaseVariations: 3,
          l33tVariations: 1,
          calculation: 3888,
        ),
      ),
    );
  });
}
