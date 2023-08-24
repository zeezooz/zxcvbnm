import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/sequence/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

import '../../helper/generate_passwords.dart';

class SequenceMatchTest extends SequenceMatch {
  SequenceMatchTest({
    required String password,
    required int start,
    required int end,
    required String sequenceName,
    required int sequenceSpace,
    required bool ascending,
    double? guesses,
    Options? options,
  })  : guessesTest = guesses,
        super(
          password: password,
          start: start,
          end: end,
          sequenceName: sequenceName,
          sequenceSpace: sequenceSpace,
          ascending: ascending,
          options: options ?? Options(),
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
      sequenceName == other.sequenceName &&
      sequenceSpace == other.sequenceSpace &&
      ascending == other.ascending &&
      (guessesTest == null || guessesTest == other.guesses);
}

void main() {
  group('Sequence matching.', () {
    final Options options = Options();
    final MatchSequence matchSequence = MatchSequence(options);

    test(
      "Doesn't match without sequences.",
      () {
        const List<String> passwords = <String>['', 'a', '1'];
        for (final String password in passwords) {
          expect(
            matchSequence.match(password),
            <List<SequenceMatchTest>>[<SequenceMatchTest>[]],
          );
        }
      },
    );

    test(
      'Matches overlapping patterns.',
      () => expect(
        matchSequence.match('abcbabc'),
        <List<SequenceMatchTest>>[
          <SequenceMatchTest>[
            SequenceMatchTest(
              password: 'abcbabc',
              start: 0,
              end: 3,
              sequenceName: 'lower',
              sequenceSpace: 26,
              ascending: true,
            ),
            SequenceMatchTest(
              password: 'abcbabc',
              start: 2,
              end: 5,
              sequenceName: 'lower',
              sequenceSpace: 26,
              ascending: false,
            ),
            SequenceMatchTest(
              password: 'abcbabc',
              start: 4,
              end: 7,
              sequenceName: 'lower',
              sequenceSpace: 26,
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
          matchSequence.match(password.password),
          <List<SequenceMatchTest>>[
            <SequenceMatchTest>[
              SequenceMatchTest(
                password: password.password,
                start: password.i,
                end: password.j,
                sequenceName: 'lower',
                sequenceSpace: 26,
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
      final String sequenceName = item[1] as String;
      final int sequenceSpace = item[2] as int;
      final bool ascending = item[3] as bool;
      test(
        "Matches '$password' as a '$sequenceName' sequence.",
        () => expect(
          matchSequence.match(password),
          <List<SequenceMatchTest>>[
            <SequenceMatchTest>[
              SequenceMatchTest(
                password: password,
                start: 0,
                end: password.length,
                sequenceName: sequenceName,
                sequenceSpace: sequenceSpace,
                ascending: ascending,
              ),
            ],
          ],
        ),
      );
    }
  });
}
