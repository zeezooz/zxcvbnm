import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart' hide Matcher;

import 'matcher/date/matching_test.dart';
import 'matcher/dictionary/matching_test.dart';
import 'matcher/dictionary/variants/matching/l33t_test.dart';
import 'matcher/repeat/matching_test.dart';

void main() {
  group('Omnimatch matching.', () {
    final Options options = Options(
      translation: translation,
      dictionaries: dictionaries,
    );
    final OmniMatch omniMatch = OmniMatch(options);

    test(
      "Doesn't match ''.",
      () => expect(
        omniMatch.match(''),
        <List<Match>>[<Match>[]],
      ),
    );

    test(
      'Match r0sebudmaelstrom11/20/91aaaa',
      () => expect(
        omniMatch.match('r0sebudmaelstrom11/20/91aaaa'),
        <Matcher>[
          containsAll(
            <Match>[
              L33tMatchTest(
                i: 0,
                j: 6,
                token: 'r0sebud',
                matchedWord: 'rosebud',
                rank: 339,
                dictionary: Dictionary.passwords,
                changes: <PasswordChange>[
                  PasswordChange(l33t: '0', clean: 'o'),
                ],
                changesDisplay: '0 -> o',
              ),
              DictionaryMatchTest(
                i: 7,
                j: 14,
                token: 'maelstro',
                matchedWord: 'maelstro',
                rank: 47962,
                dictionary: Dictionary.passwords,
              ),
              DateMatchTest(
                i: 16,
                j: 23,
                token: '11/20/91',
                separator: '/',
                year: 1991,
                month: 11,
                day: 20,
              ),
              RepeatMatchTest(
                i: 24,
                j: 27,
                token: 'aaaa',
                baseToken: 'a',
                baseGuesses: 12,
                repeatCount: 4,
              ),
            ],
          ),
        ],
      ),
    );
  });
}
