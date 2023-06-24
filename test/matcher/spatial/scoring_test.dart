import 'package:test/test.dart';
import 'package:zxcvbnm/languages/common.dart';
import 'package:zxcvbnm/src/matcher/spatial/scoring.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Spatial scoring.', () {
    final Options options = Options(graph: adjacencyGraph);

    test(
      'With no turns or shifts, guesses is starts * degree * (len-1).',
      () {
        final SpatialMatch match = SpatialMatch(
          i: 0,
          j: 5,
          token: 'zxcvbn',
          graph: 'qwerty',
          turns: 1,
          shiftedCount: 0,
        );
        expect(
          spatialScoring(match, options),
          2160,
        );
      },
    );

    test(
      'Guesses is added for shifted keys, similar to capitals in dictionary matching,',
      () {
        final SpatialMatch match = SpatialMatch(
          i: 0,
          j: 5,
          token: 'ZxCvbn',
          graph: 'qwerty',
          turns: 1,
          shiftedCount: 2,
        );
        expect(
          spatialScoring(match, options),
          45360,
        );
      },
    );

    test(
      'When everything is shifted, guesses are doubled.',
      () {
        final SpatialMatch match = SpatialMatch(
          i: 0,
          j: 5,
          token: 'ZXCVBN',
          graph: 'qwerty',
          turns: 1,
          shiftedCount: 6,
        );
        expect(
          spatialScoring(match, options),
          4320,
        );
      },
    );

    test(
      'Spatial guesses accounts for turn positions, directions and starting keys.',
      () {
        final SpatialMatch match = SpatialMatch(
          i: 0,
          j: 7,
          token: 'zxcft6yh',
          graph: 'qwerty',
          turns: 3,
          shiftedCount: 0,
        );
        expect(
          spatialScoring(match, options),
          558461,
        );
      },
    );
  });
}
