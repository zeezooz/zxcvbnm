import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/sequence/matching.dart';
import 'package:zxcvbnm/src/types.dart';

import '../../helper/generate_passwords.dart';

class SequenceMatchTest extends SequenceMatch {
  SequenceMatchTest({
    required int i,
    required int j,
    required String token,
    required String sequenceName,
    required int sequenceSpace,
    required bool ascending,
  }) : super(
          i: i,
          j: j,
          token: token,
          sequenceName: sequenceName,
          sequenceSpace: sequenceSpace,
          ascending: ascending,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is SequenceMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      sequenceName == other.sequenceName &&
      sequenceSpace == other.sequenceSpace &&
      ascending == other.ascending;
}

void main() {
  group('Sequence matching.', () {
    final MatchSequence matchSequence = MatchSequence();

    test(
      "Doesn't match length sequences.",
      () {
        const List<String> passwords = <String>['', 'a', '1'];
        for (final String password in passwords) {
          expect(
            matchSequence.match(password),
            <SequenceMatchTest>[],
          );
        }
      },
    );

    test(
      'Matches overlapping patterns.',
      () => expect(
        matchSequence.match('abcbabc'),
        <SequenceMatchTest>[
          SequenceMatchTest(
            i: 0,
            j: 2,
            token: 'abc',
            sequenceName: 'lower',
            sequenceSpace: 26,
            ascending: true,
          ),
          SequenceMatchTest(
            i: 2,
            j: 4,
            token: 'cba',
            sequenceName: 'lower',
            sequenceSpace: 26,
            ascending: false,
          ),
          SequenceMatchTest(
            i: 4,
            j: 6,
            token: 'abc',
            sequenceName: 'lower',
            sequenceSpace: 26,
            ascending: true,
          ),
        ],
      ),
    );

    const List<String> prefixes = <String>['!', '22'];
    const List<String> suffixes = <String>['!', '22'];
    const String pattern = 'jihg';
    final List<IndexedPassword> passwords =
        generatePasswords(pattern, prefixes, suffixes);
    for (final IndexedPassword password in passwords) {
      test(
        'Matches embedded sequence patterns ${password.password}.',
        () => expect(
          matchSequence.match(password.password),
          <SequenceMatchTest>[
            SequenceMatchTest(
              i: password.i,
              j: password.j,
              token: pattern,
              sequenceName: 'lower',
              sequenceSpace: 26,
              ascending: false,
            ),
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
      final String pattern = item[0] as String;
      final String name = item[1] as String;
      final int space = item[2] as int;
      final bool isAscending = item[3] as bool;
      test(
        "Matches '$pattern' as a '$name' sequence.",
        () => expect(
          matchSequence.match(pattern),
          <SequenceMatchTest>[
            SequenceMatchTest(
              i: 0,
              j: pattern.length - 1,
              token: pattern,
              sequenceName: name,
              sequenceSpace: space,
              ascending: isAscending,
            ),
          ],
        ),
      );
    }
  });
}
