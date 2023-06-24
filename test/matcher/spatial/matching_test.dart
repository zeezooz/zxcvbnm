import 'package:test/test.dart';
import 'package:zxcvbnm/languages/common.dart';
import 'package:zxcvbnm/src/matcher/spatial/matching.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

class SpatialMatchTest extends SpatialMatch {
  SpatialMatchTest({
    required int i,
    required int j,
    required String token,
    required String graph,
    required int turns,
    required int shiftedCount,
  }) : super(
          i: i,
          j: j,
          token: token,
          graph: graph,
          turns: turns,
          shiftedCount: shiftedCount,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is SpatialMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      graph == other.graph &&
      turns == other.turns &&
      shiftedCount == other.shiftedCount;
}

void main() {
  group('Spatial matching.', () {
    final Options options = Options(
      graph: <String, GraphEntry>{
        'qwerty': adjacencyGraph['qwerty']!,
      },
    );
    final MatchSpatial matchSpatial = MatchSpatial(options);

    test(
      "Doesn't match 1- and 2-character spatial patterns.",
      () {
        const List<String> passwords = <String>['', '/', 'qw', '*/'];
        for (final String password in passwords) {
          expect(
            matchSpatial.match(password),
            <SpatialMatchTest>[],
          );
        }
      },
    );

    test(
      'Matches against spatial patterns surrounded by non-spatial patterns.',
      () {
        const String pattern = '6tfGHJ';
        expect(
          matchSpatial.match('rz!$pattern%z'),
          <SpatialMatchTest>[
            SpatialMatchTest(
              i: 3,
              j: 3 + pattern.length - 1,
              token: pattern,
              graph: 'qwerty',
              turns: 2,
              shiftedCount: 3,
            ),
          ],
        );
      },
    );
  });

  group('Spatial matching specific patterns vs keyboards.', () {
    const List<List<Object>> data = <List<Object>>[
      <Object>['12345', 'qwerty', 1, 0],
      <Object>['@WSX', 'qwerty', 1, 4],
      <Object>['6tfGHJ', 'qwerty', 2, 3],
      <Object>['hGFd', 'qwerty', 1, 2],
      <Object>['/;p09876yhn', 'qwerty', 3, 0],
      <Object>['Xdr%', 'qwerty', 1, 2],
      <Object>['159-', 'keypad', 1, 0],
      <Object>['*84', 'keypad', 1, 0],
      <Object>['/8520', 'keypad', 1, 0],
      <Object>['369', 'keypad', 1, 0],
      <Object>['/963.', 'keypadMac', 1, 0],
      <Object>['*-632.0214', 'keypadMac', 9, 0],
      <Object>['aoEP%yIxkjq:', 'dvorak', 4, 5],
      <Object>[';qoaOQ:Aoq;a', 'dvorak', 11, 4],
    ];
    for (final List<Object> item in data) {
      final String pattern = item[0] as String;
      final String keyboard = item[1] as String;
      final int turns = item[2] as int;
      final int shifts = item[3] as int;
      test(
        "Matches '$pattern' as a $keyboard pattern.",
        () {
          final Options options = Options(
            graph: <String, GraphEntry>{
              keyboard: adjacencyGraph[keyboard]!,
            },
          );
          final MatchSpatial matchSpatial = MatchSpatial(options);
          expect(
            matchSpatial.match(pattern),
            <SpatialMatchTest>[
              SpatialMatchTest(
                i: 0,
                j: pattern.length - 1,
                token: pattern,
                graph: keyboard,
                turns: turns,
                shiftedCount: shifts,
              ),
            ],
          );
        },
      );
    }
  });
}
