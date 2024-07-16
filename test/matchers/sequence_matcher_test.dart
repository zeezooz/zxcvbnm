import 'package:test/test.dart';
import 'package:zxcvbnm/src/matchers/sequence_matcher.dart';

import '../helpers/generate_passwords.dart';

void main() {
  group('SequenceMatcher.', () {
    final SequenceMatcher sequenceMatcher = SequenceMatcher();

    test(
      "Doesn't match without sequences.",
      () {
        const List<String> passwords = <String>['', 'a', '1'];
        for (final String password in passwords) {
          expect(
            sequenceMatcher.match(password),
            <List<SequenceMatchTest>>[<SequenceMatchTest>[]],
          );
        }
      },
    );

    test(
      'Matches overlapping patterns.',
      () => expect(
        sequenceMatcher.match('abcbabc'),
        <List<SequenceMatchTest>>[
          <SequenceMatchTest>[
            SequenceMatchTest(
              password: 'abcbabc',
              start: 0,
              end: 3,
              name: 'lower',
              space: 26,
              ascending: true,
            ),
            SequenceMatchTest(
              password: 'abcbabc',
              start: 2,
              end: 5,
              name: 'lower',
              space: 26,
              ascending: false,
            ),
            SequenceMatchTest(
              password: 'abcbabc',
              start: 4,
              end: 7,
              name: 'lower',
              space: 26,
              ascending: true,
            ),
          ],
        ],
      ),
    );

    const List<String> prefixes = <String>['!', '22'];
    const List<String> suffixes = <String>['!', '22'];
    const String token = 'jihg';
    final List<IndexedPassword> passwords =
        generatePasswords(token, prefixes, suffixes);
    for (final IndexedPassword password in passwords) {
      test(
        'Matches embedded sequence in ${password.password}.',
        () => expect(
          sequenceMatcher.match(password.password),
          <List<SequenceMatchTest>>[
            <SequenceMatchTest>[
              SequenceMatchTest(
                password: password.password,
                start: password.start,
                end: password.end,
                name: 'lower',
                space: 26,
                ascending: false,
              ),
            ],
          ],
        ),
      );
    }

    const List<List<Object>> data = <List<Object>>[
      <Object>['ABC', 'upper', 26, true],
      <Object>['CBA', 'upper', 26, false],
      <Object>['PQR', 'upper', 26, true],
      <Object>['RQP', 'upper', 26, false],
      <Object>['XYZ', 'upper', 26, true],
      <Object>['ZYX', 'upper', 26, false],
      <Object>['abcd', 'lower', 26, true],
      <Object>['dcba', 'lower', 26, false],
      <Object>['jihg', 'lower', 26, false],
      <Object>['wxyz', 'lower', 26, true],
      <Object>['zxvt', 'lower', 26, false],
      <Object>['0369', 'digits', 10, true],
      <Object>['97531', 'digits', 10, false],
    ];
    for (final List<Object> item in data) {
      final String password = item[0] as String;
      final String name = item[1] as String;
      final int space = item[2] as int;
      final bool ascending = item[3] as bool;
      test(
        "Matches '$password' as a '$name' sequence.",
        () => expect(
          sequenceMatcher.match(password),
          <List<SequenceMatchTest>>[
            <SequenceMatchTest>[
              SequenceMatchTest(
                password: password,
                start: 0,
                end: password.length,
                name: name,
                space: space,
                ascending: ascending,
              ),
            ],
          ],
        ),
      );
    }
  });

  group('SequenceMatch guesses.', () {
    const List<List<Object>> data = <List<Object>>[
      <Object>['ab', true, 4 * 2], // obvious start * len 2
      <Object>['XYZ', true, 26 * 3], // base26 * len 3
      <Object>['4567', true, 10 * 4], // base10 * len 4
      <Object>['7654', false, 10 * 4 * 2], // base10 * len 4 * descending
      <Object>['ZYX', false, 4 * 3 * 2], // obvious start * len 3 * descending
    ];
    for (final List<Object> item in data) {
      final String token = item[0] as String;
      final bool ascending = item[1] as bool;
      final int guesses = item[2] as int;
      test(
        "The sequence pattern '$token'.",
        () {
          final SequenceMatch match = SequenceMatch(
            password: token,
            start: 0,
            end: token.length,
            name: '',
            space: 0,
            ascending: ascending,
          );
          expect(
            match.estimatedGuesses,
            guesses,
          );
        },
      );
    }
  });
}

class SequenceMatchTest extends SequenceMatch {
  SequenceMatchTest({
    required String password,
    required int start,
    required int end,
    required String name,
    required int space,
    required bool ascending,
    double? guesses,
  })  : guessesTest = guesses,
        super(
          password: password,
          start: start,
          end: end,
          name: name,
          space: space,
          ascending: ascending,
        );

  final double? guessesTest;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is SequenceMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      name == other.name &&
      space == other.space &&
      ascending == other.ascending &&
      (guessesTest == null || guessesTest == other.guesses);
}
