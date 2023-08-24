import 'dart:math';

import '../../types.dart';

double dictionaryScoring(DictionaryMatch match) {
  // Keep these as properties for display purposes.
  final int baseGuesses = match.rank;
  final double uppercaseVariations = match.uppercaseVariations;
  final double l33tVariations = match.l33tVariations;
  final int reversedVariations = match is ReverseMatch ? 2 : 1;
  double calculation;
  if (match.dictionary == Dictionary.diceware) {
    // Diceware dictionaries are special, so we get a simple scoring of
    // 1/2 of 6^5 (6 digits on 5 dice).
    // To get fix entropy of ~12.9 bits for every entry
    // https://en.wikipedia.org/wiki/Diceware#:~:text=The%20level%20of,bits
    calculation = pow(6, 5) / 2;
  } else {
    calculation =
        baseGuesses * uppercaseVariations * l33tVariations * reversedVariations;
  }
  return calculation;
}
