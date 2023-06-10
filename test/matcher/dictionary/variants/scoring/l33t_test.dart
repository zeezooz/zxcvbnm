import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/scoring/l33t.dart';
import 'package:zxcvbnm/src/scoring/utils.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('L33t scoring.', () {
    test(
      "Extra l33t guesses of '' is 1.",
      () => expect(
        l33tScoring(
          DictionaryMatch(
            i: 0,
            j: 0,
            token: '',
            matchedWord: '',
            rank: 1,
            dictionary: Dictionary.commonWords,
          ),
        ),
        1,
      ),
    );

    test(
      'Extra l33t guesses of a is 1.',
      () => expect(
        l33tScoring(
          DictionaryMatch(
            i: 0,
            j: 1,
            token: 'a',
            matchedWord: 'a',
            rank: 1,
            dictionary: Dictionary.commonWords,
          ),
        ),
        1,
      ),
    );

    test(
      'Extra l33t guesses of 4 is 2.',
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 1,
            token: '4',
            matchedWord: 'a',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
            changesDisplay: '4 -> a',
          ),
        ),
        2,
      ),
    );

    test(
      'Extra l33t guesses of 4pple is 2.',
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 4,
            token: '4pple',
            matchedWord: 'apple',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
            changesDisplay: '4 -> a',
          ),
        ),
        2,
      ),
    );

    test(
      'Extra l33t guesses of abcet is 1.',
      () => expect(
        l33tScoring(
          DictionaryMatch(
            i: 0,
            j: 4,
            token: 'abcet',
            matchedWord: 'abcet',
            rank: 1,
            dictionary: Dictionary.commonWords,
          ),
        ),
        1,
      ),
    );

    test(
      'Extra l33t guesses of 4bcet is 2.',
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 4,
            token: '4bcet',
            matchedWord: 'abcet',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
            changesDisplay: '4 -> a',
          ),
        ),
        2,
      ),
    );

    test(
      'Extra l33t guesses of a8cet is 2.',
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 4,
            token: 'a8cet',
            matchedWord: 'abcet',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: '8', clean: 'b')],
            changesDisplay: '8 -> b',
          ),
        ),
        2,
      ),
    );

    test(
      'Extra l33t guesses of abce+ is 2.',
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 4,
            token: 'abce+',
            matchedWord: 'abcet',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: '+', clean: 't')],
            changesDisplay: '+ -> t',
          ),
        ),
        2,
      ),
    );

    test(
      'Extra l33t guesses of 48cet is 4.',
      () => expect(
        l33tScoring(
          L33tMatch(
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
          ),
        ),
        4,
      ),
    );

    test(
      'Extra l33t guesses of a4a4aa is ${nCk(6, 2) + nCk(6, 1)}.',
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 5,
            token: 'a4a4aa',
            matchedWord: 'aaaaaa',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
            changesDisplay: '4 -> a',
          ),
        ),
        nCk(6, 2) + nCk(6, 1),
      ),
    );

    test(
      'Extra l33t guesses of 4a4a44 is ${nCk(6, 2) + nCk(6, 1)}.',
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 5,
            token: '4a4a44',
            matchedWord: 'aaaaaa',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
            changesDisplay: '4 -> a',
          ),
        ),
        nCk(6, 2) + nCk(6, 1),
      ),
    );

    test(
      'Extra l33t guesses of a44att+ is ${(nCk(4, 2) + nCk(4, 1)) * nCk(3, 1)}.',
      () => expect(
        l33tScoring(
          L33tMatch(
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
          ),
        ),
        (nCk(4, 2) + nCk(4, 1)) * nCk(3, 1),
      ),
    );

    test(
      'Extra l33t guesses of wwwpassvvord is ${nCk(4, 1)}.',
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 11,
            token: 'wwwpassvvord',
            matchedWord: 'wwwpassword',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: 'vv', clean: 'w')],
            changesDisplay: 'vv -> w',
          ),
        ),
        nCk(4, 1),
      ),
    );

    test(
      "Capitalization doesn't affect extra l33t guesses.",
      () => expect(
        l33tScoring(
          L33tMatch(
            i: 0,
            j: 5,
            token: 'Aa44aA',
            matchedWord: 'AaaaaA',
            rank: 1,
            dictionary: Dictionary.commonWords,
            changes: <PasswordChange>[PasswordChange(l33t: '4', clean: 'a')],
            changesDisplay: '4 -> a',
          ),
        ),
        nCk(6, 2) + nCk(6, 1),
      ),
    );
  });
}
