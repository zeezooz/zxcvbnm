import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/repeat/matching.dart';
import 'package:zxcvbnm/src/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

import '../../helper/generate_passwords.dart';

class RepeatMatchTest extends RepeatMatch {
  RepeatMatchTest({
    required int i,
    required int j,
    required String token,
    required String baseToken,
    required double baseGuesses,
    required int repeatCount,
  }) : super(
          i: i,
          j: j,
          token: token,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
          repeatCount: repeatCount,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is RepeatMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      baseToken == other.baseToken &&
      baseGuesses == other.baseGuesses &&
      repeatCount == other.repeatCount;
}

void main() {
  group('Repeat matching.', () {
    final Options options = Options();
    final OmniMatch omniMatch = OmniMatch(options);
    final MatchRepeat matchRepeat = MatchRepeat(omniMatch);

    test("Doesn't match without repeats.", () {
      const List<String> passwords = <String>['', '#'];
      for (final String password in passwords) {
        expect(
          matchRepeat.match(password),
          <List<RepeatMatchTest>>[<RepeatMatchTest>[]],
        );
      }
    });

    test(
      'Matches embedded repeat patterns.',
      () {
        const List<String> prefixes = <String>['@', 'y4@'];
        const List<String> suffixes = <String>['u', 'u%7'];
        const String token = '&&&&&';
        final List<IndexedPassword> passwords =
            generatePasswords(token, prefixes, suffixes);
        for (final IndexedPassword password in passwords) {
          expect(
            matchRepeat.match(password.password),
            <List<RepeatMatchTest>>[
              <RepeatMatchTest>[
                RepeatMatchTest(
                  i: password.i,
                  j: password.j,
                  token: token,
                  baseToken: '&',
                  baseGuesses: 12,
                  repeatCount: token.length,
                ),
              ],
            ],
          );
        }
      },
    );

    const List<int> lengths = <int>[3, 12];
    const List<String> characters = <String>['a', 'Z', '4', '&'];
    for (final String character in characters) {
      test(
        "Matches repeats with base character '$character'.",
        () {
          for (final int length in lengths) {
            final String password = character * length;
            expect(
              matchRepeat.match(password),
              <List<RepeatMatchTest>>[
                <RepeatMatchTest>[
                  RepeatMatchTest(
                    i: 0,
                    j: password.length - 1,
                    token: password,
                    baseToken: character,
                    baseGuesses: 12,
                    repeatCount: length,
                  ),
                ],
              ],
            );
          }
        },
      );
    }

    test(
      'Matches multiple adjacent repeats.',
      () => expect(
        matchRepeat.match('BBB1111aaaaa@@@@@@'),
        <List<RepeatMatchTest>>[
          <RepeatMatchTest>[
            RepeatMatchTest(
              i: 0,
              j: 2,
              token: 'BBB',
              baseToken: 'B',
              baseGuesses: 12,
              repeatCount: 3,
            ),
            RepeatMatchTest(
              i: 3,
              j: 6,
              token: '1111',
              baseToken: '1',
              baseGuesses: 12,
              repeatCount: 4,
            ),
            RepeatMatchTest(
              i: 7,
              j: 11,
              token: 'aaaaa',
              baseToken: 'a',
              baseGuesses: 12,
              repeatCount: 5,
            ),
            RepeatMatchTest(
              i: 12,
              j: 17,
              token: '@@@@@@',
              baseToken: '@',
              baseGuesses: 12,
              repeatCount: 6,
            ),
          ],
        ],
      ),
    );

    test(
      'Matches multiple repeats with non-repeats in-between.',
      () => expect(
        matchRepeat.match('2818BBBbzsdf1111@*&@!aaaaaEUDA@@@@@@1729'),
        <List<RepeatMatchTest>>[
          <RepeatMatchTest>[
            RepeatMatchTest(
              i: 4,
              j: 6,
              token: 'BBB',
              baseToken: 'B',
              baseGuesses: 12,
              repeatCount: 3,
            ),
            RepeatMatchTest(
              i: 12,
              j: 15,
              token: '1111',
              baseToken: '1',
              baseGuesses: 12,
              repeatCount: 4,
            ),
            RepeatMatchTest(
              i: 21,
              j: 25,
              token: 'aaaaa',
              baseToken: 'a',
              baseGuesses: 12,
              repeatCount: 5,
            ),
            RepeatMatchTest(
              i: 30,
              j: 35,
              token: '@@@@@@',
              baseToken: '@',
              baseGuesses: 12,
              repeatCount: 6,
            ),
          ],
        ],
      ),
    );

    test(
      'Matches multi-character repeat pattern.',
      () {
        const String password = 'abab';
        expect(
          matchRepeat.match(password),
          <List<RepeatMatchTest>>[
            <RepeatMatchTest>[
              RepeatMatchTest(
                i: 0,
                j: password.length - 1,
                token: password,
                baseToken: 'ab',
                baseGuesses: 9,
                repeatCount: 2,
              ),
            ],
          ],
        );
      },
    );

    test(
      'Matches aabaab as a repeat instead of the aa prefix.',
      () {
        const String password = 'aabaab';
        expect(
          matchRepeat.match(password),
          <List<RepeatMatchTest>>[
            <RepeatMatchTest>[
              RepeatMatchTest(
                i: 0,
                j: password.length - 1,
                token: password,
                baseToken: 'aab',
                baseGuesses: 1001,
                repeatCount: 2,
              ),
            ],
          ],
        );
      },
    );

    test(
      'Identifies ab as repeat string, even though abab is also repeated.',
      () {
        const String password = 'abababab';
        expect(
          matchRepeat.match(password),
          <List<RepeatMatchTest>>[
            <RepeatMatchTest>[
              RepeatMatchTest(
                i: 0,
                j: password.length - 1,
                token: password,
                baseToken: 'ab',
                baseGuesses: 9,
                repeatCount: 4,
              ),
            ],
          ],
        );
      },
    );
  });
}
