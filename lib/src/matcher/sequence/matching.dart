import '../../data/const.dart';
import '../../types.dart';

/// Sequences (abcdef).
class MatchSequence extends MatchingType {
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
    for (int k = 1; k < passwordLength; k++) {
      final int delta = password.codeUnitAt(k) - password.codeUnitAt(k - 1);
      lastDelta ??= delta;
      if (delta != lastDelta) {
        final int j = k - 1;
        update(
          i: i,
          j: j,
          delta: lastDelta,
          password: password,
          result: result,
        );
        i = j;
        lastDelta = delta;
      }
    }
    if (lastDelta != null) {
      update(
        i: i,
        j: passwordLength - 1,
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
    if (j - i > 1 || absoluteDelta == 1) {
      if (absoluteDelta > 0 && absoluteDelta <= _maxDelta) {
        final String token = password.substring(i, j + 1);
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
            i: i,
            j: j,
            token: token,
            sequenceName: sequenceName,
            sequenceSpace: sequenceSpace,
            ascending: delta > 0,
          ),
        );
      }
    }
  }
}
