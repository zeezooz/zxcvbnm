import 'package:test/test.dart';
import 'package:zxcvbnm/languages/common.dart';
import 'package:zxcvbnm/src/matcher/spatial/scoring.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Spatial scoring.', () {
    final Options options = Options(graph: adjacencyGraph);

    test(
      'No turns or shifts.',
      () {
        final SpatialMatch match = SpatialMatch(
          password: 'zxcvbn',
          start: 0,
          end: 6,
          graph: 'qwerty',
          turns: 1,
          shiftedCount: 0,
          options: options,
        );
        expect(
          spatialScoring(match, options),
          2160,
        );
      },
    );

    test(
      'Shifted keys.',
      () {
        final SpatialMatch match = SpatialMatch(
          password: 'ZxCvbn',
          start: 0,
          end: 6,
          graph: 'qwerty',
          turns: 1,
          shiftedCount: 2,
          options: options,
        );
        expect(
          spatialScoring(match, options),
          45360,
        );
      },
    );

    test(
      'Everything is shifted.',
      () {
        final SpatialMatch match = SpatialMatch(
          password: 'ZXCVBN',
          start: 0,
          end: 6,
          graph: 'qwerty',
          turns: 1,
          shiftedCount: 6,
          options: options,
        );
        expect(
          spatialScoring(match, options),
          4320,
        );
      },
    );

    test(
      'Turns.',
      () {
        final SpatialMatch match = SpatialMatch(
          password: 'zxcft6yh',
          start: 0,
          end: 8,
          graph: 'qwerty',
          turns: 3,
          shiftedCount: 0,
          options: options,
        );
        expect(
          spatialScoring(match, options),
          558461,
        );
      },
    );
  });
}
