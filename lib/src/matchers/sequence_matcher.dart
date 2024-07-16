import '../feedback.dart';
import '../languages/common/translation.dart';
import 'base_matcher.dart';

/// Matches sequences (abcdef).
class SequenceMatcher extends BaseMatcher {
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
    // [(start, end, delta), ...] = [(0, 4, 1), (5, 8, -2), (8, 10, 1)]
    final List<SequenceMatch> result = <SequenceMatch>[];
    if (password.length <= 1) return <List<SequenceMatch>>[result];
    int start = 0;
    int? lastDelta;
    for (int end = 1; end < password.length; end++) {
      final int delta = password.codeUnitAt(end) - password.codeUnitAt(end - 1);
      lastDelta ??= delta;
      if (delta != lastDelta) {
        _update(
          result: result,
          password: password,
          start: start,
          end: end,
          delta: lastDelta,
        );
        start = end - 1;
        lastDelta = delta;
      }
    }
    if (lastDelta != null) {
      _update(
        result: result,
        password: password,
        start: start,
        end: password.length,
        delta: lastDelta,
      );
    }
    return <List<SequenceMatch>>[result];
  }

  void _update({
    required List<SequenceMatch> result,
    required String password,
    required int start,
    required int end,
    required int delta,
  }) {
    final int absoluteDelta = delta.abs();
    if (end - start <= 2 && absoluteDelta != 1) return;
    if (absoluteDelta == 0 || absoluteDelta > _maxDelta) return;
    final String token = password.substring(start, end);
    String name = 'unicode';
    // Conservatively stick with roman alphabet size.
    int space = 26;
    if (_allLower.hasMatch(token)) {
      name = 'lower';
      space = 26;
    } else if (_allUpper.hasMatch(token)) {
      name = 'upper';
      space = 26;
    } else if (_allDigit.hasMatch(token)) {
      name = 'digits';
      space = 10;
    }
    return result.add(
      SequenceMatch(
        password: password,
        start: start,
        end: end,
        name: name,
        space: space,
        ascending: delta > 0,
      ),
    );
  }

  int get _maxDelta => 5;
  RegExp get _allLower => RegExp(r'^[a-z\xdf-\xff]+$');
  RegExp get _allUpper => RegExp(r'^[A-Z\xbf-\xdf]+$');
  RegExp get _allDigit => RegExp(r'^\d+$');
}

/// A match for a sequence.
class SequenceMatch extends BaseMatch {
  /// Creates a match.
  SequenceMatch({
    required String password,
    required int start,
    required int end,
    required this.name,
    required this.space,
    required this.ascending,
  }) : super(password: password, start: start, end: end);

  /// The name of the sequence.
  final String name;

  /// The number of possible variations for each character in the sequence.
  final int space;

  /// Whether the sequence is ascending.
  final bool ascending;

  @override
  double get estimatedGuesses {
    final String firstChar = password.substring(start, start + 1);
    const List<String> startingPoints = <String>[
      'a',
      'A',
      'z',
      'Z',
      '0',
      '1',
      '9',
    ];
    double baseGuesses;
    if (startingPoints.contains(firstChar)) {
      // Lower guesses for obvious starting points.
      baseGuesses = 4;
    } else if (RegExp(r'\d').hasMatch(firstChar)) {
      // Digits.
      baseGuesses = 10;
    } else {
      // Could give a higher base for uppercase,
      // assigning 26 to both upper and lower sequences is more conservative.
      baseGuesses = 26;
    }
    // Need to try a descending sequence in addition to every
    // ascending sequence -> 2x guesses
    if (!ascending) {
      baseGuesses *= 2;
    }
    return baseGuesses * length;
  }

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return Feedback(
      warning: Translation.warnings.sequences,
      suggestions: <String>[Translation.suggestions.sequences],
    );
  }

  @override
  String toString() => '${super.toString()}, sequenceName: $name, '
      'sequenceSpace: $space, ascending: $ascending';
}
