import 'dart:math';

import '../../data/const.dart';
import '../../types.dart';

num bruteforceScoring(Match match) {
  final String token = match.token;
  num guesses = pow(bruteforceCardinality.toDouble(), token.length);
  if (guesses == double.infinity) {
    guesses = double.maxFinite;
  }
  num minGuesses;
  // small detail: make bruteforce matches at minimum one guess bigger than smallest allowed
  // submatch guesses, such that non-bruteforce submatches over the same [i..j] take precedence.
  if (token.length == 1) {
    minGuesses = minSubmatchGuessesSingleChar + 1;
  } else {
    minGuesses = minSubmatchGuessesMultiChar + 1;
  }
  return max(guesses, minGuesses);
}
