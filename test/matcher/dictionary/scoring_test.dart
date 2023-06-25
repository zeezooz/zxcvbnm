import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/scoring.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/l33t.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/uppercase.dart';
import 'package:zxcvbnm/src/types.dart';

class DictionaryReturnTest extends DictionaryReturn {
  DictionaryReturnTest({
    required int baseGuesses,
    required double uppercaseVariations,
    required double l33tVariations,
    required double calculation,
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
      'Base guesses.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 4,
          token: 'aaaaa',
          matchedWord: 'aaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
        );
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: 1,
            l33tVariations: 1,
            calculation: 32,
          ),
        );
      },
    );

    test(
      'Capitalization.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'AAAaaa',
          matchedWord: 'aaaaaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
        );
        final double uppercaseVariations = uppercaseScoring(match);
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: uppercaseVariations,
            l33tVariations: 1,
            calculation: 32 * uppercaseVariations,
          ),
        );
      },
    );

    test(
      'Word is reversed.',
      () {
        const ReverseMatch match = ReverseMatch(
          i: 0,
          j: 2,
          token: 'aaa',
          matchedWord: 'aaa',
          rank: 32,
          dictionary: Dictionary.commonWords,
        );
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: 1,
            l33tVariations: 1,
            calculation: 32 * 2,
          ),
        );
      },
    );

    test(
      'Common l33t substitutions.',
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
        final double l33tVariations = l33tScoring(match);
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: 1,
            l33tVariations: l33tVariations,
            calculation: 32 * l33tVariations,
          ),
        );
      },
    );

    test(
      'Both capitalization and common l33t substitutions.',
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
        final double uppercaseVariations = uppercaseScoring(match);
        final double l33tVariations = l33tScoring(match);
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: uppercaseVariations,
            l33tVariations: l33tVariations,
            calculation: 32 * uppercaseVariations * l33tVariations,
          ),
        );
      },
    );

    test(
      'Diceware findings.',
      () {
        const DictionaryMatch match = DictionaryMatch(
          i: 0,
          j: 5,
          token: 'AaA@@@',
          matchedWord: 'AaA@@@',
          rank: 32,
          dictionary: Dictionary.diceware,
        );
        expect(
          dictionaryScoring(match),
          DictionaryReturnTest(
            baseGuesses: 32,
            uppercaseVariations: 3,
            l33tVariations: 1,
            calculation: 3888,
          ),
        );
      },
    );
  });
}
