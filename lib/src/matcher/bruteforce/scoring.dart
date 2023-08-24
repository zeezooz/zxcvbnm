import 'dart:math';

import '../../data/const.dart';
import '../../matchers/base_matcher.dart';

double bruteforceScoring(BaseMatch match) {
  double guesses =
      pow(bruteforceCardinality.toDouble(), match.length).toDouble();
  if (guesses == double.infinity) guesses = double.maxFinite;
  double minGuesses;
  // Small detail: make bruteforce matches at minimum one guess bigger than
  // smallest allowed submatch guesses, such that non-bruteforce submatches
  // over the same [i..j] take precedence.
  if (match.length == 1) {
    minGuesses = match.minGuessesForSingleChar + 1;
  } else {
    minGuesses = match.minGuessesForMultiChar + 1;
  }
  return max(guesses, minGuesses);
}
