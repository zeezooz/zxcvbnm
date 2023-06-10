import 'dart:math';

import '../../data/const.dart';
import '../../types.dart';

double bruteforceScoring(Match match) {
  double guesses =
      pow(bruteforceCardinality.toDouble(), match.token.length).toDouble();
  if (guesses == double.infinity) guesses = double.maxFinite;
  double minGuesses;
  // Small detail: make bruteforce matches at minimum one guess bigger than
  // smallest allowed submatch guesses, such that non-bruteforce submatches
  // over the same [i..j] take precedence.
  if (match.token.length == 1) {
    minGuesses = minSubmatchGuessesSingleChar + 1;
  } else {
    minGuesses = minSubmatchGuessesMultiChar + 1;
  }
  return max(guesses, minGuesses);
}
