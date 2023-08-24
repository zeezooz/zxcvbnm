import '../../data/const.dart';
import '../../matchers/base_matcher.dart';
import '../../options.dart';
import '../../types.dart';

/// Sequences (abcdef).
class MatchSequence extends BaseMatcher {
  MatchSequence(this.options);

  final Options options;

  static const int _maxDelta = 5;

  @override
  List<List<SequenceMatch>> match(String password) {
    // Identifies sequences by looking for repeated differences in unicode
    // codepoint. This allows skipping, such as 9753, and also matches some
    // extended unicode sequences such as Greek and Cyrillic alphabets.
    //
    // For example, consider the input 'abcdb975zy'
    // password: a   b   c   d   b    9   7   5   z   y
    // index:    0   1   2   3   4    5   6   7   8   9
    // delta:        1   1   1  -2  -41  -2  -2  69   1
    //
    // Expected result:
    // [(i, j, delta), ...] = [(0, 3, 1), (5, 7, -2), (8, 9, 1)]
    final List<SequenceMatch> result = <SequenceMatch>[];
    if (password.length <= 1) return <List<SequenceMatch>>[result];
    int i = 0;
    int? lastDelta;
    final int passwordLength = password.length;
    for (int j = 1; j < passwordLength; j++) {
      final int delta = password.codeUnitAt(j) - password.codeUnitAt(j - 1);
      lastDelta ??= delta;
      if (delta != lastDelta) {
        update(
          i: i,
          j: j,
          delta: lastDelta,
          password: password,
          result: result,
        );
        i = j - 1;
        lastDelta = delta;
      }
    }
    if (lastDelta != null) {
      update(
        i: i,
        j: passwordLength,
        delta: lastDelta,
        password: password,
        result: result,
      );
    }
    return <List<SequenceMatch>>[result];
  }

  void update({
    required int i,
    required int j,
    required int delta,
    required String password,
    required List<SequenceMatch> result,
  }) {
    final int absoluteDelta = delta.abs();
    if (j - i > 2 || absoluteDelta == 1) {
      if (absoluteDelta > 0 && absoluteDelta <= _maxDelta) {
        final String token = password.substring(i, j);
        // TODO: Conservatively stick with roman alphabet size.
        // (This could be improved)
        String sequenceName = 'unicode';
        int sequenceSpace = 26;
        if (allLower.hasMatch(token)) {
          sequenceName = 'lower';
          sequenceSpace = 26;
        } else if (allUpper.hasMatch(token)) {
          sequenceName = 'upper';
          sequenceSpace = 26;
        } else if (allDigit.hasMatch(token)) {
          sequenceName = 'digits';
          sequenceSpace = 10;
        }
        return result.add(
          SequenceMatch(
            password: password,
            start: i,
            end: j,
            sequenceName: sequenceName,
            sequenceSpace: sequenceSpace,
            ascending: delta > 0,
            options: options,
          ),
        );
      }
    }
  }
}
