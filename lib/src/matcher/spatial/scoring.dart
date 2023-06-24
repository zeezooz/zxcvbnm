import 'dart:math';

import '../../options.dart';
import '../../scoring/utils.dart';
import '../../types.dart';

double spatialScoring(SpatialMatch match, Options options) {
  double guesses = _estimatePossiblePatterns(match, options);
  // Add extra guesses for shifted keys (% instead of 5, A instead of a).
  // Math is similar to extra guesses of l33t substitutions in dictionary
  // matches.
  if (match.shiftedCount > 0) {
    final int unShiftedCount = match.token.length - match.shiftedCount;
    if (unShiftedCount == 0) {
      guesses *= 2;
    } else {
      double shiftedVariations = 0;
      for (int i = 1; i <= min(match.shiftedCount, unShiftedCount); i++) {
        shiftedVariations += nCk(match.shiftedCount + unShiftedCount, i);
      }
      guesses *= shiftedVariations;
    }
  }
  return guesses.roundToDouble();
}

double _estimatePossiblePatterns(SpatialMatch match, Options options) {
  double guesses = 0;
  final int startingPosition = options.graph[match.graph]?.keys.length ?? 0;
  final double averageDegree = _averageDegree(options.graph[match.graph]);
  // Estimate the number of possible patterns with token length or less with
  // turns or less.
  for (int i = 2; i <= match.token.length; i++) {
    final int possibleTurns = min(match.turns, i - 1);
    for (int j = 1; j <= possibleTurns; j++) {
      guesses += nCk(i - 1, j - 1) * startingPosition * pow(averageDegree, j);
    }
  }
  return guesses;
}

double _averageDegree(GraphEntry? graph) {
  double average = 0;
  for (final String key in graph?.keys ?? <String>[]) {
    final List<String?> neighbors = graph![key]!;
    average += neighbors.where((String? entry) => entry != null).length;
  }
  average /= graph?.keys.length ?? 1;
  return average;
}
