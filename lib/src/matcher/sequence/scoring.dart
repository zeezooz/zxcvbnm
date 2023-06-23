import '../../types.dart';

double sequenceScoring(SequenceMatch match) {
  final String firstChar = match.token.substring(0, 1);
  double baseGuesses;
  const List<String> startingPoints = <String>[
    'a',
    'A',
    'z',
    'Z',
    '0',
    '1',
    '9',
  ];
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
  if (!match.ascending) {
    baseGuesses *= 2;
  }
  return baseGuesses * match.token.length;
}
