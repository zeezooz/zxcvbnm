import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/matchers.dart';
import 'package:zxcvbnm/options.dart';

import 'matchers/date_matcher_test.dart';
import 'matchers/dictionary_matcher_test.dart';
import 'matchers/l33t_matcher_test.dart';
import 'matchers/repeat_matcher_test.dart';

void main() {
  group('Omnimatch matching.', () {
    final Options options = Options(
      dictionaries: dictionaries,
    );
    final OmniMatcher omniMatcher = OmniMatcher(options);

    test(
      "Doesn't match ''.",
      () => expect(
        omniMatcher.match(''),
        <List<BaseMatch>>[<BaseMatch>[]],
      ),
    );

    test(
      'Match r0sebudmaelstrom11/20/91aaaa',
      () => expect(
        omniMatcher.match('r0sebudmaelstrom11/20/91aaaa'),
        <Matcher>[
          containsAll(
            <BaseMatch>[
              L33tMatchTest(
                password: 'r0sebudmaelstrom11/20/91aaaa',
                start: 0,
                end: 7,
                matchedWord: 'rosebud',
                rank: 339,
                dictionary: Dictionary.passwords,
                changes: <PasswordChange>[
                  const PasswordChange(l33t: '0', clean: 'o'),
                ],
                changesDisplay: '0 -> o',
              ),
              DictionaryMatchTest(
                password: 'r0sebudmaelstrom11/20/91aaaa',
                start: 7,
                end: 15,
                matchedWord: 'maelstro',
                rank: 47962,
                dictionary: Dictionary.passwords,
              ),
              DateMatchTest(
                password: 'r0sebudmaelstrom11/20/91aaaa',
                start: 16,
                end: 24,
                separator: '/',
                year: 1991,
                month: 11,
                day: 20,
              ),
              RepeatMatchTest(
                password: 'r0sebudmaelstrom11/20/91aaaa',
                start: 24,
                end: 28,
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
