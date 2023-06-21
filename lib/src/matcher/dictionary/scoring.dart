import 'dart:math';

import '../../types.dart';
import 'variants/scoring/l33t.dart';
import 'variants/scoring/uppercase.dart';

class DictionaryReturn {
  const DictionaryReturn({
    required this.baseGuesses,
    required this.uppercaseVariations,
    required this.l33tVariations,
    required this.calculation,
  });

  final int baseGuesses;
  final double uppercaseVariations;
  final double l33tVariations;
  final double calculation;

  @override
  String toString() => 'baseGuesses: $baseGuesses, '
      'uppercaseVariations: $uppercaseVariations, '
      'l33tVariations: $l33tVariations, calculation: $calculation';
}

DictionaryReturn dictionaryScoring(DictionaryMatch match) {
  // Keep these as properties for display purposes.
  final int baseGuesses = match.rank;
  final double uppercaseVariations = uppercaseScoring(match);
  final double l33tVariations = l33tScoring(match);
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
  return DictionaryReturn(
    baseGuesses: baseGuesses,
    uppercaseVariations: uppercaseVariations,
    l33tVariations: l33tVariations,
    calculation: calculation,
  );
}
