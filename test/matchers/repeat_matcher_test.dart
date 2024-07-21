import 'package:test/test.dart';
import 'package:zxcvbnm/src/helper.dart';
import 'package:zxcvbnm/src/matchers/repeat_matcher.dart';
import 'package:zxcvbnm/src/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/scoring.dart';

import '../helpers/generate_passwords.dart';

void main() {
  group('RepeatMatcher.', () {
    final Options options = Options();
    final OmniMatcher omniMatcher = OmniMatcher(options);
    final RepeatMatcher repeatMatcher = RepeatMatcher(omniMatcher);

    test("Doesn't match without repeats.", () {
      const List<String> passwords = <String>['', '#'];
      for (final String password in passwords) {
        expect(
          repeatMatcher.match(password),
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
            repeatMatcher.match(password.password),
            <List<RepeatMatchTest>>[
              <RepeatMatchTest>[
                RepeatMatchTest(
                  password: password.password,
                  start: password.start,
                  end: password.end,
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
              repeatMatcher.match(password),
              <List<RepeatMatchTest>>[
                <RepeatMatchTest>[
                  RepeatMatchTest(
                    password: password,
                    start: 0,
                    end: password.length,
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
        repeatMatcher.match('BBB1111aaaaa@@@@@@'),
        <List<RepeatMatchTest>>[
          <RepeatMatchTest>[
            RepeatMatchTest(
              password: 'BBB1111aaaaa@@@@@@',
              start: 0,
              end: 3,
              baseToken: 'B',
              baseGuesses: 12,
              repeatCount: 3,
            ),
            RepeatMatchTest(
              password: 'BBB1111aaaaa@@@@@@',
              start: 3,
              end: 7,
              baseToken: '1',
              baseGuesses: 12,
              repeatCount: 4,
            ),
            RepeatMatchTest(
              password: 'BBB1111aaaaa@@@@@@',
              start: 7,
              end: 12,
              baseToken: 'a',
              baseGuesses: 12,
              repeatCount: 5,
            ),
            RepeatMatchTest(
              password: 'BBB1111aaaaa@@@@@@',
              start: 12,
              end: 18,
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
        repeatMatcher.match('2818BBBbzsdf1111@*&@!aaaaaEUDA@@@@@@1729'),
        <List<RepeatMatchTest>>[
          <RepeatMatchTest>[
            RepeatMatchTest(
              password: '2818BBBbzsdf1111@*&@!aaaaaEUDA@@@@@@1729',
              start: 4,
              end: 7,
              baseToken: 'B',
              baseGuesses: 12,
              repeatCount: 3,
            ),
            RepeatMatchTest(
              password: '2818BBBbzsdf1111@*&@!aaaaaEUDA@@@@@@1729',
              start: 12,
              end: 16,
              baseToken: '1',
              baseGuesses: 12,
              repeatCount: 4,
            ),
            RepeatMatchTest(
              password: '2818BBBbzsdf1111@*&@!aaaaaEUDA@@@@@@1729',
              start: 21,
              end: 26,
              baseToken: 'a',
              baseGuesses: 12,
              repeatCount: 5,
            ),
            RepeatMatchTest(
              password: '2818BBBbzsdf1111@*&@!aaaaaEUDA@@@@@@1729',
              start: 30,
              end: 36,
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
          repeatMatcher.match(password),
          <List<RepeatMatchTest>>[
            <RepeatMatchTest>[
              RepeatMatchTest(
                password: password,
                start: 0,
                end: password.length,
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
          repeatMatcher.match(password),
          <List<RepeatMatchTest>>[
            <RepeatMatchTest>[
              RepeatMatchTest(
                password: password,
                start: 0,
                end: password.length,
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
          repeatMatcher.match(password),
          <List<RepeatMatchTest>>[
            <RepeatMatchTest>[
              RepeatMatchTest(
                password: password,
                start: 0,
                end: password.length,
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

  group('RepeatMatch guesses.', () {
    final Options options = Options();
    final OmniMatcher omniMatcher = OmniMatcher(options);
    const List<List<Object>> data = <List<Object>>[
      <Object>['a', 2],
      <Object>['9', 3],
      <Object>[r'$', 4],
      <Object>['ab', 2],
      <Object>['batterystaple', 3],
    ];
    for (final List<Object> item in data) {
      final String baseToken = item[0] as String;
      final int repeatCount = item[1] as int;
      final String token = baseToken * repeatCount;
      test(
        "The repeat pattern '$token'.",
        () {
          final double baseGuesses = mostGuessableMatchSequence(
            baseToken,
            synchronousMatches(omniMatcher.match(baseToken)),
          ).guesses;
          final RepeatMatch match = RepeatMatch(
            password: token,
            start: 0,
            end: token.length,
            baseToken: baseToken,
            baseGuesses: baseGuesses,
          );
          expect(
            match.estimatedGuesses,
            baseGuesses * repeatCount,
          );
        },
      );
    }
  });
}

class RepeatMatchTest extends RepeatMatch {
  RepeatMatchTest({
    required String password,
    required int start,
    required int end,
    required String baseToken,
    required double baseGuesses,
    int? repeatCount,
    double? guesses,
  })  : repeatCountTest = repeatCount,
        guessesTest = guesses,
        super(
          password: password,
          start: start,
          end: end,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
        );

  final int? repeatCountTest;
  final double? guessesTest;

  @override
  int get repeatCount => repeatCountTest ?? super.repeatCount;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is RepeatMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      baseToken == other.baseToken &&
      baseGuesses == other.baseGuesses &&
      (repeatCountTest == null || repeatCountTest == other.repeatCount) &&
      (guessesTest == null || guessesTest == other.guesses);
}
