import 'dart:math';

import '../feedback.dart';
import 'base_matcher.dart';

/// The default match to use if there are no other matches.
class BruteForceMatch extends BaseMatch {
  /// Creates a match.
  BruteForceMatch({
    required String password,
    required int start,
    required int end,
  }) : super(password: password, start: start, end: end);

  @override
  double get estimatedGuesses {
    double guesses = pow(bruteForceCardinality, length).toDouble();
    if (guesses == double.infinity) guesses = double.maxFinite;
    // Small detail: make bruteforce matches at minimum one guess bigger than
    // smallest allowed match guesses, such that non-bruteforce matches
    // over the same [start:end] take precedence.
    final double minGuesses;
    if (length == 1) {
      minGuesses = minGuessesForSingleChar + 1;
    } else {
      minGuesses = minGuessesForMultiChar + 1;
    }
    return max(guesses, minGuesses);
  }

  /// The number of candidates to try for each password character.
  double get bruteForceCardinality => 10;

  @override
  Feedback? feedback({required bool isSoleMatch}) => null;
}
